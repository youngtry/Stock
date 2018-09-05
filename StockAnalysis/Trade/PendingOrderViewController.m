//
//  PendingOrderViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PendingOrderViewController.h"
#import "PendingOrderTableViewCell.h"
@interface PendingOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@end

@implementation PendingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [NSMutableArray new];
    
    [self.view addSubview:self.tableView];
    
    //header
    [self addHeader];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNaviHeight-kTabBarHeight-kScrollTitleHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(lab.right+2, 0, 90, 20)];
        [btn setTitle:@"双成药业" forState:UIControlStateNormal];
        [btn setTitleColor:kColor(64,64,64) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.size.width, 0, btn.imageView.size.width)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [left addSubview:btn];
        btn.centerY = left.centerY;
        
        [header addSubview:left];
        [btn addTarget:self action:@selector(clickStock:) forControlEvents:UIControlEventTouchUpInside];
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
    
}

-(void)clickType:(id)sender{
    
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
