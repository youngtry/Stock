//
//  YStockChartViewController.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartViewController.h"
#import "Masonry.h"
#import "Y_StockChartView.h"
#import "Y_StockChartView.h"
#import "NetWorking.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"

#import "SocketInterface.h"
#import "JSONKit.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_MAX_LENGTH MAX(kScreenWidth,kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

@interface Y_StockChartViewController ()<Y_StockChartViewDataSource,SocketDelegate>

@property (nonatomic, strong) Y_StockChartView *stockChartView;

@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *originTime;
@property (nonatomic, assign) NSInteger preciseTime;

@property (nonatomic,strong)NSMutableArray* klineArray;

@property(nonatomic,strong)NSString* klineUpdateTimeStr;
@property(nonatomic,strong)NSMutableArray* klineUpdateData;

@property(nonatomic,strong)NSTimer* update1;

@end

@implementation Y_StockChartViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
    self.type = [NSString stringWithFormat:@"15%@",Localize(@"Min")];
    self.currentIndex = -1;
    _preciseTime = 0;
    
    self.klineArray = [NSMutableArray new];
    self.klineUpdateTimeStr = @"0";
    self.klineUpdateData = [NSMutableArray new];
    
    [[SocketInterface sharedManager] openWebSocket];
    [SocketInterface sharedManager].delegate = self;
    
    
//    if(_update1){
//        [_update1 invalidate];
//        _update1 = nil;
//    }
//
//    _update1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
//    //    [_update1 fire];
//
//    [[NSRunLoop mainRunLoop] addTimer:_update1 forMode:NSDefaultRunLoopMode];
    
    
    
    NSDictionary* params = @{@"market":self.title};
    NSString* url  = @"market/info";
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
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
        weakSelf.stockChartView.backgroundColor = [UIColor backgroundColor];
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
//    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
-(void)sendPing{
    NSArray *dicParma = @[];
    
    //    NSLog(@"Websocket Connected");
    
    NSDictionary *dicAll = @{@"method":@"server.ping",@"params":dicParma,@"id":@(PN_ServerPing)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"server.ping"];
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of  nmthat can be recreated.
}

-(id) stockDatasWithIndex:(NSInteger)index
{
    NSInteger precise = 0;
    NSString *type;
    switch (index) {
        case 0:
        {
            type = Localize(@"Immediate");
            precise = 60;
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
        [self sendKlineRequest:index];
    } else {
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}
- (NSString *)getTimeStrWithString:(NSString *)str{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

-(void)sendKlineRequest:(NSInteger)index{
    
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
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"BeiJing"];
    [formatter setTimeZone:timeZone];
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
    
    NSLog(@"currentTimeString =  %@,%@",currentTimeString,lastTimeString);

    NSString* starttime = [self getTimeStrWithString:lastTimeString];
    NSLog(@"starttime = %@",starttime);
    NSString* endtime = [self getTimeStrWithString:currentTimeString];
    
    
    NSArray *dicParma = @[self.title,
                          @([starttime longLongValue]),
                          @([endtime longLongValue]),
                          @(self.preciseTime)];
    
    NSLog(@"Websocket Connected");
    
    NSDictionary *dicAll = @{@"method":@"kline.query",@"params":dicParma,@"id":@(PN_KlineQuery)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"kline.query"];
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据请求中"];
}

-(void)requestSubscribe{
//    NSArray *dicParma = @[self.title
//                          ];
    NSArray *dicParma1 = @[self.title,
                           @(_preciseTime)
                           ];

    NSDictionary *dicAll1 = @{@"method":@"kline.subscribe",@"params":dicParma1,@"id":@(PN_KlineSubscribe)};
    
    NSString *strAll1 = [dicAll1 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll1 withName:@"kline.subscribe"];
    
}

-(void)getWebData:(id)message withName:(NSString *)name{
    if(nil == message){
        //断线了，需要重连
        [[SocketInterface sharedManager] openWebSocket];
        [SocketInterface sharedManager].delegate = self;
        
        [self sendKlineRequest:0];
        [self requestSubscribe];
        
        return;
    }
    NSString* str = message;
    NSData* strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
    
    id err =[data objectForKey:@"error"];
    
    if(err){
//        NSDictionary* errinfo = err;
//        [HUDUtil showHudViewTipInSuperView:self.view withMessage:[errinfo objectForKey:@"message"]];
//        return;
    }
    
    int requestID = 0;
    id dataid = [data objectForKey:@"id"];
    
    if(dataid != [NSNull null]){
        requestID = [[data objectForKey:@"id"] intValue];
    }
    
//    NSLog(@"name = %@",name);
    
    if(requestID == PN_KlineQuery){
        [HUDUtil hideHudView];
        [self.klineArray removeAllObjects];
        
        if([data objectForKey:@"result"] == [NSNull null]){
            return;
        }
        
        NSArray* result = [data objectForKey:@"result"];
        if(result.count==0){
            return;
        }
//        NSLog(@"收到数据:%ld",result.count);
//        NSLog(@"data = %@,result = %@",data,result);
//        NSMutableArray* need = [[NSMutableArray alloc] initWithCapacity:result.count];
        for(int i=0;i<result.count;i++){
            NSString* date = result[i][0];
            long long time = [date longLongValue];
            time = time*1000;
            date = [NSString stringWithFormat:@"%lld",time];
//            NSLog(@"date = %@",date);
            NSString* open = [NSString stringWithFormat:@"%.5f",[result[i][1] floatValue]] ;
            
            NSString* close = [NSString stringWithFormat:@"%.5f",[result[i][2] floatValue]];
            NSString* high = [NSString stringWithFormat:@"%.5f",[result[i][3] floatValue]];
            NSString* low = [NSString stringWithFormat:@"%.5f",[result[i][4] floatValue]];
            NSString* vol = result[i][5];
            //        NSLog(@"open = %@",open);
            NSArray* info = [[NSArray alloc] initWithObjects:date,open,high,low,close,vol, nil];
            [self.klineArray  setObject:info atIndexedSubscript:i];
        }
        
//        NSLog(@"need = %@",need);
        if(result.count>0){
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:self.klineArray];
            self.groupModel = groupModel;
            [self.modelsDict setObject:groupModel forKey:self.type];
            //        NSLog(@"groupModel = %@",groupModel);
            [self.stockChartView reloadData];
        }
        [self requestSubscribe];
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
//            self.stockInfoLabel.text = stockinfostr;
            
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
//            NSArray* info1 = [[NSArray alloc] initWithObjects:date1,open,high,low,close,vol, nil];
            
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
                        
                    }
                    
                    self.klineUpdateTimeStr = date1;
                }
            }
            
            [_klineUpdateData removeAllObjects];
            NSArray* info1 = [[NSArray alloc] initWithObjects:date1,open,high,low,close,vol, nil];
            [_klineUpdateData addObjectsFromArray:info1];
        
//            [self.klineArray  addObject:info1];
            
//            if(self.klineArray.count>7){
//                Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:self.klineArray];
//                self.groupModel = groupModel;
//                [self.modelsDict setObject:groupModel forKey:self.type];
//                //        NSLog(@"groupModel = %@",groupModel);
//                [self.stockChartView reloadData];
//            }
            
           
            
        }
    }else if ([name isEqualToString:@"server.ping"]){
        NSString* result = [data objectForKey:@"result"];
        //        NSLog(@"ping result:%@",result);
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
        NSLog(@"groupModel = %@",groupModel);
        [self.stockChartView reloadData];
    } fail:^{
        
    }];
}
- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];

        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"15%@",Localize(@"Min")] type:Y_StockChartcenterViewTypeMenu],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"MA" type:Y_StockChartcenterViewTypeMenu],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"MACD" type:Y_StockChartcenterViewTypeMenu],
                                       [Y_StockChartViewItemModel itemModelWithTitle:Localize(@"Kline_Settings") type:Y_StockChartcenterViewTypeMenu],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"" type:Y_StockChartcenterViewTypeMenu],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"" type:Y_StockChartcenterViewTypeMenu],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"" type:Y_StockChartcenterViewTypeMenu],
                                       [Y_StockChartViewItemModel itemModelWithTitle:Localize(@"Kline_Switch") type:Y_StockChartcenterViewTypeMenu],

                                       ];
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.dataSource = self;
        [self.view addSubview:_stockChartView];
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (IS_IPHONE_X) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 30, 0, 0));
            } else {
                make.edges.equalTo(self.view);
            }
        }];
        WeakSelf(weakSelf);
        _stockChartView.switchPhone = ^(void){
            [weakSelf dismiss];
        };
    }
    return _stockChartView;
}
- (void)dismiss
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.isEable = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
@end
