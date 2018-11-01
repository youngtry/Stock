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
@property(nonatomic,strong)UIButton* stockNameBtn;
@end

@implementation PendingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.data = [NSMutableArray new];
    self.allStocks = [NSMutableArray new];
    self.currentPage = 0;
    self.isUpdate = YES;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.stockList];
    [self.stockList setHidden:YES];
    [self.data removeAllObjects];
    [self.allStocks removeAllObjects];
    
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
        [HUDUtil showSystemTipView:temp title:@"提示" withContent:@"未登录,请先登录"];
        return;
    }
    [self getAllStocks];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isUpdate = YES;
    self.currentPage = 0;
    [self.data removeAllObjects];
    [self.allStocks removeAllObjects];
    
    [self.stockList reloadData];
    [self.tableView reloadData];
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
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                if([[data objectForKey:@"data"] objectForKey:@"tabs"]){
                    NSArray* tabs = [[data objectForKey:@"data"] objectForKey:@"tabs"];
                    for (NSDictionary* tab in tabs) {
                        NSString* tabtitle = [tab objectForKey:@"asset"];
                        NSDictionary* parameters1 = @{@"order_by":@"price",
                                                     @"order":@"desc",
                                                     @"asset":tabtitle
                                                     };
                        NSString* url1 = @"market/item";
                        NSLog(@"*******************");
                        [[HttpRequest getInstance] postWithURL:url1 parma:parameters1 block:^(BOOL success, id data1) {
                            if(success){
//                                NSLog(@"list = %@",data);
                                if([[data1 objectForKey:@"ret"] intValue] == 1){
                                    NSArray* stocks = [[data1 objectForKey:@"data"] objectForKey:@"items"];
                                    [self.allStocks addObjectsFromArray:stocks];
                                    if(self.allStocks && self.allStocks.count != 0){
                                        NSLog(@"self.allStocks.count = %ld",self.allStocks.count);
                                        NSDictionary* info = self.allStocks[0];
                                        [self.stockNameBtn setTitle:[info objectForKey:@"market"] forState:UIControlStateNormal];
                                        [self.data removeAllObjects];
                                        [self getAllHistory:1 WithName:self.stockNameBtn.titleLabel.text];
                                        [self.stockList reloadData];
                                    }
                                }
                            }
                        }];
                    }
                }
            }else{
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

-(void)getAllHistory:(NSInteger)page WithName:(NSString*)name{
    //    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    self.currentPage = page;
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"market":name,
                             @"page":@(page),
                             @"page_limit":@(10),
                             };
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* trades = [[data objectForKey:@"data"] objectForKey:@"trades"];
                if(trades.count == 0){
                    self.isUpdate = NO;
                    [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"已经全部加载完毕"];
                }else{
                    [self.data addObjectsFromArray:trades];
                    [self.tableView reloadData];
                }
                
                //                NSLog(@"data = %@",self.data);
            }else{
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
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

-(void)addHeader{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
    header.backgroundColor = kColor(200, 200, 200);
    {
        UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0f, 50)];
        left.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16,0,45,14)];
        lab.font = kTextFont(14);
        lab.textColor = kColor(128,128,128);
        lab.text = @"股票：";
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
        lab.text = @"委托：";
        [right addSubview:lab];
        lab.centerY = right.centerY;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(lab.right+2, 0, 90, 20)];
        [btn setTitle:@"普通委托" forState:UIControlStateNormal];
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
    }
}

-(void)clickType:(id)sender{
    
}

-(void)sendCancelNotice:(BOOL)success withReason:(NSString *)msg{
    if(success){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"撤销成功"];
        self.currentPage = 0;
        [self.data removeAllObjects];
        self.isUpdate = YES;
        [self getAllHistory:1 WithName:self.stockNameBtn.titleLabel.text];
    }else{
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:msg];
    }
}

#pragma mark - TableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tableView){
        return self.data.count;
    }else if (tableView == self.stockList){
        return self.allStocks.count;
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
                cell.typeLabel.text = @"买入";
                cell.isBuyIn = YES;
            }else if ([type isEqualToString:@"sell"]){
                cell.typeLabel.text = @"卖出";
                cell.isBuyIn = NO;
            }
            cell.priceLabel.text = [data objectForKey:@"price"];
            cell.amountLabel.text = [data objectForKey:@"num"];
            cell.realLabel.text = [data objectForKey:@"deal_money"];
            cell.tradeID = [data objectForKey:@"id"];
        }
        
        
        return cell;
    }else if (tableView == self.stockList){
        
        TradeStockSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TradeStockSelectTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        NSDictionary* data = self.allStocks[indexPath.row];
        
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
    }
    return 105.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.tableView){
        NSDictionary* data = self.data[indexPath.row];
        EntryOrderDetailVC *vc = [[EntryOrderDetailVC alloc] initWithNibName:@"EntryOrderDetailVC" bundle:nil];
        UINavigationController *nav = (UINavigationController*)[Util getParentVC:[UINavigationController class] fromView:self.view];
        int stockid = [[data objectForKey:@"id"] intValue];
        NSLog(@"stockid = %d",stockid);
        vc.title = [NSString stringWithFormat:@"%d",stockid];
        [nav pushViewController:vc animated:YES];
    }else if(tableView == self.stockList){
        self.isUpdate = YES;
        TradeStockSelectTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [_stockNameBtn setTitle:cell.name.text forState:UIControlStateNormal];
        [self.stockList setHidden:YES];
        [self.data removeAllObjects];
        [self getAllHistory:1 WithName:self.stockNameBtn.titleLabel.text];
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if((UITableView*)scrollView == self.stockList){
        return;
    }
    if(!self.isUpdate){
        
        return;
    }
    if(self.isUpdate && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
        [self getAllHistory:self.currentPage+1 WithName:self.stockNameBtn.titleLabel.text];
    }
}

@end
