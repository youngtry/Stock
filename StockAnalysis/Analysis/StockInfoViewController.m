//
//  StockInfoViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "StockInfoViewController.h"
#import "SortView.h"
@interface StockInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)UIView *rankContainer;
@end

@implementation StockInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [NSMutableArray new];
    [self.data addObjectsFromArray:@[@"N深信服",@"怡亚通",@"神州数码",@"翔港科技"]];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.rankContainer;
}

-(UITableView*)tableView{
    if(nil==_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(UIView*)rankContainer{
    if(!_rankContainer){
        _rankContainer = [UIView new];
        _rankContainer.frame = CGRectMake(0, 0, kScreenWidth, 40);
        _rankContainer.backgroundColor = kColor(245, 245, 245);
        
        WeakSelf(weakSelf)
        SortView *sort1 = [[SortView alloc] initWithFrame:CGRectMake(15, 0, 0, 15) title:@"股票"];
        sort1.block = ^(BOOL isUp){
          //TODO 数据排序，reload
            [weakSelf.tableView reloadData];
        };
        sort1.centerY = _rankContainer.centerY;
        [_rankContainer addSubview:sort1];
        
        SortView *sort2 = [[SortView alloc] initWithFrame:CGRectMake(15, 0, 0, 15) title:@"最新价"];
        sort2.block = ^(BOOL isUp){
            //TODO 数据排序，reload
            [weakSelf.tableView reloadData];
        };
        sort2.centerY = _rankContainer.centerY;
        sort2.right = kScreenWidth-112;
        [_rankContainer addSubview:sort2];
        
        SortView *sort3 = [[SortView alloc] initWithFrame:CGRectMake(15, 0, 0, 15) title:@"24H涨跌"];
        sort3.block = ^(BOOL isUp){
            //TODO 数据排序，reload
            [weakSelf.tableView reloadData];
        };
        sort3.right = kScreenWidth-15;
        sort3.centerY = _rankContainer.centerY;
        [_rankContainer addSubview:sort3];
    }
    return _rankContainer;
}
#pragma mark - TableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
