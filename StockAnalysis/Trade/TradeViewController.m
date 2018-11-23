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
#import "AllEntryOrdersVC.h"
#import "LoginViewController.h"
@interface TradeViewController ()<UIGestureRecognizerDelegate>
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
    
//        SCAlertController *alert = [SCAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:  UIAlertControllerStyleAlert];
//        alert.messageColor = kColor(136, 136, 136);
//
//        //退出
//        SCAlertAction *exitAction = [SCAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //登录
////            LoginViewController* vc = [[LoginViewController alloc ] initWithNibName:@"LoginViewController" bundle:nil];
////            [self.navigationController pushViewController:vc animated:YES];
//        }];
//        //单独修改一个按钮的颜色
//        exitAction.textColor = kColor(243, 186, 46);
//        [alert addAction:exitAction];
//
//        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
//        return;
//    }
    
    //标题滑动
    [self scrollTitle];
    [_scrollTitle.disableIndex addObject:[NSNumber numberWithInteger:3]];
    
    //每页vc
    [self scrollContent];
    
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
        [_scrollTitle.disableIndex addObject:[NSNumber numberWithInteger:2]];
//        [_scrollContent.disableIndex addObject:[NSNumber numberWithInteger:2]];
    }
    
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[@"买入",@"卖出",@"挂单",@"历史"];
    
    {
        TradePurchaseViewController *vc1 = [[TradePurchaseViewController alloc] initWithNibName:@"TradePurchaseViewController" bundle:nil];
        [vc1 setTitle:@"买入"];
        [vcs addObject:vc1];
        
        TradePurchaseViewController *vc2 = [[TradePurchaseViewController alloc] initWithNibName:@"TradePurchaseViewController" bundle:nil];
        [vc2 setTitle:@"卖出"];
        [vcs addObject:vc2];
        
        
        
        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
        BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
        if(!islogin){
            
        }else{
            PendingOrderViewController*vc3 = [PendingOrderViewController new];
            [vc3 setTitle:@"挂单"];
            [vcs addObject:vc3];
        }
        
        
        //vc4 历史不能滑动 需求！
    }
    
    WeakSelf(weakSelf)
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        
        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
        BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
        
        if(index==3){
            if(!islogin){
               [HUDUtil showSystemTipView:self title:@"提示" withContent:@"未登录,请先登录"];
                return ;
            }
            //历史记录
            PendingOrderHistoryViewController *vc = [PendingOrderHistoryViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            return ;
        }
        
        
        if(!islogin){
            if(index == 2){
                [HUDUtil showSystemTipView:self title:@"提示" withContent:@"未登录,请先登录"];
                return;
            }else{
                [_scrollContent updateTab:index];
            }
            
        }else{
            [_scrollContent updateTab:index];
        }
        
        
        
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        NSLog(@"index = %ld",(long)index);
        if(index == 3){
            return ;
        }
        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
        BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
        if(!islogin){
            if(index == 2){
                [HUDUtil showSystemTipView:self title:@"提示" withContent:@"未登录,请先登录"];
                return;
            }else{
               [_scrollTitle updateTagLine:index];
            }
            
        }else{
            [_scrollTitle updateTagLine:index];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.tabBarController setSelectedIndex:2];
    NSDictionary* info = [[AppData getInstance] getTradeInfo];
    if(info.count>0){
        NSInteger index = [[info objectForKey:@"index"] integerValue];
        NSString* name = [info objectForKey:@"name"];
        [self changeToPage:index withName:name];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)changeToPage:(NSInteger)index withName:(NSString*)tradename{
    [_scrollTitle autoClick:index];
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
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"未登录,请先登录"];
        return;
    }
    AllEntryOrdersVC *vc = [AllEntryOrdersVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
