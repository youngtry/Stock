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




//@property (weak, nonatomic) IBOutlet UIButton *timeEverytimeBtn;
//@property (weak, nonatomic) IBOutlet UIButton *time1MinBtn;
//@property (weak, nonatomic) IBOutlet UIButton *time3MinBtn;
//@property (weak, nonatomic) IBOutlet UIButton *time5MinBtn;
//@property (weak, nonatomic) IBOutlet UIButton *time15MinBtn;
//@property (weak, nonatomic) IBOutlet UIButton *time30MinBtn;
//@property (weak, nonatomic) IBOutlet UIButton *time1HBtn;
//@property (weak, nonatomic) IBOutlet UIButton *time2HBtn;
//@property (weak, nonatomic) IBOutlet UIButton *time4HBtn;
//@property (weak, nonatomic) IBOutlet UIButton *time6HBtn;



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

@end

@implementation StockLittleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"StockLittleViewController";
    // Do any additional setup after loading the view from its nib.
    [[SocketInterface sharedManager] openWebSocket];
    [SocketInterface sharedManager].delegate = self;
//    [[SocketInterface sharedManager] closeWebSocket];
    self.isFollow = NO;
    self.isTip = NO;
    
    _preciseTime = 0;
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO];
    self.klineArray = [NSMutableArray new];
    self.currentIndex = -1;
//    self.stockChartView.backgroundColor = [UIColor backgroundColor];
    self.updateDataView.delegate = self;
    self.updateDataView.dataSource = self;
    self.updateDataView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.updateDataView.allowsSelection = NO;
    self.updateData = [NSMutableArray new];
    
    
    [[SearchData getInstance].specialList removeAllObjects];
    
    
    NSDictionary* params = @{@"market":self.title};
    NSString* url  = @"market/info";
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [[AppData getInstance] setOriginTime:[[data objectForKey:@"data"] objectForKey:@"created_at"]];
            }else{
                [[AppData getInstance] setOriginTime:@""];
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"数据出错"];
            }
            
        }
        _originTime = [[AppData getInstance] getOriginTime];
        self.stockChartView.backgroundColor = [UIColor backgroundColor];
        
    }];
    
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
                            if([[info objectForKey:@"market"] isEqualToString:self.title]){
                                self.isFollow = YES;
                                break;
                            }
                        }
                        
                    }
                }
            }else{
                
                [HUDUtil showHudViewInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
        
        [self requestTips];
    }];
    
    [self closeAllBtnView];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
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
    
    [[HttpRequest getInstance] getWithURL:url1 parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* items = [[data objectForKey:@"data"] objectForKey:@"items"];
                for (NSDictionary* item in items) {
                    if([[item objectForKey:@"market"] isEqual:self.title]){
                        
                        if([[item objectForKey:@"state"] isEqualToString:@"enable"]){
                            tipspic = @"tips.png";
                            self.isTip = YES;
                        }else if([[item objectForKey:@"state"] isEqualToString:@"disable"]){
                            tipspic = @"addTips.png";
                            self.isTip = NO;
                        }
                    }
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
    
    PriceTipViewController* vc = [[PriceTipViewController alloc] initWithNibName:@"PriceTipViewController" bundle:nil];
    [vc setTitle:[NSString stringWithFormat:@"%@_%d",self.title,self.isTip]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)followBtn{
    if(self.isFollow){
        NSDictionary* parameters = @{@"market":self.title};
        NSString* url = @"/market/unfollow";
        [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
                if([[data objectForKey:@"ret"] intValue] == 1){
                    self.isFollow = NO;
                    [self.navigationItem.rightBarButtonItems[1] setImage:[[UIImage imageNamed:@"addstar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                    for (NSDictionary* info in [SearchData getInstance].specialList) {
                        if([[info objectForKey:@"market"] isEqualToString:self.title]){
                            [[SearchData getInstance].specialList removeObject:info];
                            break;
                        }
                    }
                }else{
                    
                    [HUDUtil showHudViewInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                    
                }
            }
        }];
    }else{
        NSDictionary* parameters = @{@"market":self.title};
        NSString* url = @"/market/follow";
        [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
                if([[data objectForKey:@"ret"] intValue] == 1){
                    self.isFollow = YES;
                    [self.navigationItem.rightBarButtonItems[1] setImage:[[UIImage imageNamed:@"star.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                    for (NSDictionary* info in [SearchData getInstance].searchList) {
                        if([[info objectForKey:@"market"] isEqualToString:self.title]){
                            [[SearchData getInstance].specialList addObject:info];
                            break;
                        }
                    }
                    
                }else{
                    
                    [HUDUtil showHudViewInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                    
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
    stockChartVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:stockChartVC animated:YES completion:nil];
}


- (IBAction)clickTimeSelectBtn:(id)sender {
    UIButton* btn = sender;
    NSString* btntext = btn.titleLabel.text;
    NSLog(@"btntext = %@",btntext);
    [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.timeSelectBtn setTitle:btntext forState:UIControlStateNormal];
    [self.timeSelectView setHidden:YES];
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
    if(![btn.titleLabel.text isEqualToString:@"默认"] && ![btn.titleLabel.text isEqualToString:@"+"] && ![btn.titleLabel.text isEqualToString:@"-"] && ![btn.titleLabel.text isEqualToString:@"保存"]){
        [btn setBackgroundImage:[UIImage imageNamed:@"btnselectbg.png"] forState:UIControlStateNormal];
    }
    
    
    for (UIView* child in [self.settingView subviews]) {
        if([child isKindOfClass:[UIButton class]]){
            UIButton* nextbtn = (UIButton*)child;
            //            NSLog(@"nextbtn = %@",nextbtn.titleLabel.text);
            if(![nextbtn.titleLabel.text isEqualToString:btntext] && ![nextbtn.titleLabel.text isEqualToString:@"默认"] && ![nextbtn.titleLabel.text isEqualToString:@"+"] && ![nextbtn.titleLabel.text isEqualToString:@"-"] && ![nextbtn.titleLabel.text isEqualToString:@"保存"]){
                [nextbtn setBackgroundImage:[UIImage imageNamed:@"btnbg.png"] forState:UIControlStateNormal];
            }
        }
    }
}
- (IBAction)clickMABtn:(id)sender {
    UIButton* btn = sender;
    NSString* btntext = btn.titleLabel.text;
    NSLog(@"btntext = %@",btntext);
    if(![btntext isEqualToString:@"关闭"]){
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
    if(![btntext isEqualToString:@"关闭"]){
        [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.MACDBtn setTitle:@"MACD" forState:UIControlStateNormal];
    }else{
        [self.MACDBtn setTitle:btntext forState:UIControlStateNormal];
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
    TradePurchaseViewController* vc = [[TradePurchaseViewController alloc] initWithNibName:@"TradePurchaseViewController" bundle:nil];
    vc.title = @"买入";
    [self.navigationController pushViewController:vc animated:YES];
    [vc setTradeName:self.title];
    
    
    
}
- (IBAction)clickSell:(id)sender {
    TradePurchaseViewController* vc = [[TradePurchaseViewController alloc] initWithNibName:@"TradePurchaseViewController" bundle:nil];
    vc.title = @"卖出";
    [self.navigationController pushViewController:vc animated:YES];
    [vc setTradeName:self.title];
}

-(void)requestSubscribe{
    NSArray *dicParma = @[self.title
                          ];
    NSArray *dicParma1 = @[self.title,
                          @(6)
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
    NSInteger precise = 0;
    NSString *type;
    switch (index) {
        case 0:
        {
            type = @"分时";
            precise = 10;
        }
            break;
        case 1:
        {
            type = @"1分";
            precise = 60;
        }
            break;
        case 2:
        {
            type = @"3分";
            precise = 180;
        }
            break;
        case 3:
        {
            type = @"5分";
            precise = 300;
        }
            break;
        case 4:
        {
            type = @"15分";
            precise = 900;
        }
            break;
        case 5:
        {
            type = @"30分";
            precise = 1800;
        }
            break;
        case 6:
        {
            type = @"1小时";
            precise = 3600;
        }
            break;
        case 7:
        {
            type = @"2小时";
            precise = 7200;
        }
            break;
        case 8:
        {
            type = @"4小时";
            precise = 14400;
        }
            break;
        case 9:
        {
            type = @"6小时";
            precise = 21600;
        }
            break;
        case 10:
        {
            type = @"12小时";
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
            type = @"分时";
            precise = 10;
        }
            break;
        case 1:
        {
            type = @"1分";
            precise = 60;
        }
            break;
        case 2:
        {
            type = @"3分";
            precise = 180;
        }
            break;
        case 3:
        {
            type = @"5分";
            precise = 300;
        }
            break;
        case 4:
        {
            type = @"15分";
            precise = 900;
        }
            break;
        case 5:
        {
            type = @"30分";
            precise = 1800;
        }
            break;
        case 6:
        {
            type = @"1小时";
            precise = 3600;
        }
            break;
        case 7:
        {
            type = @"2小时";
            precise = 7200;
        }
            break;
        case 8:
        {
            type = @"4小时";
            precise = 14400;
        }
            break;
        case 9:
        {
            type = @"6小时";
            precise = 21600;
        }
            break;
        case 10:
        {
            type = @"12小时";
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

-(void)sendKlineRequest{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    NSDate *lastdate = [NSDate dateWithTimeInterval:-60*60 sinceDate:datenow];
    
    
    NSDate* origindate = lastdate;
    if(_originTime.length > 0){
        origindate = [formatter dateFromString:_originTime];
    }
    //    _preciseTime = 6;
    
    NSDate* expecttime = [NSDate dateWithTimeIntervalSinceNow:-_preciseTime*500];
    
    lastdate =  [origindate laterDate:expecttime];
    
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSString *lastTimeString = [formatter stringFromDate:lastdate];
    
    NSLog(@"currentTimeString =  %@,%@",currentTimeString,lastTimeString);
    
    
 
    NSString* starttime = [self getTimeStrWithString:lastTimeString];
    NSLog(@"starttime = %@",starttime);
    NSString* endtime = [self getTimeStrWithString:currentTimeString];
    
    
    NSArray *dicParma = @[self.title,
                          @([starttime longLongValue]),
                          @([endtime longLongValue]),
                          @(self.preciseTime)];
    
//    NSLog(@"Websocket Connected");
    
    NSDictionary *dicAll = @{@"method":@"kline.query",@"params":dicParma,@"id":@(PN_KlineQuery)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"kline.query"];
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据请求中"];
}

-(void)getWebData:(id)message withName:(NSString *)name{
    
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
        NSArray* result = [data objectForKey:@"result"];
        NSLog(@"result = %lu",(unsigned long)result.count);
//        NSMutableArray* need = [[NSMutableArray alloc] initWithCapacity:result.count];
        [self.klineArray removeAllObjects];
        for(int i=0;i<result.count;i++){
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
            NSArray* info = [[NSArray alloc] initWithObjects:date,open,close,high,low,vol, nil];
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
            self.periodPrice.text = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"last"] floatValue]];
            self.dealLabel.text =[NSString stringWithFormat:@"%d",[[info objectForKey:@"deal"] intValue]];
            self.highLabel.text =[NSString stringWithFormat:@"%.4f",[[info objectForKey:@"high"] floatValue]];
            self.lowLabel.text =[NSString stringWithFormat:@"%.4f",[[info objectForKey:@"low"] floatValue]];
            self.volumeLabel.text =[NSString stringWithFormat:@"%d",[[info objectForKey:@"volume"] intValue]];
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
            NSString* stockinfostr = [NSString stringWithFormat:@"%@ 开 %.4f 高 %.4f 低 %.4f 收 %.4f",dateString,[info[1] floatValue],[info[3] floatValue],[info[4] floatValue],[info[2] floatValue]];
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
            //        NSLog(@"open = %@",open);
            NSArray* info1 = [[NSArray alloc] initWithObjects:date1,open,close,high,low,vol, nil];
            [self.klineArray  addObject:info1];
            
//            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:self.klineArray];
//            self.groupModel = groupModel;
//            [self.modelsDict setObject:groupModel forKey:self.type];
//            //        NSLog(@"groupModel = %@",groupModel);
//            [self.stockChartView reloadData];

        }
    }else if ([name isEqualToString:@"deals.update"]){
        
        NSArray* params = [data objectForKey:@"params"];

        if(params.count>=2){
            [self.updateData removeAllObjects];
            self.updateData = params[1];
//            NSLog(@"info = %@",self.updateData);
            [self.updateDataView reloadData];
        }
    }
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
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"分时" type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"3分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"5分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"15分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"30分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1小时" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"2小时" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"4小时" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"6小时" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"12小时" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"日线" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"周线" type:Y_StockChartcenterViewTypeKline],

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
    return _stockChartView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    int buycount = 0;
    int sellcount = 0;
    for (NSDictionary* info in self.updateData) {
        NSString* type = [info objectForKey:@"type"];
        if([type isEqualToString:@"buy"]){
            buycount++;
        }else if ([type isEqualToString:@"sell"]){
            sellcount++;
        }
    }
    
    if(sellcount>=buycount){
        return sellcount;
    }else{
        return buycount;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 12;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpdateDataTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UpdateDataTableViewCell" owner:self options:nil] objectAtIndex:0];
        
        [cell setBackgroundColor:[UIColor blackColor]];
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:0];
        
    }
    //    NSLog(@"获取历史记录");
    int buycount = 0;
    int sellcount = 0;
    for (NSDictionary* info in self.updateData) {
        NSString* type = [info objectForKey:@"type"];
        if([type isEqualToString:@"buy"]){
            if(buycount != indexPath.row){
                buycount++;
            }else{
                NSString* amount = [info objectForKey:@"amount"];
                NSString* price = [info objectForKey:@"price"];
                cell.buyprice.text = [NSString stringWithFormat:@"%.4f",[price floatValue]];
                cell.buyamount.text = [NSString stringWithFormat:@"%.4f",[amount floatValue]];
            }
            
        }else if ([type isEqualToString:@"sell"]){
            if(sellcount != indexPath.row){
                sellcount++;
            }else{
                NSString* amount = [info objectForKey:@"amount"];
                NSString* price = [info objectForKey:@"price"];
                cell.sellprice.text = [NSString stringWithFormat:@"%.4f",[price floatValue]];
                cell.sellamount.text = [NSString stringWithFormat:@"%.4f",[amount floatValue]];
            }
        }
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
