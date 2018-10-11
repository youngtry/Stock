//
//  PendingOrderHistoryViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PendingOrderHistoryViewController.h"
#import "PendingOrderTableViewCell.h"
#import "EntryOrderDetailVC.h"
@interface PendingOrderHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,CancelDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL isUpdate;
@end

@implementation PendingOrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = [NSMutableArray new];
    self.currentPage = 0;
    self.isUpdate = YES;
    
    [self.view addSubview:self.tableView];
    
    //header
    [self addHeader];
    
    self.title = @"历史记录";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.currentPage = 0;
    self.isUpdate = YES;
    [self.data removeAllObjects];
    [self getAllHistory:1];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    [self.data removeAllObjects];
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendCancelNotice:(BOOL)success withReason:(NSString *)msg{
    if(success){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"撤销成功"];
        self.currentPage = 0;
        self.isUpdate = YES;
        [self.data removeAllObjects];
        [self getAllHistory:1];
    }else{
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:msg];
    }
}

-(void)getAllHistory:(NSInteger)page{
//    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    self.currentPage = page;
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"page":@(page),
                             @"page_limit":@(10),
                             };
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        [HUDUtil hideHudView];
        if(success){
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(void)addHeader{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 120, 26)];
    lab.font = kTextBoldFont(26);
    lab.textColor = kColor(0, 0, 0);
    lab.text = @"历史挂单";
    [header addSubview:lab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.15, 20)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn setTitleColor:kThemeYellow forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Path"] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.size.width, 0, btn.imageView.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
    btn.centerY = lab.centerY;
    btn.right = kScreenWidth - 16;
    [header addSubview:btn];
    self.tableView.tableHeaderView = header;
}
#pragma mark - TableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.data.count;
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PendingOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PendingOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.delegate = self;
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
        [self getAllHistory:self.currentPage+1];
    }
}



@end
