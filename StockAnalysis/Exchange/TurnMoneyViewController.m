//
//  TurnMoneyViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/14.
//  Copyright © 2018年 try. All rights reserved.
//

#import "TurnMoneyViewController.h"
#import "AITabScrollview.h"
#import "AITabContentView.h"
#import "Masonry.h"
#import "MoneyInOutViewController.h"

@interface TurnMoneyViewController ()
@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;
@end

@implementation TurnMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"资金划转";
    //标题滑动
    _scrollTitle=[[AITabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_scrollTitle];
    [_scrollTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(@0);
    }];
    
    //每页vc
    _scrollContent=[[AITabContentView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_scrollContent];
    
    [_scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_scrollTitle.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[@"转入",@"转出"];
    
    for (int i=0; i<titles.count; i++) {
        MoneyInOutViewController *vc = [[MoneyInOutViewController alloc] init];
        [vc setTitle:[NSString stringWithFormat:@"%d",i]];
        [vcs addObject:vc];
        
    }
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollContent updateTab:index];
    }];
    
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}

-(void)showTurnIn{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
