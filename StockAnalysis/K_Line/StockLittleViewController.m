//
//  StockLittleViewController.m
//  StockAnalysis
//
//  Created by try on 2018/7/31.
//  Copyright © 2018年 try. All rights reserved.
//

#import "StockLittleViewController.h"
#import "Masonry.h"
#import "Y_StockChartView.h"
#import "NetWorking.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"
#import "SocketInterface.h"
#import "JSONKit.h"
#import "UpdateDataTableViewCell.h"
#import "Y_StockChartViewController.h"
#import "PriceTipViewController.h"
#import "SearchData.h"
#import "TradePurchaseViewController.h"
#import "TradeViewController.h"
#import "TabViewController.h"
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH MAX(kScreenWidth,kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
@interface StockLittleViewController ()<Y_StockChartViewDataSource,SocketDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *kLineView;
@property (weak, nonatomic) IBOutlet UILabel *periodPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *upOrDownRateLabel;

@property (weak, nonatomic) IBOutlet UITableView *updateDataView;


@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIView *MAView;
@property (weak, nonatomic) IBOutlet UIView *timeSelectView;
@property (weak, nonatomic) IBOutlet UIButton *timeSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *MAbtn;
@property (weak, nonatomic) IBOutlet UIButton *MACDBtn;
@property (weak, nonatomic) IBOutlet UIView *MACDView;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;


@property (nonatomic, strong) Y_StockChartView *stockChartView;

@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;

@property (nonatomic,strong)NSMutableArray* klineArray;

@property (nonatomic,strong)NSMutableArray* updateData;

@property (nonatomic) BOOL isFollow;
@property (nonatomic) BOOL isTip;
@property (nonatomic, copy) NSString *originTime;
@property (nonatomic, assign) NSInteger preciseTime;

@property (nonatomic) BOOL isFirst;

@property(nonatomic,strong)NSTimer* update1;

@property(nonatomic,strong)NSString* klineUpdateTimeStr;
@property(nonatomic,strong)NSMutableArray* klineUpdateData;

@end

@implementation StockLittleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"StockLittleViewController";
    // Do any additional setup after loading the view from its nib.
    
    
    
//    [[SocketInterface sharedManager] closeWebSocket];
    self.isFollow = NO;
    self.isTip = NO;
    
    _preciseTime = 0;
    _isFirst = YES;
    self.update1 = nil;
    
    self.type = [NSString stringWithFormat:@"15%@",Localize(@"Min")];
    
    self.klineArray = [NSMutableArray new];
    self.currentIndex = -1;
    //    self.stockChartView.backgroundColor = [UIColor backgroundColor];
    self.updateDataView.delegate = self;
    self.updateDataView.dataSource = self;
    self.updateDataView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.updateDataView.allowsSelection = NO;
    self.updateData = [NSMutableArray new];
    self.isFirst = YES;
    self.klineUpdateTimeStr = @"0";
    self.klineUpdateData = [NSMutableArray new];
    self.timeSelectBtn.tag = 4;
    
    self.updateDataView.estimatedRowHeight = 0;
    self.updateDataView.estimatedSectionFooterHeight = 0;
    self.updateDataView.estimatedSectionHeaderHeight = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [SocketInterface sharedManager].delegate = self;
    [[SocketInterface sharedManager] openWebSocket];

    [[SearchData getInstance].specialList removeAllObjects];
    

//    if(_update1){
//        [_update1 invalidate];
//        _update1 = nil;
//    }
    
//    _update1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
//    //    [_update1 fire];
//
//    [[NSRunLoop mainRunLoop] addTimer:_update1 forMode:NSDefaultRunLoopMode];
    
    
    NSDictionary* params = @{@"market":self.title};
    NSString* url  = @"market/info";
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [[AppData getInstance] setOriginTime:[[data objectForKey:@"data"] objectForKey:@"created_at"]];
            }else{
                [[AppData getInstance] setOriginTime:@""];
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:Localize(@"Data_Error")];
            }
            
        }
        _originTime = [[AppData getInstance] getOriginTime];
        if(nil == _stockChartView){
            weakSelf.stockChartView.backgroundColor = [UIColor backgroundColor];
        }else{
            [weakSelf sendFirstData:weakSelf.timeSelectBtn.tag];
        }
    }];
    
    
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
//        [HUDUtil showSystemTipView:self.navigationController title:Localize(@"Menu_Title") withContent:Localize(@"Login_Tip")];
        [self closeAllBtnView];
        return;
    }
    
    NSDictionary* parameters = @{@"page":@"1",
                                 @"page_limit":@"10",
                                 @"order_by":@"price"
                                 };
    NSString* url1 = @"market/follow/list";
    
    [[HttpRequest getInstance] postWithURL:url1 parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSDictionary* itemData = [data objectForKey:@"data"];
                if(itemData.count>0){
                    NSArray* item = [itemData objectForKey:@"items"];
                    if(item.count>0){
                        for (int i=0; i<item.count; i++) {
                            NSDictionary* info = item[i];
                            [[SearchData getInstance] addSpecail:info];
                        }
                        
                        for (NSDictionary* info in [SearchData getInstance].specialList) {
                            if([[info objectForKey:@"market"] isEqualToString:weakSelf.title]){
                                weakSelf.isFollow = YES;
                                break;
                            }
                        }
                        
                    }
                }
            }else{
                
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
        
        [self requestTips];
    }];
    
    [self closeAllBtnView];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
//    [self.update1 invalidate];
//    self.update1 = nil;
    
    NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};

    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];

    NSDictionary *dicAll1 = @{@"method":@"kline.unsubscribe",@"params":@[],@"id":@(PN_KlineUnsubscribe)};

    NSString *strAll1 = [dicAll1 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll1 withName:@"kline.unsubscribe"];

    NSDictionary *dicAll2 = @{@"method":@"deals.unsubscribe",@"params":@[],@"id":@(PN_DealsUnsubscribe)};

    NSString *strAll2 = [dicAll2 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll2 withName:@"deals.unsubscribe"];
}


-(void)requestTips{
    
    NSString* followpic =  @"addstar.png";
    if(self.isFollow){
        followpic = @"star.png";
    }
    
    __block NSString* tipspic = @"addTips.png";
    
    NSString* url1 = @"market/notice";
    NSDictionary* params = @{@"page":@(1),
                             @"page_limit":@(10),
                             @"state":@""
                             };
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] getWithURL:url1 parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* items = [[data objectForKey:@"data"] objectForKey:@"items"];
                BOOL findItem = NO;
                for (NSDictionary* item in items) {
                    if([[item objectForKey:@"market"] isEqual:weakSelf.title]){
                        findItem = YES;
                        if([[item objectForKey:@"state"] isEqualToString:@"enable"]){
                            tipspic = @"tips.png";
                            weakSelf.isTip = YES;
                            
                        }else if([[item objectForKey:@"state"] isEqualToString:@"disable"]){
                            tipspic = @"addTips.png";
                            weakSelf.isTip = NO;
                        }
                    }
                }
                if(!findItem){
                    self.isTip = NO;
                }
            }
        }
        
        [self addRightBtns:tipspic withFollow:followpic];
    }];
}

-(void)addRightBtns:(NSString*)tippic withFollow:(NSString*)followpic{
    
    UIBarButtonItem* priceTipBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:tippic] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(priceTips)];
    UIBarButtonItem* followBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:followpic] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:UIBarButtonItemStyleDone target:self action:@selector(followBtn)];
    [self.navigationItem setRightBarButtonItems:@[priceTipBtn,followBtn] animated:YES];
}

-(void)priceTips{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
        [HUDUtil showSystemTipView:temp title:Localize(@"Menu_Title") withContent:Localize(@"Login_Tip")];
        return;
    }
    PriceTipViewController* vc = [[PriceTipViewController alloc] initWithNibName:@"PriceTipViewController" bundle:nil];
    [vc setTitle:[NSString stringWithFormat:@"%@_%d",self.title,self.isTip]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)followBtn{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
        [HUDUtil showSystemTipView:temp title:Localize(@"Menu_Title") withContent:Localize(@"Login_Tip")];
        return;
    }
    if(self.isFollow){
        NSDictionary* parameters = @{@"market":self.title};
        NSString* url = @"/market/unfollow";
//        [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
        WeakSelf(weakSelf);
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
                [HUDUtil hideHudView];
                if([[data objectForKey:@"ret"] intValue] == 1){
                    self.isFollow = NO;
                    [self.navigationItem.rightBarButtonItems[1] setImage:[[UIImage imageNamed:@"addstar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                    for (NSDictionary* info in [SearchData getInstance].specialList) {
                        if([[info objectForKey:@"market"] isEqualToString:weakSelf.title]){
                            [[SearchData getInstance].specialList removeObject:info];
                            break;
                        }
                    }
                }else{
                    
                    [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
                    
                }
            }
        }];
    }else{
        NSDictionary* parameters = @{@"market":self.title};
        NSString* url = @"/market/follow";
//        [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
        WeakSelf(weakSelf);
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
                [HUDUtil hideHudView];
                if([[data objectForKey:@"ret"] intValue] == 1){
                    weakSelf.isFollow = YES;
                    [weakSelf.navigationItem.rightBarButtonItems[1] setImage:[[UIImage imageNamed:@"star.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                    for (NSDictionary* info in [SearchData getInstance].searchList) {
                        if([[info objectForKey:@"market"] isEqualToString:weakSelf.title]){
                            [[SearchData getInstance].specialList addObject:info];
                            break;
                        }
                    }
                    
                }else{
                    
                    [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
                    
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)closeAllBtnView{
    [self.timeSelectView setHidden:YES];
    [self.settingView setHidden:YES];
    [self.MAView setHidden:YES];
    [self.MACDView setHidden:YES];
    
    [self.timeSelectBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.MAbtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.settingBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.MACDBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    
}
- (IBAction)openTImeSelectView:(id)sender {
    UIButton* btn = sender;

    if(!self.timeSelectView.hidden){
        [self closeAllBtnView];
    }else{
        [self closeAllBtnView];
        [self.timeSelectView setHidden:NO];
        [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
}
- (IBAction)openMAView:(id)sender {
    UIButton* btn = sender;
    
    if(!self.MAView.hidden){
        [self closeAllBtnView];
    }else{
        [self closeAllBtnView];
        [self.MAView setHidden:NO];
        
        
        [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }
}
- (IBAction)openMACDView:(id)sender {
 
    UIButton* btn = sender;

    
    if(!self.MACDView.hidden){
        [self closeAllBtnView];
    }else{
        [self closeAllBtnView];
        [self.MACDView setHidden:NO];
        [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}
- (IBAction)openSettingView:(id)sender {
    UIButton* btn = sender;

    if(!self.settingView.hidden){
        [self closeAllBtnView];
    }else{
        [self closeAllBtnView];
        [self.settingView setHidden:NO];
        [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}
- (IBAction)switchPhone:(id)sender {
    [self closeAllBtnView];
    
//    NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateSubscribe)};
//
//    NSString *strAll = [dicAll JSONString];
//    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
//
//    NSDictionary *dicAll1 = @{@"method":@"kline.unsubscribe",@"params":@[],@"id":@(PN_KlineUnsubscribe)};
//
//    NSString *strAll1 = [dicAll1 JSONString];
//    [[SocketInterface sharedManager] sendRequest:strAll1 withName:@"kline.unsubscribe"];
//
//    NSDictionary *dicAll2 = @{@"method":@"deals.unsubscribe",@"params":@[],@"id":@(PN_DealsUnsubscribe)};
//
//    NSString *strAll2 = [dicAll2 JSONString];
//    [[SocketInterface sharedManager] sendRequest:strAll2 withName:@"deals.unsubscribe"];
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.isEable = YES;
    Y_StockChartViewController *stockChartVC = [Y_StockChartViewController new];
    stockChartVC.title = self.title;
//    stockChartVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:stockChartVC animated:YES completion:nil];
//    [self.navigationController pushViewController:stockChartVC animated:YES];
}


- (IBAction)clickTimeSelectBtn:(id)sender {
    UIButton* btn = sender;
    NSString* btntext = btn.titleLabel.text;
    NSLog(@"btntext = %@",btntext);
//    if([btntext isEqualToString:self.timeSelectBtn.titleLabel.text]){
//        [self.timeSelectView setHidden:YES];
//        return;
//    }
    [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.timeSelectBtn setTitle:btntext forState:UIControlStateNormal];
    [self.timeSelectView setHidden:YES];
    self.timeSelectBtn.tag = btn.tag;
    for (UIView* child in [self.timeSelectView subviews]) {
        if([child isKindOfClass:[UIButton class]]){
            UIButton* nextbtn = (UIButton*)child;
//            NSLog(@"nextbtn = %@",nextbtn.titleLabel.text);
            if(![nextbtn.titleLabel.text isEqualToString:btntext]){
                [nextbtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            }
        }
    }
    [self sendFirstData:btn.tag];
//    if(btn.tag>0){
//
//    }else if (btn.tag == 0){
//        //分时图
//        [self sendFirstData:1];
//        [self.stockChartView showTimeline];
//    }
    
}

- (IBAction)clickSettingBtn:(id)sender {
    
    UIButton* btn = sender;
    NSString* btntext = btn.titleLabel.text;
    NSLog(@"btntext = %@",btntext);
    if(![btn.titleLabel.text isEqualToString:Localize(@"Default")] && ![btn.titleLabel.text isEqualToString:@"+"] && ![btn.titleLabel.text isEqualToString:@"-"] && ![btn.titleLabel.text isEqualToString:Localize(@"Save")]){
        [btn setBackgroundImage:[UIImage imageNamed:@"btnselectbg.png"] forState:UIControlStateNormal];
    }
    
    
    for (UIView* child in [self.settingView subviews]) {
        if([child isKindOfClass:[UIButton class]]){
            UIButton* nextbtn = (UIButton*)child;
            //            NSLog(@"nextbtn = %@",nextbtn.titleLabel.text);
            if(![nextbtn.titleLabel.text isEqualToString:btntext] && ![nextbtn.titleLabel.text isEqualToString:Localize(@"Default")] && ![nextbtn.titleLabel.text isEqualToString:@"+"] && ![nextbtn.titleLabel.text isEqualToString:@"-"] && ![nextbtn.titleLabel.text isEqualToString:Localize(@"Save")]){
                [nextbtn setBackgroundImage:[UIImage imageNamed:@"btnbg.png"] forState:UIControlStateNormal];
            }
        }
    }
}
- (IBAction)clickMABtn:(id)sender {
    UIButton* btn = sender;
    NSString* btntext = btn.titleLabel.text;
    NSLog(@"btntext = %@",btntext);
    if(![btntext isEqualToString:Localize(@"Close")]){
       [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.MAbtn setTitle:@"MA" forState:UIControlStateNormal];
    }else{
        [self.MAbtn setTitle:btntext forState:UIControlStateNormal];
    }
    
    [self.MAView setHidden:YES];
    
    for (UIView* child in [self.MAView subviews]) {
        if([child isKindOfClass:[UIButton class]]){
            UIButton* nextbtn = (UIButton*)child;
            //            NSLog(@"nextbtn = %@",nextbtn.titleLabel.text);
            if(![nextbtn.titleLabel.text isEqualToString:btntext]){
                [nextbtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            }
        }
    }
}
- (IBAction)clickMACDBtn:(id)sender {
    UIButton* btn = sender;
    NSString* btntext = btn.titleLabel.text;
    NSLog(@"btntext = %@",btntext);
    if([btntext isEqualToString:Localize(@"Close")]){
        [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [self.MACDBtn setTitle:@"MACD" forState:UIControlStateNormal];
    }else{
        
        if([btntext isEqualToString:@"MACD"]){
            if([self.MACDBtn.titleLabel.text isEqualToString:Localize(@"Purpose")]){
                [self.MACDBtn setTitle:@"MACD" forState:UIControlStateNormal];
                [_stockChartView setMACDViewHide:NO];
            }else{
                [self.MACDBtn setTitle:Localize(@"Purpose") forState:UIControlStateNormal];
                [_stockChartView setMACDViewHide:YES];
            }
        }else{
            return;
        }
        
//        [self.MACDBtn setTitle:btntext forState:UIControlStateNormal];
    }
    
    [self.MACDView setHidden:YES];
    
    for (UIView* child in [self.MACDView subviews]) {
        if([child isKindOfClass:[UIButton class]]){
            UIButton* nextbtn = (UIButton*)child;
            //            NSLog(@"nextbtn = %@",nextbtn.titleLabel.text);
            if(![nextbtn.titleLabel.text isEqualToString:btntext]){
                [nextbtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            }
        }
    }
}


- (IBAction)clickBuy:(id)sender {
    BOOL isfind = NO;
    [[AppData getInstance] setTradeInfo:@{@"index":@(0),@"name":self.title,@"title":Localize(@"Buy")}];
    for (UIViewController*vc in self.navigationController.childViewControllers) {
        if([vc isKindOfClass:[TradeViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
            isfind = YES;
            
            break;
        }
    }
    
    if(!isfind){
        
        [self.navigationController popViewControllerAnimated:NO];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;

        [tabViewController setSelectedIndex:2];
        
        for (UIViewController*vc in self.navigationController.childViewControllers) {
            if([vc isKindOfClass:[TradeViewController class]]){
                TradeViewController* trade = (TradeViewController*)vc;
                
                [trade changeToPage:0 withName:self.title];
                break;
            }
        }
    }
    
//    TradePurchaseViewController* vc = [[TradePurchaseViewController alloc] initWithNibName:@"TradePurchaseViewController" bundle:nil];
//    vc.title = Localize(@"Buy");
//    [self.navigationController pushViewController:vc animated:YES];
////
//    vc.block = ^{
//        [vc setTradeName:self.title];
//    };
    
}
- (IBAction)clickSell:(id)sender {
    [[AppData getInstance] setTradeInfo:@{@"index":@(1),@"name":self.title,@"title":Localize(@"Sell")}];
    BOOL isfind = NO;
    for (UIViewController*vc in self.navigationController.childViewControllers) {
        if([vc isKindOfClass:[TradeViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
            isfind = YES;
            
            break;
        }
    }
    
    if(!isfind){
        [self.navigationController popViewControllerAnimated:NO];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
        
        [tabViewController setSelectedIndex:2];
        
        
    }
    
//    TradePurchaseViewController* vc = [[TradePurchaseViewController alloc] initWithNibName:@"TradePurchaseViewController" bundle:nil];
//    vc.title = Localize(@"Sell");
//    [self.navigationController pushViewController:vc animated:YES];
////
//    vc.block = ^{
//      [vc setTradeName:self.title];
//    };
}

-(void)requestSubscribe{
    NSArray *dicParma = @[self.title
                          ];
    NSArray *dicParma1 = @[self.title,
                          @(_preciseTime)
                          ];
    
    NSDictionary *dicAll = @{@"method":@"state.subscribe",@"params":dicParma,@"id":@(PN_StateSubscribe)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.subscribe"];
    
    NSDictionary *dicAll1 = @{@"method":@"kline.subscribe",@"params":dicParma1,@"id":@(PN_KlineSubscribe)};
    
    NSString *strAll1 = [dicAll1 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll1 withName:@"kline.subscribe"];
    
    NSDictionary *dicAll2 = @{@"method":@"deals.subscribe",@"params":dicParma,@"id":@(PN_DealsSubscribe)};
    
    NSString *strAll2 = [dicAll2 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll2 withName:@"deals.subscribe"];
}


- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

-(id) stockDatasWithIndex:(NSInteger)index
{
//    NSString* type;
//    switch (index) {
//        case 0:
//        {
//            type = @"1min";
//        }
//            break;
//        case 1:
//        {
//            type = @"1min";
//        }
//            break;
//        case 2:
//        {
//            type = @"1min";
//        }
//            break;
//        case 3:
//        {
//            type = @"5min";
//        }
//            break;
//        case 4:
//        {
//            type = @"30min";
//        }
//            break;
//        case 5:
//        {
//            type = @"1hour";
//        }
//            break;
//        case 6:
//        {
//            type = @"1day";
//        }
//            break;
//        case 7:
//        {
//            type = @"1week";
//        }
//            break;
//
//        default:
//            break;
//    }
//
//    self.currentIndex = index;
//    self.type = type;
//    if(![self.modelsDict objectForKey:type])
//    {
//        [self reloadData];
//    } else {
//        return [self.modelsDict objectForKey:type].models;
//    }
//    return nil;
    

    
    NSInteger precise = 0;
    NSString *type;
    switch (index) {
        case 0:
        {
            type = Localize(@"Immediate");
            precise = 10;
        }
            break;
        case 1:
        {
            type = [NSString stringWithFormat:@"1%@",Localize(@"Min")];
            precise = 60;
        }
            break;
        case 2:
        {
            type = [NSString stringWithFormat:@"3%@",Localize(@"Min")];
            precise = 180;
        }
            break;
        case 3:
        {
            type = [NSString stringWithFormat:@"5%@",Localize(@"Min")];
            precise = 300;
        }
            break;
        case 4:
        {
            type = [NSString stringWithFormat:@"15%@",Localize(@"Min")];
            precise = 900;
        }
            break;
        case 5:
        {
            type = [NSString stringWithFormat:@"30%@",Localize(@"Min")];
            precise = 1800;
        }
            break;
        case 6:
        {
            type = [NSString stringWithFormat:@"1%@",Localize(@"Hour")];
            precise = 3600;
        }
            break;
        case 7:
        {
            type = [NSString stringWithFormat:@"2%@",Localize(@"Hour")];
            precise = 7200;
        }
            break;
        case 8:
        {
            type = [NSString stringWithFormat:@"4%@",Localize(@"Hour")];
            precise = 14400;
        }
            break;
        case 9:
        {
            type = [NSString stringWithFormat:@"6%@",Localize(@"Hour")];
            precise = 21600;
        }
            break;
        case 10:
        {
            type = [NSString stringWithFormat:@"12%@",Localize(@"Hour")];
            precise = 43200;
        }
            break;
        case 11:
        {
            type = @"1天";
            precise = 86400;
        }
            break;
        case 12:
        {
            type = @"1周";
            precise = 604800;
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    self.preciseTime = precise;
    if(![self.modelsDict objectForKey:type])
    {
        [self sendKlineRequest];
    } else {
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
    
}

-(void)sendFirstData:(NSInteger)index{
    NSInteger precise = 0;
    NSString *type;
    switch (index) {
        case 0:
        {
            type = Localize(@"Immediate");
            precise = 10;
        }
            break;
        case 1:
        {
            type = [NSString stringWithFormat:@"1%@",Localize(@"Min")];
            precise = 60;
        }
            break;
        case 2:
        {
            type = [NSString stringWithFormat:@"3%@",Localize(@"Min")];
            precise = 180;
        }
            break;
        case 3:
        {
            type = [NSString stringWithFormat:@"5%@",Localize(@"Min")];
            precise = 300;
        }
            break;
        case 4:
        {
            type = [NSString stringWithFormat:@"15%@",Localize(@"Min")];
            precise = 900;
        }
            break;
        case 5:
        {
            type = [NSString stringWithFormat:@"30%@",Localize(@"Min")];
            precise = 1800;
        }
            break;
        case 6:
        {
            type = [NSString stringWithFormat:@"1%@",Localize(@"Hour")];
            precise = 3600;
        }
            break;
        case 7:
        {
            type = [NSString stringWithFormat:@"2%@",Localize(@"Hour")];
            precise = 7200;
        }
            break;
        case 8:
        {
            type = [NSString stringWithFormat:@"4%@",Localize(@"Hour")];
            precise = 14400;
        }
            break;
        case 9:
        {
            type = [NSString stringWithFormat:@"6%@",Localize(@"Hour")];
            precise = 21600;
        }
            break;
        case 10:
        {
            type = [NSString stringWithFormat:@"12%@",Localize(@"Hour")];
            precise = 43200;
        }
            break;
        case 11:
        {
            type = @"1天";
            precise = 86400;
        }
            break;
        case 12:
        {
            type = @"1周";
            precise = 604800;
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    self.preciseTime = precise;
    [self sendKlineRequest];
}

-(NSInteger)getSelect:(NSInteger)precise{
    NSInteger index = 0;

    switch (precise) {
        case 10:
        {
            index = 1;
        }
            break;
        case 60:
        {
            index = 2;
        }
            break;
        case 180:
        {
            index = 3;
        }
            break;
        case 300:
        {
            index = 4;
        }
            break;
        case 900:
        {
            index = 5;
        }
            break;
        case 1800:
        {
            index = 6;
        }
            break;
        case 3600:
        {
            index = 7;
        }
            break;
        case 7200:
        {
            index = 8;
        }
            break;
        case 14400:
        {
            index = 9;
        }
            break;
        case 21600:
        {
            index = 10;
        }
            break;
        case 43200:
        {
            index = 11;
        }
            break;
        case 86400:
        {
            index = 12;
        }
            break;
        case 604800:
        {
            index = 13;
        }
            break;
            
        default:
            break;
    }
    
    return index;
}
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

-(void)sendPing{
    NSArray *dicParma = @[];
    
    //    NSLog(@"Websocket Connected");
    
    NSDictionary *dicAll = @{@"method":@"server.ping",@"params":dicParma,@"id":@(PN_ServerPing)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"server.ping"];
}

-(void)sendKlineRequest{
//    [self requestSubscribe];
//    return;
    
    NSDictionary *dicAll3 = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
    
    NSString *strAll3 = [dicAll3 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll3 withName:@"state.unsubscribe"];
    
    NSDictionary *dicAll1 = @{@"method":@"kline.unsubscribe",@"params":@[],@"id":@(PN_KlineUnsubscribe)};
    
    NSString *strAll1 = [dicAll1 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll1 withName:@"kline.unsubscribe"];
    
    NSDictionary *dicAll2 = @{@"method":@"deals.unsubscribe",@"params":@[],@"id":@(PN_DealsUnsubscribe)};
    
    NSString *strAll2 = [dicAll2 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll2 withName:@"deals.unsubscribe"];
    
    self.klineUpdateTimeStr = @"0";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    NSDate *lastdate = [NSDate dateWithTimeInterval:-60*60 sinceDate:datenow];
    
    
    NSDate* origindate = lastdate;
    if(_originTime.length > 0){
        origindate = [formatter dateFromString:_originTime];
    }
    //    _preciseTime = 6;
    
    NSDate* expecttime = [NSDate dateWithTimeIntervalSinceNow:-_preciseTime*76*3];
    
    lastdate =  [origindate laterDate:expecttime];
    
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSString *lastTimeString = [formatter stringFromDate:lastdate];
    
//    NSLog(@"currentTimeString =  %@,%@",currentTimeString,lastTimeString);
    
    
 
    NSString* starttime = [self getTimeStrWithString:lastTimeString];
//    NSLog(@"starttime = %@",starttime);
    NSString* endtime = [self getTimeStrWithString:currentTimeString];
    
    
    NSArray *dicParma = @[self.title,
                          @([starttime longLongValue]),
                          @([endtime longLongValue]),
                          @(self.preciseTime)];
    
//    NSLog(@"Websocket Connected");
    
    NSDictionary *dicAll = @{@"method":@"kline.query",@"params":dicParma,@"id":@(PN_KlineQuery)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"kline.query"];
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据请求中"];
}

-(void)getWebData:(id)message withName:(NSString *)name{
    if(nil == message){
        //断线了，需要重连
        [[SocketInterface sharedManager] openWebSocket];
        [SocketInterface sharedManager].delegate = self;
        
        [self requestSubscribe];
        [self sendKlineRequest];
        
        return;
    }
    NSString* str = message;
    NSData* strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
    
    NSNull* err =[data objectForKey:@"error"];
    
    int requestID = 0;
    id dataid = [data objectForKey:@"id"];
    
    if(dataid != [NSNull null]){
        requestID = [[data objectForKey:@"id"] intValue];
    }
    
    if(err){
//        NSLog(@"err = %@",err);
    }
//    NSLog(@"socket data = %@",data);
    if(requestID == PN_KlineQuery){
        [HUDUtil hideHudView];
        
        if([data objectForKey:@"result"] == [NSNull null]){
            return;
        }
        
        NSArray* result = [data objectForKey:@"result"];
        if(result.count==0){
            return;
        }
        
//        NSLog(@"result = %@",result);
//        NSMutableArray* need = [[NSMutableArray alloc] initWithCapacity:result.count];
        [self.klineArray removeAllObjects];
        for(int i=0;i<result.count-1;i++){
            NSString* date = result[i][0];
            long long time = [date longLongValue];
            time = time*1000;
            date = [NSString stringWithFormat:@"%lld",time];
            NSString* open = [NSString stringWithFormat:@"%.5f",[result[i][1] floatValue]] ;
            
            NSString* close = [NSString stringWithFormat:@"%.5f",[result[i][2] floatValue]];
            NSString* high = [NSString stringWithFormat:@"%.5f",[result[i][3] floatValue]];
            NSString* low = [NSString stringWithFormat:@"%.5f",[result[i][4] floatValue]];
            NSString* vol = result[i][5];
//            NSLog(@"open = %@",open);
            NSArray* info = [[NSArray alloc] initWithObjects:date,open,high,low,close,vol, nil];
            [self.klineArray  setObject:info atIndexedSubscript:i];
        }
        
//        NSLog(@"need = %@",need);
        if(result.count>0){
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:self.klineArray];
            self.groupModel = groupModel;
            [self.modelsDict setObject:groupModel forKey:self.type];
            //        NSLog(@"groupModel = %@",groupModel);
            [self.stockChartView setSelect:[self getSelect:self.preciseTime]-1];
            [self.stockChartView reloadData];

        }
        [self requestSubscribe];
        
    }else if ([name isEqualToString:@"state.update"]){
        NSArray* params = [data objectForKey:@"params"];
        if(params.count == 2){
            NSDictionary* info = params[1];
//            NSLog(@"info = %@",info);
            float close = [[info objectForKey:@"close"] floatValue];
            float open = [[info objectForKey:@"open"] floatValue];
            self.periodPrice.text = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"last"] floatValue]];
            float deal = close-open;
            if(deal>=0){
                self.dealLabel.text =[NSString stringWithFormat:@"+%.4f",deal];
            }else{
                self.dealLabel.text =[NSString stringWithFormat:@"%.4f",deal];
            }
            
            self.highLabel.text =[NSString stringWithFormat:@"%.4f",[[info objectForKey:@"high"] floatValue]];
            self.lowLabel.text =[NSString stringWithFormat:@"%.4f",[[info objectForKey:@"low"] floatValue]];
            self.volumeLabel.text =[NSString stringWithFormat:@"%d",[[info objectForKey:@"volume"] intValue]];
            self.volumeLabel.text = [Util countNumAndChangeformat:self.volumeLabel.text];
            float rate = (close-open)/open*100;
            if(open == 0){
                rate = 0.00;
            }
            if(rate>=0){
                self.dealRateLabel.text = [NSString stringWithFormat:@"+%.2f%%",rate];
            }else{
                self.dealRateLabel.text = [NSString stringWithFormat:@"%.2f%%",rate];
            }
            
        }
    }else if ([name isEqualToString:@"kline.update"]){
        NSArray* params = [data objectForKey:@"params"];
//        NSLog(@"params = %@",params);
        if(params.count > 0){
            
//            [self.klineArray removeAllObjects];
//            NSLog(@"self.klineArray.count = %ld ",self.klineArray.count);
            NSArray* info = params[0];
//            NSLog(@"info = %@",info);
            NSString* timeStampString = info[0];
            NSTimeInterval interval    =[timeStampString doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString       = [formatter stringFromDate: date];
            [info[1] floatValue];
            NSString* stockinfostr = [NSString stringWithFormat:@"%@ %@ %.4f %@ %.4f %@ %.4f %@ %.4f",dateString,Localize(@"Open"),[info[1] floatValue],Localize(@"Hign"),[info[3] floatValue],Localize(@"Low"),[info[4] floatValue],Localize(@"Closing"),[info[2] floatValue]];
            self.stockInfoLabel.text = stockinfostr;
            
            NSString* date1 = info[0];
            long long time = [date1 longLongValue];
            time = time*1000;
            date1 = [NSString stringWithFormat:@"%lld",time];
            NSString* open = [NSString stringWithFormat:@"%.5f",[info[1] floatValue]] ;
            
            NSString* close = [NSString stringWithFormat:@"%.5f",[info[2] floatValue]];
            NSString* high = [NSString stringWithFormat:@"%.5f",[info[3] floatValue]];
            NSString* low = [NSString stringWithFormat:@"%.5f",[info[4] floatValue]];
            NSString* vol = info[5];
//            NSLog(@"date1 = %@",date1);
            
            if([self.klineUpdateTimeStr isEqualToString:@"0"]){
                //数据第一次来
                self.klineUpdateTimeStr = date1;
            }else{
                if(![self.klineUpdateTimeStr isEqualToString:date1]){
                    NSArray* updateArray = [NSArray arrayWithArray:self.klineUpdateData];
                    [self.klineArray  addObject:updateArray];
                    if(self.klineArray.count>7){
                        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:self.klineArray];
                        self.groupModel = groupModel;
                        [self.modelsDict setObject:groupModel forKey:self.type];
                        //        NSLog(@"groupModel = %@",groupModel);
                        [self.stockChartView reloadData];
                        if([self.MACDBtn.titleLabel.text isEqualToString:@"MACD"]){
                            [_stockChartView setMACDViewHide:NO];
                        }else{
                            [_stockChartView setMACDViewHide:YES];
                        }
                    }
                    
                    self.klineUpdateTimeStr = date1;
                }
            }
            
            [_klineUpdateData removeAllObjects];
            NSArray* info1 = [[NSArray alloc] initWithObjects:date1,open,high,low,close,vol, nil];
            [_klineUpdateData addObjectsFromArray:info1];
            
            
            
            
        }
    }else if ([name isEqualToString:@"deals.update"]){
        
        NSArray* params = [data objectForKey:@"params"];

        if(params.count>=2){
            
            NSMutableArray* temp = params[1];
            NSMutableArray* buytemp = [NSMutableArray new];
            NSMutableArray* selltemp = [NSMutableArray new];
            for (NSDictionary* info in temp) {
                NSString* type = [info objectForKey:@"type"];
                if([type isEqualToString:@"buy"]){
                    [buytemp addObject:info];
                }else{
                    [selltemp addObject:info];
                }
            }
            
            if(!_isFirst){
                NSMutableArray* temp1 = self.updateData;
                NSMutableArray* buytemp1 = [NSMutableArray new];
                NSMutableArray* selltemp1 = [NSMutableArray new];
                for (NSArray* info in temp1) {
                    NSDictionary* tempbuyinfo = info[0];
                    NSString* type = [tempbuyinfo objectForKey:@"type"];
                    if([type isEqualToString:@"buy"]){
                        [buytemp1 addObject:tempbuyinfo];
                    }
                    
                    if(info.count == 2){
                        NSDictionary* tempsellinfo = info[1];
                        NSString* type = [tempsellinfo objectForKey:@"type"];
                        if([type isEqualToString:@"sell"]){
                            [selltemp1 addObject:tempsellinfo];
                        }
                    }
                }
                
//                for (NSDictionary* buyinfo in buytemp) {
//                    double price = [[buyinfo objectForKey:@"price"] doubleValue];
//                    NSIndexSet* buyIndexSet = [buytemp1 indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        return [[obj objectForKey:@"price"] doubleValue] == price;
//                    }];
//
//                    [buytemp1 removeObjectsAtIndexes:buyIndexSet];
//                }
                
//                for (NSDictionary* sellinfo in selltemp) {
//                    double price = [[sellinfo objectForKey:@"price"] doubleValue];
//                    NSIndexSet* sellIndexSet = [selltemp1 indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        return [[obj objectForKey:@"price"] doubleValue] == price;
//                    }];
//
//                    [selltemp1 removeObjectsAtIndexes:sellIndexSet];
//                }
                
                [buytemp addObjectsFromArray:buytemp1];
                [selltemp addObjectsFromArray:selltemp1];
            }
            
//            NSMutableArray* buytemp2 = [self sortDealsData:buytemp];
//            NSMutableArray* selltemp2 = [self sortDealsData:selltemp];
            
            [self.updateData removeAllObjects];
            
            for(int i=0;i<10;i++){
                NSMutableArray* temp3 = [NSMutableArray new];
                if(i<buytemp.count){
//                    NSLog(@"111i == %d",i);
                    [temp3 addObject:buytemp[i]];
                }
                
                if(i<selltemp.count){
//                    NSLog(@"222i == %d",i);
                    [temp3 addObject:selltemp[i]];
                }
                
                if(temp3.count>0){
                    [self.updateData addObject:temp3];
                }
            }
//            if(buytemp2.count>10){
//                [self.updateData addObjectsFromArray:[buytemp2 subarrayWithRange:NSMakeRange(0, 10)]];
//            }else{
//                [self.updateData addObjectsFromArray:buytemp2];
//            }
//
//            if(selltemp2.count>10){
//                [self.updateData addObjectsFromArray:[selltemp2 subarrayWithRange:NSMakeRange(0, 10)]];
//            }else{
//                [self.updateData addObjectsFromArray:selltemp2];
//            }
            
            if(_isFirst){
                _isFirst = NO;
            }
            
            
            
            
            
//            self.updateData = params[1];
//            NSLog(@"info = %@",self.updateData);
            [self.updateDataView reloadData];
        }
    }else if ([name isEqualToString:@"server.ping"]){
        NSString* result = [data objectForKey:@"result"];
//        NSLog(@"ping result:%@",result);
    }
}

-(NSMutableArray*)sortDealsData:(NSMutableArray*)data{
    if(data.count == 0){
        return nil;
    }
    NSMutableArray* temp = [NSMutableArray new];
    
    double price = 0;
    int i=0;
    int tag = 0;
    while (data.count >  0) {
        double tempprice = [[data[i] objectForKey:@"price"] doubleValue];
        if(tempprice>price){
            price = tempprice;
            tag = i;
        }
        i++;
        if(i == data.count){
            
            [temp addObject:data[tag]];
            [data removeObject:data[tag]];
            price = 0;
            tag = 0;
            i = 0;
        }
    }
    return temp;
}


- (void)reloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.type;
    param[@"market"] = @"btc_usdt";
    param[@"size"] = @"1000";
    [NetWorking requestWithApi:@"http://api.bitkk.com/data/v1/kline" param:param thenSuccess:^(NSDictionary *responseObject) {
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject[@"data"]];
        self.groupModel = groupModel;
        [self.modelsDict setObject:groupModel forKey:self.type];
//        NSLog(@"groupModel = %@",groupModel);
        [self.stockChartView reloadData];
    } fail:^{
        
    }];
}
- (IBAction)timeSelectbtn:(id)sender {
}

- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:Localize(@"Immediate") type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"1%@",Localize(@"Min")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"3%@",Localize(@"Min")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"5%@",Localize(@"Min")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"15%@",Localize(@"Min")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"30%@",Localize(@"Min")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"1%@",Localize(@"Hour")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"2%@",Localize(@"Hour")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"4%@",Localize(@"Hour")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"6%@",Localize(@"Hour")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"12%@",Localize(@"Hour")] type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:Localize(@"Day_Line") type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:Localize(@"Week_Line") type:Y_StockChartcenterViewTypeKline],

                                       ];
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.dataSource = self;
        [self.kLineView addSubview:_stockChartView];
        
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (IS_IPHONE_X) {
//                make.edges.equalTo(self.kLineView).insets(UIEdgeInsetsMake(0, 30, 0, 0));
//            } else {
//                make.edges.equalTo(self.kLineView);
//            }
            
            make.edges.equalTo(self.kLineView);
        }];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
//        tap.numberOfTapsRequired = 2;
//        [self.view addGestureRecognizer:tap];
    }
    [_stockChartView setMACDViewHide:YES];
    return _stockChartView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
//    int buycount = 0;
//    int sellcount = 0;
//    for (NSDictionary* info in self.updateData) {
//        NSString* type = [info objectForKey:@"type"];
//        if([type isEqualToString:@"buy"]){
//            buycount++;
//        }else if ([type isEqualToString:@"sell"]){
//            sellcount++;
//        }
//    }
//
//    if(sellcount>=buycount){
//        return sellcount;
//    }else{
//        return buycount;
//    }
    
//    if( self.updateData == nil ||self.updateData.count == 0){
//        return 0;
//    }
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpdateDataTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"UpdateDataTableViewCell" owner:self options:nil].firstObject ;
        
        [cell setBackgroundColor:[UIColor blackColor]];
    }
    if(self.updateData.count<=indexPath.row){
        return cell;
    }
    NSArray* info = self.updateData[indexPath.row];
    NSDictionary* temp1 = info[0];
    
    NSString* type = [temp1 objectForKey:@"type"];
    
    if(info.count==2){
        NSDictionary* temp2 = info[1];
        NSString* type1 = [temp2 objectForKey:@"type"];
        if ([type1 isEqualToString:@"sell"]){
            
            NSString* amount = [temp2 objectForKey:@"amount"];
            NSString* price = [temp2 objectForKey:@"price"];
            cell.sellprice.text = [NSString stringWithFormat:@"%.8f",[price floatValue]];
            cell.sellamount.text = [NSString stringWithFormat:@"%.8f",[amount floatValue]];
        }
    }
    
    if([type isEqualToString:@"buy"]){
        
        NSString* amount = [temp1 objectForKey:@"amount"];
        NSString* price = [temp1 objectForKey:@"price"];
        cell.buyprice.text = [NSString stringWithFormat:@"%.8f",[price floatValue]];
        cell.buyamount.text = [NSString stringWithFormat:@"%.8f",[amount floatValue]];
        
    }
    
    return cell;
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
