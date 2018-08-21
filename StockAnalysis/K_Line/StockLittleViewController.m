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

@end

@implementation StockLittleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"StockLittleViewController";
    // Do any additional setup after loading the view from its nib.
    [[SocketInterface sharedManager] openWebSocket];
    [SocketInterface sharedManager].delegate = self;
//    [[SocketInterface sharedManager] closeWebSocket];
    UIBarButtonItem* priceTipBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addTips.png"] style:UIBarButtonItemStyleDone target:self action:@selector(priceTips)];
    UIBarButtonItem* followBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addstar.png"] style:UIBarButtonItemStyleDone target:self action:@selector(followBtn)];
    [self.navigationItem setRightBarButtonItems:@[priceTipBtn,followBtn] animated:YES];
}

-(void)priceTips{
    
}

-(void)followBtn{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO];
    self.klineArray = [NSMutableArray new];
    self.currentIndex = -1;
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
    self.updateDataView.delegate = self;
    self.updateDataView.dataSource = self;
    self.updateDataView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.updateDataView.allowsSelection = NO;
    self.updateData = [NSMutableArray new];
    
    [self closeAllBtnView];
    
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
-(void)closeAllBtnView{
    [self.timeSelectView setHidden:YES];
    [self.settingView setHidden:YES];
    [self.MAView setHidden:YES];
    
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
    [self closeAllBtnView];
    UIButton* btn = sender;
    [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
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
    
    NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(1)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
    
    NSDictionary *dicAll1 = @{@"method":@"kline.unsubscribe",@"params":@[],@"id":@(1)};
    
    NSString *strAll1 = [dicAll1 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll1 withName:@"kline.unsubscribe"];
    
    NSDictionary *dicAll2 = @{@"method":@"deals.unsubscribe",@"params":@[],@"id":@(1)};
    
    NSString *strAll2 = [dicAll2 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll2 withName:@"deals.unsubscribe"];
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.isEable = YES;
    Y_StockChartViewController *stockChartVC = [Y_StockChartViewController new];
    stockChartVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:stockChartVC animated:YES completion:nil];
}


- (IBAction)clickTimeSelectBtn:(id)sender {
    UIButton* btn = sender;
    NSString* btntext = btn.titleLabel.text;
    NSLog(@"btntext = %@",btntext);
    [btn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    for (UIView* child in [self.timeSelectView subviews]) {
        if([child isKindOfClass:[UIButton class]]){
            UIButton* nextbtn = (UIButton*)child;
//            NSLog(@"nextbtn = %@",nextbtn.titleLabel.text);
            if(![nextbtn.titleLabel.text isEqualToString:btntext]){
                [nextbtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            }
        }
    }
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
    }
    
    
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    NSDate *lastdate = [NSDate dateWithTimeInterval:-60*60 sinceDate:datenow];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSString *lastTimeString = [formatter stringFromDate:lastdate];
    
    NSLog(@"currentTimeString =  %@,%@",currentTimeString,lastTimeString);
    
    
 
    NSString* starttime = [self getTimeStrWithString:lastTimeString];
    NSLog(@"starttime = %@",starttime);
    NSString* endtime = [self getTimeStrWithString:currentTimeString];
    
    
    NSArray *dicParma = @[self.title,
                          @([starttime longLongValue]),
                          @([endtime longLongValue]),
                          @(6)];
    
//    NSLog(@"Websocket Connected");
    
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
