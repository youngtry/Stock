//
//  AllEntryOrdersVC.m
//  StockAnalysis
//
//  Created by ymx on 2018/8/15.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AllEntryOrdersVC.h"
#import "AITabScrollview.h"
#import "AITabContentView.h"
#import "Masonry.h"
#import "EntryOrdersVC.h"
#import "PendingOrderHistoryViewController.h"

@interface AllEntryOrdersVC ()
@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;
@end

@implementation AllEntryOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏
    self.title = Localize(@"All_Pendings");
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"History_Record") style:UIBarButtonItemStylePlain target:self action:@selector(clickRight:)];
    self.navigationItem.rightBarButtonItem = right;
    //标题滑动
    [self scrollTitle];
    
    //每页vc
    [self scrollContent];
    NSArray *titles = @[Localize(@"All"),Localize(@"Buy"),Localize(@"Sell")];
    NSMutableArray* vcs = [NSMutableArray new];
    {
        EntryOrdersVC *vc1 = [[EntryOrdersVC alloc] init];
        [vc1 setTitle:titles[0]];
        vc1.state = Trade_All;
        [vcs addObject:vc1];
        
        EntryOrdersVC *vc2 = [[EntryOrdersVC alloc] init];
        [vc2 setTitle:titles[1]];
        vc2.state = Trade_BuyIn;
        [vcs addObject:vc2];
        
        EntryOrdersVC*vc3 = [[EntryOrdersVC alloc] init];
        [vc3 setTitle:titles[2]];
        vc3.state = Trade_SoldOut;
        [vcs addObject:vc3];
    }
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
-(void)clickRight:(id)sender{
    PendingOrderHistoryViewController *vc = [PendingOrderHistoryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
