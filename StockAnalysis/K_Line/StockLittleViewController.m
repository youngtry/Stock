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
@property (nonatomic, strong) Y_StockChartView *stockChartView;

@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;

@property (nonatomic,strong)NSMutableArray* klineArray;

@end

@implementation StockLittleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"StockLittleViewController";
    // Do any additional setup after loading the view from its nib.
    [SocketInterface sharedManager].delegate = self;
    self.klineArray = [NSMutableArray new];
    self.currentIndex = -1;
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
    self.updateDataView.delegate = self;
    self.updateDataView.dataSource = self;
    self.updateDataView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.view setBackgroundColor:[UIColor blackColor]];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(1)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
    
    NSDictionary *dicAll1 = @{@"method":@"kline.unsubscribe",@"params":@[],@"id":@(1)};
    
    NSString *strAll1 = [dicAll1 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll1 withName:@"kline.unsubscribe"];
    
    NSDictionary *dicAll2 = @{@"method":@"deals.unsubscribe",@"params":@[],@"id":@(1)};
    
    NSString *strAll2 = [dicAll2 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll2 withName:@"deals.unsubscribe"];
}


-(void)requestSubscribe{
    NSArray *dicParma = @[self.title
                          ];
    NSArray *dicParma1 = @[self.title,
                          @(6)
                          ];
    
    NSDictionary *dicAll = @{@"method":@"state.subscribe",@"params":dicParma,@"id":@(1)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.subscribe"];
    
    NSDictionary *dicAll1 = @{@"method":@"kline.subscribe",@"params":dicParma1,@"id":@(1)};
    
    NSString *strAll1 = [dicAll1 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll1 withName:@"kline.subscribe"];
    
    NSDictionary *dicAll2 = @{@"method":@"deals.subscribe",@"params":dicParma,@"id":@(1)};
    
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
    NSString *type;
    switch (index) {
        case 0:
        {
            type = @"1min";
        }
            break;
        case 1:
        {
            type = @"1min";
        }
            break;
        case 2:
        {
            type = @"1min";
        }
            break;
        case 3:
        {
            type = @"5min";
        }
            break;
        case 4:
        {
            type = @"30min";
        }
            break;
        case 5:
        {
            type = @"1hour";
        }
            break;
        case 6:
        {
            type = @"1day";
        }
            break;
        case 7:
        {
            type = @"1week";
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    if(![self.modelsDict objectForKey:type])
    {
//        [self reloadData];
        [self sendKlineRequest];
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

-(void)sendKlineRequest{
    NSString* starttime = [self getTimeStrWithString:@"2018-07-30 00:00:00"];
    NSLog(@"starttime = %@",starttime);
    NSString* endtime = [self getTimeStrWithString:@"2018-07-30 01:00:00"];
    
    
    NSArray *dicParma = @[self.title,
                          @([starttime longLongValue]),
                          @([endtime longLongValue]),
                          @(6)];
    
    NSLog(@"Websocket Connected");
    
    NSDictionary *dicAll = @{@"method":@"kline.query",@"params":dicParma,@"id":@(1)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"kline.query"];
}

-(void)getWebData:(id)message withName:(NSString *)name{
    
    NSString* str = message;
    NSData* strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
    
    NSNull* err =[data objectForKey:@"error"];
    
    if(err){
        NSLog(@"err = %@",err);
    }
    
    if([name isEqualToString:@"kline.query"]){
        
        NSArray* result = [data objectForKey:@"result"];
//        NSLog(@"result = %@",result);
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
            //        NSLog(@"open = %@",open);
            NSArray* info = [[NSArray alloc] initWithObjects:date,open,close,high,low,vol, nil];
            [self.klineArray  setObject:info atIndexedSubscript:i];
        }
        
//        NSLog(@"need = %@",need);
        
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:self.klineArray];
        self.groupModel = groupModel;
        [self.modelsDict setObject:groupModel forKey:self.type];
//        NSLog(@"groupModel = %@",groupModel);
        [self.stockChartView reloadData];
        
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
            NSLog(@"self.klineArray.count = %ld ",self.klineArray.count);
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
            NSArray* info = params[1];
            NSLog(@"info = %@",info);
            for (NSDictionary* infodata in info) {
                NSLog(@"infotype = %@",[infodata objectForKey:@"type"]);
            }
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
- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"指标" type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"分时" type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"5分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"30分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"60分" type:Y_StockChartcenterViewTypeKline],
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
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 12;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        
        [cell setBackgroundColor:[UIColor blackColor]];
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    //    NSLog(@"获取历史记录");
    
    
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
