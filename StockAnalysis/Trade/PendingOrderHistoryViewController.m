//
//  PendingOrderHistoryViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PendingOrderHistoryViewController.h"
#import "PendingOrderTableViewCell.h"
@interface PendingOrderHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@end

@implementation PendingOrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = [NSMutableArray new];
    
    [self.view addSubview:self.tableView];
    
    //header
    [self addHeader];
    
    self.title = @"历史记录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNaviHeight-kTabBarHeight) style:UITableViewStylePlain];
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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn setTitleColor:kThemeYellow forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PendingOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PendingOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0f;
}

@end
