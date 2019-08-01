//
//  FeedbackVC.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "FeedbackVC.h"
#import "AITabScrollview.h"
#import "AITabContentView.h"
#import "Masonry.h"
#import "FeedbackTypeListVC.h"
#import "FeedbackMyListVC.h"
@interface FeedbackVC ()
@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;
@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"Feed_Back");
    // Do any additional setup after loading the view.
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[Localize(@"Feed_Back"),Localize(@"Feed_List")];
    
    {
        FeedbackTypeListVC *vc1 = [FeedbackTypeListVC new];
        [vcs addObject:vc1];
        
        FeedbackMyListVC *vc2 = [FeedbackMyListVC new];
        [vcs addObject:vc2];
    }
    
    //标题滑动
    [self scrollTitle];
    
    //每页vc
    [self scrollContent];
    
    WeakSelf(weakSelf)
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollContent updateTab:index];
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(AITabScrollview*)scrollTitle{
    if(!_scrollTitle){
        _scrollTitle=[[AITabScrollview alloc]initWithFrame:CGRectZero];
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
