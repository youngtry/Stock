//
//  PendingOrderViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PendingOrderViewController.h"
#import "PendingOrderTableViewCell.h"
#import "EntryOrderDetailVC.h"
#import "TradeStockSelectTableViewCell.h"

@interface PendingOrderViewController ()<UITableViewDelegate,UITableViewDataSource,CancelDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL isUpdate;
@property(nonatomic,strong)NSMutableArray* allStocks;
@property(nonatomic,strong)UITableView* stockList;
@property(nonatomic,strong)NSMutableArray* allDetailStocks;
@property(nonatomic,strong)UITableView* stockDetailList;
@property(nonatomic,strong)UIButton* stockNameBtn;
@property(nonatomic,assign)NSInteger currentPage1;
@property(nonatomic,assign)BOOL isUpdate1;
@property(nonatomic,strong)UILabel* noPendingLabel;
@end

@implementation PendingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [NSMutableArray new];
    self.allStocks = [NSMutableArray new];
    self.allDetailStocks = [NSMutableArray new];
    self.currentPage = 0;
    self.isUpdate = YES;
    
    self.currentPage1 = 0;
    self.isUpdate1 = YES;
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.noPendingLabel];
    [self.noPendingLabel setHidden:YES];
    
    [self.view addSubview:self.stockList];
    [self.view addSubview:self.stockDetailList];
    [self.stockList setHidden:YES];
    [self.stockDetailList setHidden:YES];
    [self.data removeAllObjects];
    [self.allStocks removeAllObjects];
    [self.allDetailStocks removeAllObjects];
    self.tableView.tableFooterView = [UIView new];
    
    
    
    
    [self.stockList reloadData];
    [self.tableView reloadData];
    
    //header
    [self addHeader];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    [self getAllHistory:1 WithName:@""];
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
//        [HUDUtil showSystemTipView:temp title:Localize(@"Menu_Title") withContent:Localize(@"Login_Tip")];
        return;
    }
    [self getAllStocks];
    
    [self.stockNameBtn setTitle:Localize(@"All") forState:UIControlStateNormal];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.allStocks removeAllObjects];
    self.currentPage = 0;
    self.isUpdate = YES;
    
    self.currentPage1 = 0;
    self.isUpdate1 = YES;
    [self getAllStocks];
    if([self.stockNameBtn.titleLabel.text isEqualToString:Localize(@"All")]){
        [self getAll:1  withName:@""];
    }else{
        [self getAllHistory:1 WithName:self.stockNameBtn.titleLabel.text];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.isUpdate = YES;
//    self.currentPage = 0;
//    [self.data removeAllObjects];
//    [self.allStocks removeAllObjects];
//    
//    [self.stockList reloadData];
//    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllStocks{
    NSDictionary* parameters = @{};
    NSString* url = @"market/assortment";
    
    
    [self.allStocks removeAllObjects];
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                if([[data objectForKey:@"data"] objectForKey:@"tabs"]){
                    NSArray* tabs = [[data objectForKey:@"data"] objectForKey:@"tabs"];
                    [weakSelf.allStocks removeAllObjects];
                    [weakSelf.allStocks addObject:Localize(@"All")];
                    
                    for (NSDictionary* tab in tabs) {
                        NSString* asset = [tab objectForKey:@"asset"];
                        [weakSelf.allStocks addObject:asset];
                    }
                    
                    [weakSelf.stockList reloadData];
                    
                    
                }
            }else{
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

-(void)getAllHistory:(NSInteger)page WithName:(NSString*)name{
    //    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(page == 1){
        [self.data removeAllObjects];
    }
    self.currentPage = page;
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"market":name,
                             @"page":@(page),
                             @"page_limit":@(10),
                             @"state":@"pending"
                             };
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* trades = [[data objectForKey:@"data"] objectForKey:@"trades"];
                if(trades.count == 0){
                    if(weakSelf.data.count == 0){
//                        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"无数据"];
                        [weakSelf.noPendingLabel setHidden:NO];
                    }else{
                        [weakSelf.noPendingLabel setHidden:YES];
                        weakSelf.isUpdate = NO;
                        [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:Localize(@"Load_Finish")];
                    }
                    
                }else{
                    [weakSelf.noPendingLabel setHidden:YES];
                    [weakSelf.data addObjectsFromArray:trades];
                    [weakSelf.tableView reloadData];
                }
                
                //                NSLog(@"data = %@",self.data);
            }else{
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

-(UILabel*)noPendingLabel{
    if(nil == _noPendingLabel){
        _noPendingLabel = [UILabel new];
        [_noPendingLabel setFrame:CGRectMake(0, kScreenHeight*0.3, kScreenWidth, 90)];
        [_noPendingLabel setFont:[UIFont systemFontOfSize:14]];
        [_noPendingLabel setText:Localize(@"NO_Price")];
        [_noPendingLabel setTextColor:[UIColor grayColor]];
        [_noPendingLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _noPendingLabel;
}



-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNaviHeight-kTabBarHeight-kScrollTitleHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UITableView*)stockList{
    if(!_stockList){
        _stockList = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth*0.15, 50, kScreenWidth*0.35, (kScreenHeight-kNaviHeight-kTabBarHeight-kScrollTitleHeight)/2) style:UITableViewStylePlain];
        _stockList.delegate = self;
        _stockList.dataSource = self;
        [_stockList setBackgroundColor:kColor(245, 245, 249)];
    }
    return _stockList;
}

-(UITableView*)stockDetailList{
    if(!_stockDetailList){
        _stockDetailList = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth*0.15+kScreenWidth*0.35, 50, kScreenWidth*0.4, (kScreenHeight-kNaviHeight-kTabBarHeight-kScrollTitleHeight)/2) style:UITableViewStylePlain];
        _stockDetailList.delegate = self;
        _stockDetailList.dataSource = self;
        [_stockDetailList setBackgroundColor:kColor(245, 245, 249)];
    }
    return _stockDetailList;
}

-(void)addHeader{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
    header.backgroundColor = kColor(200, 200, 200);
    {
        UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0f, 50)];
        left.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16,0,45,14)];
        lab.font = kTextFont(14);
        lab.textColor = kColor(128,128,128);
        lab.text = [NSString stringWithFormat:@"%@: ",Localize(@"Share")];
        [left addSubview:lab];
        lab.centerY = left.centerY;
        
        _stockNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(lab.right+2, 0, 90, 20)];
        [_stockNameBtn setTitle:@"双成药业" forState:UIControlStateNormal];
        [_stockNameBtn setTitleColor:kColor(64,64,64) forState:UIControlStateNormal];
        [_stockNameBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [_stockNameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_stockNameBtn.imageView.size.width, 0, _stockNameBtn.imageView.size.width)];
        [_stockNameBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _stockNameBtn.titleLabel.bounds.size.width, 0, -_stockNameBtn.titleLabel.bounds.size.width)];
        [_stockNameBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [left addSubview:_stockNameBtn];
        _stockNameBtn.centerY = left.centerY;
        
        [header addSubview:left];
        [_stockNameBtn addTarget:self action:@selector(clickStock:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    {
        UIView *right = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0f, 0, kScreenWidth/2.0f, 50)];
        right.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16,0,45,14)];
        lab.font = kTextFont(14);
        lab.textColor = kColor(128,128,128);
        lab.text = Localize(@"Entrust");
        [right addSubview:lab];
        lab.centerY = right.centerY;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(lab.right+2, 0, 90, 20)];
        [btn setTitle:Localize(@"Normal_Entrust") forState:UIControlStateNormal];
        [btn setTitleColor:kColor(64,64,64) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.size.width, 0, btn.imageView.size.width)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [right addSubview:btn];
        btn.centerY = right.centerY;
        
        [header addSubview:right];
        [btn addTarget:self action:@selector(clickType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.tableView.tableHeaderView = header;
}

-(void)clickStock:(id)sender{
    if([self.stockList isHidden]){
        [self.stockList setHidden:NO];
    }else{
        [self.stockList setHidden:YES];
        [self.stockDetailList setHidden:YES];
    }
}

-(void)clickType:(id)sender{
    
}

-(void)sendCancelNotice:(BOOL)success withReason:(NSString *)msg{
    if(success){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:Localize(@"Cancel_Succ")];
        self.currentPage = 0;
        [self.data removeAllObjects];
        self.isUpdate = YES;
        if([self.stockNameBtn.titleLabel.text isEqualToString:Localize(@"All")]){
            [self.data removeAllObjects];
            [self.tableView reloadData];
            self.isUpdate = YES;
            self.isUpdate1 = YES;
            [self getAll:1 withName:@""];
        }else{
            [self.data removeAllObjects];
            [self.tableView reloadData];
            [self getAllHistory:1 WithName:self.stockNameBtn.titleLabel.text];
        }
        
    }else{
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:msg];
    }
}

-(void)getAll:(NSInteger)page withName:(NSString*)name{
    if(page == 1){
        [self.data removeAllObjects];
    }
    self.currentPage1 = page;
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"page":@(page),
                             @"page_limit":@(10),
                             @"state":@"pending",
                             @"market":name
                             };
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* trades = [[data objectForKey:@"data"] objectForKey:@"trades"];
                if(trades.count == 0){
                    if(weakSelf.data.count == 0){
//                        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"无数据"];
                        [weakSelf.noPendingLabel setHidden:NO];
                    }else{
                        [weakSelf.noPendingLabel setHidden:YES];
                        weakSelf.isUpdate1 = NO;
                        [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:Localize(@"Load_Finish")];
                    }
                    
                }else{
                    [weakSelf.noPendingLabel setHidden:YES];
                    [weakSelf.data addObjectsFromArray:trades];
                    [weakSelf.tableView reloadData];
                }
                
                //                NSLog(@"data = %@",self.data);
            }else{
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

-(void)getDetailMarket:(NSString*)name{
    NSDictionary* parameters = @{@"order_by":@"price",
                                 @"order":@"desc",
                                 @"asset":name
                                 };
    NSString* url = @"market/item";
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* item = [[data objectForKey:@"data"] objectForKey:@"items"];
                [weakSelf.allDetailStocks removeAllObjects];
                [weakSelf.allDetailStocks addObjectsFromArray:item];
                [weakSelf.stockDetailList reloadData];
            }
        }
    }];
}

#pragma mark - TableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tableView){
        return self.data.count;
    }else if (tableView == self.stockList){
        return self.allStocks.count;
    }else if (tableView == self.stockDetailList){
        return self.allDetailStocks.count;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.tableView){
        PendingOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PendingOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.delegate = self;
        if(self.data.count>indexPath.row){
            NSDictionary* data = self.data[indexPath.row];
            
            cell.stockName.text = [data objectForKey:@"market"];
            cell.timeLabel.text = [data objectForKey:@"updated_at"];
            NSString* type = [data objectForKey:@"mode"];
            if([type isEqualToString:@"buy"]){
                cell.typeLabel.text = Localize(@"Buy");
                cell.isBuyIn = YES;
            }else if ([type isEqualToString:@"sell"]){
                cell.typeLabel.text = Localize(@"Sell");
                cell.isBuyIn = NO;
            }
            cell.priceLabel.text = [NSString stringWithFormat:@"%.8lf",[[data objectForKey:@"price"] doubleValue]] ;
            cell.amountLabel.text = [NSString stringWithFormat:@"%.8lf",[[data objectForKey:@"num"] doubleValue]] ;
            cell.realLabel.text = [NSString stringWithFormat:@"%.8lf",[[data objectForKey:@"deal_money"] doubleValue]] ;
            cell.tradeID = [data objectForKey:@"id"];
        }
        
        
        return cell;
    }else if (tableView == self.stockList){
        
        TradeStockSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TradeStockSelectTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        NSString* data = self.allStocks[indexPath.row];
        
        NSString* name = data;
        
        cell.name.text = name;
        
        return cell;
    }else if (tableView == self.stockDetailList){
        TradeStockSelectTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TradeStockSelectTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        NSDictionary* data = self.allDetailStocks[indexPath.row];
        
        NSString* name = [data objectForKey:@"market"];
        
        cell.name.text = name;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView){
        return 105.0f;
    }else if (tableView == self.stockList){
        return 40.0f;
    }else if (tableView == self.stockDetailList){
        return 40.0f;
    }
    return 105.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.tableView){
//        NSDictionary* data = self.data[indexPath.row];
//        EntryOrderDetailVC *vc = [[EntryOrderDetailVC alloc] initWithNibName:@"EntryOrderDetailVC" bundle:nil];
//        UINavigationController *nav = (UINavigationController*)[Util getParentVC:[UINavigationController class] fromView:self.view];
//        int stockid = [[data objectForKey:@"id"] intValue];
//        NSLog(@"stockid = %d",stockid);
//        vc.title = [NSString stringWithFormat:@"%d",stockid];
//        [nav pushViewController:vc animated:YES];
    }else if(tableView == self.stockList){
        
        TradeStockSelectTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [self.stockList setHidden:NO];
        [self.stockDetailList setHidden:NO];
//        [self.stockNameBtn setTitle:cell.name.text forState:UIControlStateNormal];
        if([cell.name.text isEqualToString:Localize(@"All")]){
            [self.data removeAllObjects];
            [self.tableView reloadData];
            [self.stockNameBtn setTitle:cell.name.text forState:UIControlStateNormal];
            self.isUpdate = YES;
            [self.stockList setHidden:YES];
            [self.stockDetailList setHidden:YES];
            self.isUpdate1 = YES;
            [self getAll:1 withName:@""];
        }else{
            [self getDetailMarket:cell.name.text];
        }
        
        
    }else if(tableView == self.stockDetailList){
        self.isUpdate = YES;
        [self.stockList setHidden:YES];
        [self.stockDetailList setHidden:YES];
        
        TradeStockSelectTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [_stockNameBtn setTitle:cell.name.text forState:UIControlStateNormal];
        [self.data removeAllObjects];
        [self.tableView reloadData];
        [self getAllHistory:1 WithName:cell.name.text];
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if((UITableView*)scrollView == self.stockList || (UITableView*)scrollView == self.stockDetailList){
        return;
    }
    
    if([self.stockNameBtn.titleLabel.text isEqualToString:Localize(@"All")]){
        if(!self.isUpdate1){
            
            return;
        }
        if(self.isUpdate1 && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
            [self getAll:self.currentPage1+1  withName:@""];
        }
    
    }else{
        if(!self.isUpdate){
            
            return;
        }
        if(self.isUpdate && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
            [self getAllHistory:self.currentPage+1 WithName:self.stockNameBtn.titleLabel.text];
        }
    }
    
}

@end
