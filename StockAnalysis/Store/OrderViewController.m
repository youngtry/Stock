//
//  OrderViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "OrderViewController.h"
#import "AITabScrollview.h"
#import "AITabContentView.h"
#import "Masonry.h"
#import "OrderDetailViewController.h"

@interface OrderViewController ()
@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //标题滑动
    [self scrollTitle];
    
    //每页vc
    [self scrollContent];
    
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[@"未完成",@"已完成",@"已取消"];
    {
        OrderDetailViewController *vc1 = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        vc1.title = @"未完成";
        [vcs addObject:vc1];
        
        OrderDetailViewController *vc2 = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        vc2.title = @"已完成";
        [vcs addObject:vc2];
        
        OrderDetailViewController *vc3 = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        vc3.title = @"已取消";
        [vcs addObject:vc3];
        //
        //        StorePurchaseViewController*vc3 = [StorePurchaseViewController new];
        //        vc3.title = @"交易单";
        //        [vcs addObject:vc3];
        //
        //        StorePurchaseViewController*vc4 = [StorePurchaseViewController new];
        //        vc4.title = @"订单";
        //        [vcs addObject:vc4];
        
    }
    
    //    WeakSelf(weakSelf)
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollContent updateTab:index];
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(AITabScrollview*)scrollTitle{
    if(!_scrollTitle){
        _scrollTitle=[[AITabScrollview alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
        [self.view addSubview:_scrollTitle];
        [_scrollTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@42);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
        }];
    }
    return _scrollTitle;
}

-(AITabContentView*)scrollContent{
    if(!_scrollContent){
        _scrollContent=[[AITabContentView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_scrollContent];
        [_scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(_scrollTitle.mas_bottom);
            make.bottom.equalTo(self.view);
        }];
    }
    return _scrollContent;
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
