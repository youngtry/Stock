//
//  FeedbackMyListVC.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "FeedbackMyListVC.h"

@interface FeedbackMyListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray*data;
@end

@implementation FeedbackMyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = @[@{@"a":@"API连接不上或返回403-API问题",@"b":@"好像我尝试了但是不知道怎么没有值",@"c":@"2018-05-20 02:06:22",@"d":@"未分配"},
              @{@"a":@"API连接不上或返回403-API问题",@"b":@"好像我尝试了但是不知道怎么没有值",@"c":@"2018-05-20 02:06:22",@"d":@"解决中"},
              @{@"a":@"API连接不上或返回403-API问题",@"b":@"好像我尝试了但是不知道怎么没有值",@"c":@"2018-05-20 02:06:22",@"d":@"已解决"},
              ];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNaviHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(nil==cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, 260, 15)];
        lab1.font = kTextFont(18);
        lab1.textColor = kColor(0, 0, 0);
        lab1.tag = 101;
        [cell.contentView addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 43, 250, 13)];
        lab2.font = kTextFont(15);
        lab2.textColor = kColor(125,125,125);
        lab2.tag = 102;
        [cell.contentView addSubview:lab2];
        
        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 68, 250, 12)];
        lab3.font = kTextFont(12);
        lab3.textColor = kColor(125,125,125);
        lab3.tag = 103;
        [cell.contentView addSubview:lab3];
        
        UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(0,18, 50, 15)];
        lab4.right = kScreenWidth-16;
        lab4.textAlignment = NSTextAlignmentRight;
        lab4.font = kTextFont(13);
        lab4.textColor = kColor(125,125,125);
        lab4.tag = 104;
        [cell.contentView addSubview:lab4];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *lab1 = [cell.contentView viewWithTag:101];
    UILabel *lab2 = [cell.contentView viewWithTag:102];
    UILabel *lab3 = [cell.contentView viewWithTag:103];
    UILabel *lab4 = [cell.contentView viewWithTag:104];
    
    NSDictionary *dic = _data[indexPath.row];
    lab1.text = dic[@"a"];
    lab2.text = dic[@"b"];
    lab3.text = dic[@"c"];
    lab4.text = dic[@"d"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
@end
