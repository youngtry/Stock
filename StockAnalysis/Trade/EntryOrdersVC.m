//
//  EntryOrdersVC.m
//  StockAnalysis
//
//  Created by ymx on 2018/8/15.
//  Copyright © 2018年 try. All rights reserved.
//

#import "EntryOrdersVC.h"
#import "PendingOrderTableViewCell.h"
#import "EntryOrderDetailVC.h"
@interface EntryOrdersVC ()<UITableViewDelegate,UITableViewDataSource,CancelDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL isUpdate;
@end

@implementation EntryOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.data = [NSMutableArray new];
    self.isUpdate = YES;
    self.currentPage = 0;
    [self.view addSubview:self.tableView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if(self.state == Trade_All){
        [self getAllList:1];
    }else if (self.state == Trade_BuyIn){
        [self getBuyList:1];
    }else if (self.state == Trade_SoldOut){
        [self getSellList:1];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.data removeAllObjects];
    [self.tableView reloadData];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight-kScrollTitleHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(void)clickStock:(id)sender{
    
}

-(void)clickType:(id)sender{
    
}

-(void)sendCancelNotice:(BOOL)success withReason:(NSString *)msg{
    if(success){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"撤销成功"];
        self.currentPage = 0;
        self.isUpdate = YES;
        if(self.state == Trade_All){
            [self getAllList:1];
        }else if (self.state == Trade_BuyIn){
            [self getBuyList:1];
        }else if (self.state == Trade_SoldOut){
            [self getSellList:1];
        }
    }else{
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:msg];
    }
}

-(void)getAllList:(NSInteger) page{
    self.currentPage = page;
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"page":@(page),
                             @"page_limit":@(10),
                             };
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
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

-(void)getBuyList:(NSInteger) page{
    self.currentPage = page;
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"page":@(page),
                             @"page_limit":@(10),
                             @"mode":@"buy"
                             };
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* trades = [[data objectForKey:@"data"] objectForKey:@"trades"];
                if(trades.count == 0){
                    self.isUpdate = NO;
                    [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"已经全部加载完毕"];
                }else{
                    for (NSDictionary* item in trades) {
                        if([[item objectForKey:@"mode"] isEqualToString:@"buy"]){
                            [self.data addObject:item];
                        }
                    }
                    [self.tableView reloadData];
                }
                
                //                NSLog(@"data = %@",self.data);
            }else{
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

-(void)getSellList:(NSInteger) page{
    self.currentPage = page;
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"page":@(page),
                             @"page_limit":@(10),
                             @"mode":@"sell"
                             };
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* trades = [[data objectForKey:@"data"] objectForKey:@"trades"];
                if(trades.count == 0){
                    self.isUpdate = NO;
                    [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"已经全部加载完毕"];
                }else{
                    for (NSDictionary* item in trades) {
                        if([[item objectForKey:@"mode"] isEqualToString:@"sell"]){
                            [self.data addObject:item];
                        }
                    }
                    [self.tableView reloadData];
                }
                
                //                NSLog(@"data = %@",self.data);
            }else{
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

#pragma mark - TableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        [cell.cancelBtn setHidden:YES];
        [cell.stateLabel setHidden:NO];
        
        if([[data objectForKey:@"state"] isEqualToString:@"pending"]){
            [cell.cancelBtn setHidden:NO];
            [cell.stateLabel setHidden:YES];
        }
        
        if([[data objectForKey:@"state"] isEqualToString:@"done"]){
            cell.stateLabel.text = @"已完成";
        }
        
        if([[data objectForKey:@"state"] isEqualToString:@"cancel"]){
            cell.stateLabel.text = @"已撤销";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* data = self.data[indexPath.row];
    EntryOrderDetailVC *vc = [[EntryOrderDetailVC alloc] initWithNibName:@"EntryOrderDetailVC" bundle:nil];
    UINavigationController *nav = (UINavigationController*)[Util getParentVC:[UINavigationController class] fromView:self.view];
    int stockid = [[data objectForKey:@"id"] intValue];
    NSLog(@"stockid = %d",stockid);
    vc.title = [NSString stringWithFormat:@"%d",stockid];
    [nav pushViewController:vc animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if(!self.isUpdate){
        
        return;
    }
    if(self.isUpdate && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
        if(self.state == Trade_All){
            [self getAllList:self.currentPage+1];
        }else if (self.state == Trade_BuyIn){
            [self getBuyList:self.currentPage+1];
        }else if (self.state == Trade_SoldOut){
            [self getSellList:self.currentPage+1];
        }
    }
}
@end
