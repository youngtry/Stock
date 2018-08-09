//
//  TradePurchaseViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/6/24.
//  Copyright © 2018年 try. All rights reserved.
//

#import "TradePurchaseViewController.h"
#import "RadioButton.h"
#import "HttpRequest.h"
#import "SocketInterface.h"
#import "TradeStockSelectTableViewCell.h"
#import "TradeStockInfoTableViewCell.h"
#import "askAndBidsTableViewCell.h"
@interface TradePurchaseViewController ()<SocketDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *editNumContainer;
@property (weak, nonatomic) IBOutlet UIView *editPriceContainer;
@property (weak, nonatomic) IBOutlet UIView *editPercentContainer;
@property (weak, nonatomic) IBOutlet UIButton *purchaseBtn;
@property (weak, nonatomic) IBOutlet UIView *sortGuideView;
@property (weak, nonatomic) IBOutlet UIView *sortTitleView;
@property (weak, nonatomic) IBOutlet UIView *sortContantView;
@property (weak, nonatomic) IBOutlet UITableView *stcokInfoView;
@property (weak, nonatomic) IBOutlet UITableView *stcokSelectView;
@property (weak, nonatomic) IBOutlet UIButton *marketNamelabel;
@property (weak, nonatomic) IBOutlet UIView *buyTypeView;
@property (weak, nonatomic) IBOutlet UIButton *selectBuyTypeBtn;
@property (weak, nonatomic) IBOutlet UIView *marketPriceView;

@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *depthView;
@property (weak, nonatomic) IBOutlet UITableView *askList;
@property (weak, nonatomic) IBOutlet UITableView *bidsList;
@property (nonatomic,strong)RadioButton *radioBtn;

@property (nonatomic,strong)NSMutableArray* titleArray;
@property (nonatomic,strong)NSMutableArray* infoArray;

@property (nonatomic)BOOL firstOpen;
@end

@implementation TradePurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleArray = [NSMutableArray new];
    self.infoArray = [NSMutableArray new];
   
    
    
    self.stcokInfoView.delegate = self;
    self.stcokInfoView.dataSource = self;
    
    self.stcokSelectView.delegate = self;
    self.stcokSelectView.dataSource = self;
    
    self.askList.delegate = self;
    self.askList.dataSource = self;
    
    self.bidsList.delegate = self;
    self.bidsList.dataSource = self;
    
    [self.sortGuideView setHidden:YES];
    [self.buyTypeView setHidden:YES];
    [self.marketPriceView setHidden:YES];
    [self.depthView setHidden:YES];
    
    [self .selectBuyTypeBtn setTitle:@"限价买入" forState:UIControlStateNormal];
    
    [self customeView];
    
    if([self.title isEqualToString:@"卖出"]){
        [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
    }else if([self.title isEqualToString:@"买入"]){
        [self.purchaseBtn setBackgroundColor:[UIColor greenColor]];
    }
    
    //单选按钮
    NSArray *tiles = @[@"25%",@"50%",@"75%",@"100%"];
    self.radioBtn = [[RadioButton alloc] initWithFrame:self.editPercentContainer.bounds titles:tiles selectIndex:-1];
    [self.editPercentContainer addSubview:self.radioBtn];
    self.editPercentContainer.backgroundColor = [UIColor whiteColor];
    self.radioBtn.indexChangeBlock = ^(NSInteger index){
        DLog(@"index:%li",index);
    };
}

-(void)customeView{
    self.editNumContainer.layer.borderWidth = 1;
    self.editNumContainer.layer.borderColor = [kColorRGBA(128, 128, 128,0.9) CGColor];
    self.editNumContainer.layer.cornerRadius = 3;
    
    self.editPriceContainer.layer.borderWidth = 1;
    self.editPriceContainer.layer.borderColor = [kColor(128, 128, 128) CGColor];
    self.editPriceContainer.layer.cornerRadius = 3;
    
    self.editPercentContainer.layer.cornerRadius = 12;//self.editNumContainer.height/2.0f;
    self.purchaseBtn.layer.cornerRadius = 20;
    
    self.buyTypeView.layer.borderWidth = 1;
    self.buyTypeView.layer.borderColor = [kColorRGBA(128, 128, 128,0.6) CGColor];
    
    self.depthView.layer.borderWidth = 1;
    self.depthView.layer.borderColor = [kColorRGBA(128, 128, 128,0.6) CGColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.firstOpen = YES;
    NSLog(@"title = %@",self.title);
    if([self.title isEqualToString:@"卖出"]){
        [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
    }else if([self.title isEqualToString:@"买入"]){
        [self.purchaseBtn setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:185.0/255.0 blue:112.0/255.0 alpha:1.0]];
    }
//    [[SocketInterface sharedManager] openWebSocket];
    
    
    self.askList.tableFooterView = [UIView new];
    self.bidsList.tableFooterView = [UIView new];
    
    self.askList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bidsList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [SocketInterface sharedManager].delegate = self;
    [self requestAnalysis];
    
//    NSString* starttime = [self getTimeStrWithString:@"2018-08-07 00:00:00"];
//    NSString* endtime = [self getTimeStrWithString:@"2018-08-08 01:00:00"];
    
    NSDictionary* parameters = @{@"market":@"",
                                 @"state":@"",
                                 @"page":@"1",
                                 @"page_limit":@"10"
                                 };
    
    NSString* url = @"exchange/trades";
    
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            NSLog(@"挂单列表:%@",data);
        }
    }];
    
    
    
    
//    NSArray *dicParma = @[@"LDGFRMB",
//                          @(10),
//                          @"0.1"
//                          ];
//    NSDictionary *dicAll = @{@"method":@"depth.subscribe",@"params":dicParma,@"id":@(1)};
//
//    NSString *strAll = [dicAll JSONString];
    
    
//    [[SocketInterface sharedManager] sendRequest:strAll withName:@"depth.subscribe"];
}

-(void)getTradeInfo{
    
}

-(void)requestAnalysis{
    
    NSDictionary* parameters = @{};
    NSString* url = @"market/assortment";
    [self.titleArray removeAllObjects];
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                if([[data objectForKey:@"data"] objectForKey:@"tabs"]){
                    NSArray* tabs = [[data objectForKey:@"data"] objectForKey:@"tabs"];
                    for (NSDictionary* tab in tabs) {
                        NSString* tabtitle = [tab objectForKey:@"asset"];
//                        [chinaTitles addObject:tabtitle];
                        [self.titleArray addObject:tabtitle];
                    }
                    
                    NSLog(@"111self.titleArray = %@",self.titleArray);
//                    [_sortTitleView ]
                    
                    [_stcokSelectView reloadData];
                    
                    if(_firstOpen){
                        [self setOpenSelect];
                        _firstOpen = NO;
                    }
                    
                    
                    
                }
            }
        }
    }];
    
//    NSString* url1 = @"market/global/assortment";
//    [[HttpRequest getInstance] getWithURL:url1 parma:parameters block:^(BOOL success, id data) {
//        if(success){
//            if([[data objectForKey:@"data"] objectForKey:@"tabs"]){
//                NSArray* tabs = [[data objectForKey:@"data"] objectForKey:@"tabs"];
//                for (NSString* tab in tabs) {
////                    NSString* tabtitle = [tab objectForKey:@"asset"];
//                    //                        [chinaTitles addObject:tabtitle];
//                    [self.titleArray addObject:tab];
//                }
//                NSLog(@"self.titleArray = %@",self.titleArray);
//                [_stcokSelectView reloadData];
//            }
//        }
//    }];
    
}

-(void)setOpenSelect{
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.stcokSelectView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    TradeStockSelectTableViewCell* cell = [self.stcokSelectView cellForRowAtIndexPath:selectedIndexPath];
    NSString* name = cell.name.text;
    
    NSDictionary* parameters = @{@"order_by":@"price",
                                 @"order":@"desc",
                                 @"asset":name
                                 };
    NSString* url = @"market/item";
    
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                self.infoArray = [[data objectForKey:@"data"] objectForKey:@"items"];
                if(self.infoArray){
//                    NSLog(@"items = %@",self.infoArray);
                    [self.stcokInfoView reloadData];
                    
                    NSInteger selectedIndex1 = 0;
                    NSIndexPath *selectedIndexPath1 = [NSIndexPath indexPathForRow:selectedIndex1 inSection:0];
                    [self.stcokInfoView selectRowAtIndexPath:selectedIndexPath1 animated:NO scrollPosition:UITableViewScrollPositionNone];
                    
                    TradeStockInfoTableViewCell* cell1 = [self.stcokInfoView cellForRowAtIndexPath:selectedIndexPath];
                    
                    [self.marketNamelabel setTitle:cell1.name.text forState:UIControlStateNormal];
                }
            }
        }
    }];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.radioBtn reloadFrame:self.editPercentContainer.bounds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}
- (IBAction)clickSortView:(id)sender {
    [self.sortGuideView setHidden:NO];
    
    [self requestAnalysis];
    
}
- (IBAction)clickLimitBuy:(id)sender {
    UIButton* btn = sender;
    [self.buyTypeView setHidden:YES];
    [self.selectBuyTypeBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    
    [self.marketPriceView setHidden:YES];
    
    [self.editPriceContainer setHidden:NO];
}

- (IBAction)clickQuickBuy:(id)sender {
    UIButton* btn = sender;
    [self.buyTypeView setHidden:YES];
    [self.selectBuyTypeBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    
    [self.marketPriceView setHidden:NO];
    
    [self.editPriceContainer setHidden:YES];
}

- (IBAction)clickSelectBuyType:(id)sender {
    if(!self.buyTypeView.isHidden){
        [self.buyTypeView setHidden:YES];
    }else{
        [self.buyTypeView setHidden:NO];
    }
}
- (IBAction)clickFour:(id)sender {
    [self.depthView setHidden:YES];
}
- (IBAction)clickOne:(id)sender {
    [self.depthView setHidden:YES];
}
- (IBAction)clickZero:(id)sender {
    [self.depthView setHidden:YES];
}
- (IBAction)clickDepth:(id)sender {
    if(self.depthView.isHidden){
        [self.depthView setHidden:NO];
    }else{
        [self.depthView setHidden:YES];
    }
    
}

#pragma mark ---------SocketDalegate------------
-(void)getWebData:(id)message withName:(NSString *)name{
    NSString* str = message;
    NSData* strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
    
    NSNull* err =[data objectForKey:@"error"];
    
    if(err){
        NSLog(@"err = %@",err);
    }
    
    if([name isEqualToString:@"depth.update"]){
        NSLog(@"数据详情:%@",data);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    if(tableView == self.stcokSelectView){
        return self.titleArray.count;
    }
    
    if(tableView == self.stcokInfoView){
        return self.infoArray.count;
    }

        return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    indexPath.section
    //    indexPath.row
    //    if (indexPath.section == 0) {
    //        return 50;
    //    }
    
    if(tableView == self.askList || tableView == self.bidsList){
        return 20;
    }
    
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(tableView == self.stcokSelectView){
        TradeStockSelectTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TradeStockSelectTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        NSString* titletext = self.titleArray[indexPath.row];
        NSLog(@"titletext = %@",titletext);
        cell.name.text = titletext;
        return cell;
    }
    
    if(tableView == self.stcokInfoView){
        TradeStockInfoTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TradeStockInfoTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        NSDictionary* info = self.infoArray[indexPath.row];
        
        NSString* name = [info objectForKey:@"market"];
        NSString* rate = [NSString stringWithFormat:@"%.2f%%",[[info objectForKey:@"increase"] floatValue]];
        NSString* volume = [NSString stringWithFormat:@"%.0f",[[info objectForKey:@"volume"] floatValue]];
        
        cell.name.text = name;
        cell.upRate.text = rate;
        cell.volume.text = volume;
        
        return cell;
    }
    
    if(tableView == self.askList){
        askAndBidsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"askAndBidsTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        
        
        return cell;
    }
    
    if(tableView == self.bidsList){
        askAndBidsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"askAndBidsTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.stcokSelectView){
        TradeStockSelectTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString* name = cell.name.text;
        
        NSDictionary* parameters = @{@"order_by":@"price",
                                     @"order":@"desc",
                                     @"asset":name
                                     };
        NSString* url = @"market/item";
        
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
                //            NSLog(@"list = %@",data);
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [self.infoArray removeAllObjects];
                    self.infoArray = [[data objectForKey:@"data"] objectForKey:@"items"];
                    if(self.infoArray){
//                        NSLog(@"items = %@",self.infoArray);
                        [self.stcokInfoView reloadData];
                    }
                }
            }
        }];
        
    }
    if(tableView == self.stcokInfoView){
        TradeStockInfoTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [self.marketNamelabel setTitle:cell.name.text forState:UIControlStateNormal];
//        self.marketNamelabel.titleLabel.text = cell.name.text;
        [self.sortGuideView setHidden:YES];
    }
    
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
