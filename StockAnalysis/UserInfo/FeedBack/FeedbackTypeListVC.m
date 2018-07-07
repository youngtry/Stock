//
//  FeedbackListVC.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "FeedbackTypeListVC.h"
#import "FeedbackEditVC.h"
@interface FeedbackTypeListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray* data;
@property(nonatomic,strong)NSMutableArray* switchs;
@end

@implementation FeedbackTypeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
//    _data = [NSMutableArray new];
//
//    NSArray *a = @[@"充值未到账问题"];
//    [_data addObject:a]
    
    _data = @[@[@"充值未到账问题",@"问题1",@"问题2",@"问题3"],
              @[@"提现等待人工审核",@"未收到提现确认邮件",@"未收到提现确认短信",@"申请撤销提现",@"其他提现问题"],
              @[@"账户与安全问题"],
              @[@"身份认证问题"],
              @[@"API问题"],
              @[@"交易问题"],
              @[@"活动问题"],
              ];
    _switchs = [NSMutableArray new];
    for (int i=0; i<_data.count; i++) {
        [_switchs addObject:@(0)];
    }
}

-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNaviHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *d = _data[section];
    BOOL expand = [_switchs[section] intValue];
    if(expand){
        return d.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        
        UILabel * ti = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 20)];
        ti.centerY = 22.5;
        ti.tag = 101;
        [cell.contentView addSubview:ti];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"round_arrow"]];
        [cell.contentView addSubview:arrow];
        arrow.right = kScreenWidth-16;
        arrow.centerY = 22.5;
        arrow.tag = 102;
        arrow.transform = CGAffineTransformMakeRotation(M_PI);
    }
    UILabel *titleLab = [cell.contentView viewWithTag:101];
    UIImageView *arrow  = [cell.contentView viewWithTag:102];
    
    NSString* title = _data[indexPath.section][indexPath.row];
    titleLab.text = title;
    if(indexPath.row!=0){
        titleLab.left = 50;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        arrow.hidden = YES;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        titleLab.left = 16;
        arrow.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *arrow = [cell.contentView viewWithTag:102];
        
        //点击展开收缩栏
        if([_switchs[indexPath.section] intValue]){
            _switchs[indexPath.section] = @(0);
            arrow.transform = CGAffineTransformMakeRotation((M_PI));
        }else{
            _switchs[indexPath.section] = @(1);
            arrow.transform = CGAffineTransformMakeRotation((0));
        }
        [self.tableView reloadData];
        return ;
    }
    
    FeedbackEditVC *vc = [[FeedbackEditVC alloc] initWithNibName:@"FeedbackEditVC" bundle:nil];
    vc.title1 = _data[indexPath.section][0];
    vc.title2 = _data[indexPath.section][indexPath.row];
    UITabBarController*bar = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController*nav = bar.viewControllers[0];
    [nav pushViewController:vc animated:YES];
}
@end
