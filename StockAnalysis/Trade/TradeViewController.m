//
//  TradeViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/6/24.
//  Copyright © 2018年 try. All rights reserved.
//

#import "TradeViewController.h"
#import "AITabScrollview.h"
#import "AITabContentView.h"
#import "Masonry.h"
#import "TradePurchaseViewController.h"
#import "PendingOrderViewController.h"
#import "PendingOrderHistoryViewController.h"
@interface TradeViewController ()
@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;
@end

@implementation TradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //导航栏
    self.title = @"交易";
    
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSearch:)];
    self.navigationItem.leftBarButtonItem = search;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"全部挂单" style:UIBarButtonItemStylePlain target:self action:@selector(clickAllTrade:)];
    self.navigationItem.rightBarButtonItem = right;
    //标题滑动
    [self scrollTitle];
    
    //每页vc
    [self scrollContent];
    
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[@"买入",@"卖出",@"挂单",@"历史"];
    
    {
        TradePurchaseViewController *vc1 = [[TradePurchaseViewController alloc] initWithNibName:@"TradePurchaseViewController" bundle:nil];
        [vcs addObject:vc1];
        
        TradePurchaseViewController *vc2 = [[TradePurchaseViewController alloc] initWithNibName:@"TradePurchaseViewController" bundle:nil];
        [vcs addObject:vc2];
        
        PendingOrderViewController*vc3 = [PendingOrderViewController new];
        [vcs addObject:vc3];
        
        //vc4 历史不能滑动 需求！
    }
    
    WeakSelf(weakSelf)
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        if(index==3){
            //历史记录
            PendingOrderHistoryViewController *vc = [PendingOrderHistoryViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            return ;
        }
        [_scrollContent updateTab:index];
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
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

-(void)clickSearch:(id)sender{
    DLog(@"clickSearch");
}

-(void)clickAllTrade:(id)sender{
    DLog(@"clickAllTrade");
}

@end