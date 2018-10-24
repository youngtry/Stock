//
//  FeedbackMyListVC.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "FeedbackMyListVC.h"
#import "FeedbackMyListTableViewCell.h"

@interface FeedbackMyListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray*data;

@property(nonatomic,assign)NSInteger updatePage;
@property(nonatomic,assign)BOOL isUpdate;
@end

@implementation FeedbackMyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [NSMutableArray new];
    [_data removeAllObjects];
    [self.view addSubview:self.tableView];
    
    self.updatePage = 0;
    self.isUpdate = YES;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_data removeAllObjects];
    self.updatePage = 0;
    self.isUpdate = YES;
    [self showFeedbacksWithPage:1];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)showFeedbacksWithPage:(NSInteger)page{
    self.updatePage++;
    NSString* url = @"feedbacks";
    NSDictionary* params =@{@"page":@(page),
                            @"page_limit":@(10)
                            };
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            NSLog(@"请求成功");
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* list = [[data objectForKey:@"data"] objectForKey:@"feedbacks"];
                if(list.count == 0){
                    self.isUpdate = NO;
                    [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"全部加载完毕"];
                }else{
                    [_data addObjectsFromArray:list];
                    [self.tableView reloadData];
                }
                
            }else{
                
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
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
//    NSLog(@"_data.count %ld",_data.count);
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedbackMyListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(nil==cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedbackMyListTableViewCell" owner:self options:nil] objectAtIndex:0];
//        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, 260, 15)];
//        lab1.font = kTextFont(18);
//        lab1.textColor = kColor(0, 0, 0);
//        lab1.tag = 101;
//        [cell.contentView addSubview:lab1];
//
//        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 43, 250, 13)];
//        lab2.font = kTextFont(15);
//        lab2.textColor = kColor(125,125,125);
//        lab2.tag = 102;
//        [cell.contentView addSubview:lab2];
//
//        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 68, 250, 12)];
//        lab3.font = kTextFont(12);
//        lab3.textColor = kColor(125,125,125);
//        lab3.tag = 103;
//        [cell.contentView addSubview:lab3];
//
//        UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(0,18, 50, 15)];
//        lab4.right = kScreenWidth-16;
//        lab4.textAlignment = NSTextAlignmentRight;
//        lab4.font = kTextFont(13);
//        lab4.textColor = kColor(125,125,125);
//        lab4.tag = 104;
//        [cell.contentView addSubview:lab4];
        
        
    }
    
//    UILabel *lab1 = [cell.contentView viewWithTag:101];
//    UILabel *lab2 = [cell.contentView viewWithTag:102];
//    UILabel *lab3 = [cell.contentView viewWithTag:103];
//    UILabel *lab4 = [cell.contentView viewWithTag:104];
//
//    NSDictionary *dic = _data[indexPath.row];
//    lab1.text = dic[@"a"];
//    lab2.text = dic[@"b"];
//    lab3.text = dic[@"c"];
//    lab4.text = dic[@"d"];
    if(_data.count>indexPath.row){
        NSDictionary* info = _data[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"title_id"]] ;
        cell.contentLabel.text = [info objectForKey:@"content"];
        cell.timeLabel.text = [info objectForKey:@"updated_at"];
        cell.stateLabel.text = [info objectForKey:@"state"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    NSLog(@"加载cell %ld",indexPath.row);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if(!self.isUpdate){
        
        return;
    }
    if(self.isUpdate && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
        [self showFeedbacksWithPage:self.updatePage+1];
    }
}
@end
