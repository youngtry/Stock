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
#import "MoneyVerifyViewController.h"
#import "SortView.h"
#import "PendingOrderTableViewCell.h"
@interface TradePurchaseViewController ()<SocketDelegate,UITableViewDelegate,UITableViewDataSource,CancelDelegate>
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
@property (weak, nonatomic) IBOutlet UILabel *periodPrice;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRMBLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchasePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseAmountLabel;
@property (weak, nonatomic) IBOutlet UITextView *purchaseAmountInput;
@property (weak, nonatomic) IBOutlet UITextView *purchasePriceInput;
@property (nonatomic,strong)RadioButton *radioBtn;
@property (weak, nonatomic) IBOutlet UIView *ShowBuyTypeView;
@property (weak, nonatomic) IBOutlet UIButton *buyTypeLimitBtn;

@property (weak, nonatomic) IBOutlet UIButton *buyTypeMarketBtn;
@property (weak, nonatomic) IBOutlet UIImageView *buyTypeViewImage;
@property (weak, nonatomic) IBOutlet UIImageView *buyTypeViewArrow;
@property (weak, nonatomic) IBOutlet UILabel *avaliableMoney;
@property (weak, nonatomic) IBOutlet UILabel *canButAmount;
@property (nonatomic,strong)NSMutableArray* titleArray;
@property (nonatomic,strong)NSMutableArray* infoArray;

@property (nonatomic,strong)NSMutableArray* asksArray;
@property (nonatomic,strong)NSMutableArray* bidsArray;
@property (weak, nonatomic) IBOutlet UITableView *dealList;

@property (nonatomic,strong)NSMutableDictionary* dealData;

@property (nonatomic)BOOL firstOpen;
@end



@implementation TradePurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleArray = [NSMutableArray new];
    self.infoArray = [NSMutableArray new];
   
    self.asksArray = [NSMutableArray new];
    self.bidsArray = [NSMutableArray new];
    
    self.dealData = [NSMutableDictionary new];
    
    self.stcokInfoView.delegate = self;
    self.stcokInfoView.dataSource = self;
    
    self.stcokSelectView.delegate = self;
    self.stcokSelectView.dataSource = self;
    
    self.askList.delegate = self;
    self.askList.dataSource = self;
    
    self.bidsList.delegate = self;
    self.bidsList.dataSource = self;
    
    self.dealList.delegate = self;
    self.dealList.dataSource = self;
    self.dealList.tableFooterView = [UIView new];
    self.dealList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.sortGuideView setHidden:YES];
    [self.buyTypeView setHidden:YES];
    [self.marketPriceView setHidden:YES];
    [self.depthView setHidden:YES];
    
    UIImage *contentBgImagebubble = [UIImage imageNamed:@"xialakuang.png"];
    
    UIImage * newBgImage =[contentBgImagebubble stretchableImageWithLeftCapWidth:40 topCapHeight:40];
    NSLog(@"self.buyTypeView.frame.size = %f,%f",self.buyTypeView.frame.size.width,self.buyTypeView.frame.size.height);

    [self.buyTypeViewImage setImage:newBgImage];

    [self.buyTypeView setBackgroundColor:[UIColor clearColor]];
    [self.buyTypeView bringSubviewToFront:self.buyTypeMarketBtn];
    [self.buyTypeView bringSubviewToFront:self.buyTypeLimitBtn];
    
    
    
    [self.selectBuyTypeBtn setTitle:@"限价买入" forState:UIControlStateNormal];
    
    [self customeView];
    
    if([self.title isEqualToString:@"卖出"]){
        [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
        [self.purchaseBtn setTitle:@"卖出" forState:UIControlStateNormal];
    }else if([self.title isEqualToString:@"买入"]){
        [self.purchaseBtn setBackgroundColor:[UIColor greenColor]];
        [self.purchaseBtn setTitle:@"买入" forState:UIControlStateNormal];
    }
    
    //单选按钮
    NSArray *tiles = @[@"25%",@"50%",@"75%",@"100%"];
    self.radioBtn = [[RadioButton alloc] initWithFrame:self.editPercentContainer.bounds titles:tiles selectIndex:-1];
    [self.editPercentContainer addSubview:self.radioBtn];
    self.editPercentContainer.backgroundColor = [UIColor whiteColor];
    WeakSelf(weakSelf);
    self.radioBtn.indexChangeBlock = ^(NSInteger index){
        DLog(@"index:%li",index);
        float available = [[weakSelf.avaliableMoney.text substringFromIndex:[weakSelf.avaliableMoney.text rangeOfString:@"可用 "].length] floatValue];
        if([[weakSelf.priceRMBLabel.text substringFromIndex:1] floatValue] > 0){
            
            float willbuy = available*0.25*(index+1)/[[self.priceRMBLabel.text substringFromIndex:1] floatValue];
            float willmoney = available*0.25*(index+1);
            weakSelf.purchasePriceInput.text = [NSString stringWithFormat:@"%.3f",willmoney];
            weakSelf.purchaseAmountInput.text = [NSString stringWithFormat:@"%.4f",willbuy];
        }
    };
    
    if(kScreenWidth == 320){
//        [self.marketNamelabel.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    
    [self setSortListTitleView];
//    [self setMoneyInfo];
}

-(void)setMoneyInfo{
    NSDictionary *parameters = @{};
    
    NSString* url = @"wallet/balance";

    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            NSNumber* rest = [data objectForKey:@"ret"];
            if([rest intValue] == 1){
                NSDictionary* datainfo = [data objectForKey:@"data"];
                NSLog(@"datainfo = %@",datainfo);
                NSDictionary* exchangeinfo = [datainfo objectForKey:@"exchange"];
                
                NSArray* keys = [exchangeinfo allKeys];
                NSDictionary* money;
                for (NSString* keyinfo in keys) {
                    NSLog(@"keyinfo = %@",keyinfo);
                    NSLog(@"marketNamelabel = %@",self.marketNamelabel.titleLabel.text);
                    if([self.marketNamelabel.titleLabel.text containsString:keyinfo]){
                        money = [exchangeinfo objectForKey:keyinfo];
                    }
                }

                float available = [[money objectForKey:@"available"] floatValue];
                self.avaliableMoney.text = [NSString stringWithFormat:@"可用 %.4f",available];
                if([[self.priceRMBLabel.text substringFromIndex:1] floatValue] > 0){
                    float canbuy = available/[[self.priceRMBLabel.text substringFromIndex:1] floatValue];
                    self.canButAmount.text = [NSString stringWithFormat:@"可买 %.8f",canbuy];
                }
                
            }
        }
    }];
}

-(void)setSortListTitleView{
//    WeakSelf(weakSelf)
//    SortView *sort1 = [[SortView alloc] initWithFrame:CGRectMake(15, 0, 0, 15) title:@"股票"];
//    sort1.block = ^(BOOL isUp){
//        //TODO 数据排序，reload
//    };
//    sort1.centerY = _sortContantView.centerY;
//    [_sortContantView addSubview:sort1];
    
    SortView *sort2 = [[SortView alloc] initWithFrame:CGRectMake(0, 0, 0, 15) title:@"涨跌幅"];
    sort2.block = ^(BOOL isUp){
        //TODO 数据排序，reload
    };
    sort2.centerY = _sortContantView.centerY;
    sort2.centerX = _sortContantView.width/2;
    [_sortContantView addSubview:sort2];
    
    SortView *sort3 = [[SortView alloc] initWithFrame:CGRectMake(0, 0, 0, 15) title:@"成交量"];
    sort3.block = ^(BOOL isUp){
        //TODO 数据排序，reload
    };
    sort3.right = _sortContantView.width;
    sort3.centerY = _sortContantView.centerY;
    [_sortContantView addSubview:sort3];
}

-(void)customeView{
    self.editNumContainer.layer.borderWidth = 1;
    self.editNumContainer.layer.borderColor = [kColorRGBA(221, 221, 221, 1) CGColor];
    self.editNumContainer.layer.cornerRadius = 3;
    
    self.editPriceContainer.layer.borderWidth = 1;
    self.editPriceContainer.layer.borderColor = [kColorRGBA(221, 221, 221, 1) CGColor];
    self.editPriceContainer.layer.cornerRadius = 3;
    
    self.editPercentContainer.layer.cornerRadius = 12;//self.editNumContainer.height/2.0f;
    self.purchaseBtn.layer.cornerRadius = 15;
    
    self.ShowBuyTypeView.layer.borderWidth = 1;
    self.ShowBuyTypeView.layer.borderColor = [kColorRGBA(221, 221, 221, 1) CGColor];
    
//    self.buyTypeView.layer.borderWidth = 1;
//    self.buyTypeView.layer.borderColor = [kColorRGBA(221, 221, 221, 1) CGColor];
    
//    self.depthView.layer.borderWidth = 1;
//    self.depthView.layer.borderColor = [kColorRGBA(221, 221, 221, 1) CGColor];
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
    [[SocketInterface sharedManager] openWebSocket];

    self.askList.tableFooterView = [UIView new];
    self.bidsList.tableFooterView = [UIView new];
    
    self.askList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bidsList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [SocketInterface sharedManager].delegate = self;
    [self requestAnalysis];
    
}

-(void)getTradeInfo:(NSString*)name{
    NSArray *dicParma = @[name,
                          @(10),
                          @"0.1"
                          ];
    NSDictionary *dicAll = @{@"method":@"depth.subscribe",@"params":dicParma,@"id":@(PN_DepthSubscribe)};
    
    NSString *strAll = [dicAll JSONString];
    
    
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"depth.subscribe"];
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
                    NSLog(@"items = %@",self.infoArray);
                    
                    if(self.infoArray.count>0){
                        NSDictionary* stockinfo = self.infoArray[0];
                        [self setStcokInfo:stockinfo];
                    }
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

-(void)setStcokInfo:(NSDictionary*)info{
    
    [self.marketNamelabel setTitle:[info objectForKey:@"market"] forState:UIControlStateNormal];
    self.priceRMBLabel.text = [NSString stringWithFormat:@"¥%@",[info objectForKey:@"price"]];
    self.periodPrice.text = [NSString stringWithFormat:@"%d",[[info objectForKey:@"volume"] intValue]] ;
    self.rateLabel.text = [NSString stringWithFormat:@"%.2f%%",[[info objectForKey:@"increase"] floatValue]*100];
    
    [self getTradeInfo:[info objectForKey:@"market"]];
    [self setMoneyInfo];
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
- (IBAction)clickPurchase:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    NSString* url1 = @"account/getConfirmState";
    NSDictionary* params = @{};
    [[HttpRequest getInstance] getWithURL:url1 parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSString* state = [[data objectForKey:@"data"] objectForKey:@"state"];
                if([state isEqualToString:@"on"]){
                    
                    
                    MoneyVerifyViewController* vc = [[MoneyVerifyViewController alloc] initWithNibName:@"MoneyVerifyViewController" bundle:nil];
                    [temp presentViewController:vc animated:YES completion:nil];
                    
                    vc.block = ^(NSString* token) {
                        if(token.length>0){
                            if([self.title isEqualToString:@"买入"]){
                                [self buyStock:token];
                            }else if ([self.title isEqualToString:@"卖出"]){
                                [self sellStock:token];
                            }
                            
                        }
                    };
                    
                }else{
                    if([self.title isEqualToString:@"买入"]){
                        [self buyStock:@""];
                    }else if ([self.title isEqualToString:@"卖出"]){
                        [self sellStock:@""];
                    }
                }
            }
        }
    }];
    
    
}

-(void)buyStock:(NSString*)token{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    NSString* url = @"exchange/trade/add";
    NSDictionary* parameters = @{@"market":self.marketNamelabel.titleLabel.text,
                                 @"num":@([self.purchaseAmountInput.text floatValue]),
                                 @"price":@([self.purchasePriceInput.text floatValue]),
                                 @"mode":@"buy",
                                 @"is_limit":@(1),
                                 @"asset_token":token
                                 };
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"挂单成功"];
                
                NSString* type = self.title;
                NSString* stcokname = self.marketNamelabel.titleLabel.text;
                NSDate *currentDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
                NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
                NSString* price = self.priceRMBLabel.text;
                NSString* amount = self.purchaseAmountInput.text;
                NSString* real = self.purchasePriceInput.text;
                
                [self.dealData removeAllObjects];
                [self.dealData setObject:type forKey:@"DealType"];
                [self.dealData setObject:stcokname forKey:@"StockName"];
                [self.dealData setObject:currentDateString forKey:@"DealTime"];
                [self.dealData setObject:price forKey:@"DealPrice"];
                [self.dealData setObject:amount forKey:@"DealAmount"];
                [self.dealData setObject:real forKey:@"DealMoney"];
                
                [self setMoneyInfo];
                [self.radioBtn setSelectIndex:-1];
                self.purchaseAmountInput.text = @"000.0000";
                self.purchasePriceInput.text = @"000.000";
                
                [self.dealList reloadData];
            }
        }
    }];
}

-(void)sellStock:(NSString*)token{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    NSString* url = @"exchange/trade/add";
    NSDictionary* parameters = @{@"market":self.marketNamelabel.titleLabel.text,
                                 @"num":@([self.purchaseAmountInput.text floatValue]),
                                 @"price":@([self.purchasePriceInput.text floatValue]),
                                 @"mode":@"sell",
                                 @"is_limit":@(1),
                                 @"asset_token":token
                                 };
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"挂单成功"];
                
                NSString* type = self.title;
                NSString* stcokname = self.marketNamelabel.titleLabel.text;
                NSDate *currentDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
                NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
                NSString* price = self.priceRMBLabel.text;
                NSString* amount = self.purchaseAmountInput.text;
                NSString* real = self.purchasePriceInput.text;
                
                [self.dealData removeAllObjects];
                [self.dealData setObject:type forKey:@"DealType"];
                [self.dealData setObject:stcokname forKey:@"StockName"];
                [self.dealData setObject:currentDateString forKey:@"DealTime"];
                [self.dealData setObject:price forKey:@"DealPrice"];
                [self.dealData setObject:amount forKey:@"DealAmount"];
                [self.dealData setObject:real forKey:@"DealMoney"];
                
                [self setMoneyInfo];
                [self.radioBtn setSelectIndex:-1];
                self.purchaseAmountInput.text = @"000.0000";
                self.purchasePriceInput.text = @"000.000";
                
                [self.dealList reloadData];
            }
        }
    }];
}
- (IBAction)clickAddPruchaseAmount:(id)sender {
    float amount = [self.purchaseAmountInput.text floatValue];
    float available = [[self.canButAmount.text substringFromIndex:[self.canButAmount.text rangeOfString:@"可买 "].length] floatValue];
    amount++;
    if(amount>available){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"超出所能购买的最多数目了"];
    }else{
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.4f",amount];
        float price = amount*([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.3f",price];
    }
    
}
- (IBAction)clickAReducePruchaseAmount:(id)sender {
    float amount = [self.purchaseAmountInput.text floatValue];
    amount--;
    if(amount<0){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"数目不可小于0"];
    }else{
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.4f",amount];
        float price = amount*([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.3f",price];
    }
    
}
- (IBAction)clickReducePruchasePrice:(id)sender {
    float price = [self.purchasePriceInput.text floatValue];
    price--;
    if(price<0){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"购买总价不可低于0"];
    }else{
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.3f",price];
        float amount = price/([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.4f",amount];
    }
    
}
- (IBAction)clickAddPruchasePrice:(id)sender {
    float price = [self.purchasePriceInput.text floatValue];
    float available = [[self.avaliableMoney.text substringFromIndex:[self.avaliableMoney.text rangeOfString:@"可用 "].length] floatValue];
    price++;
    if(price>available){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"购买总价不可高于总余额"];
    }else{
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.3f",price];
        float amount = price/([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.4f",amount];
    }
    
}
- (IBAction)clickCancel:(id)sender {
    
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
//    int requestID = [[data objectForKey:@"id"] intValue];
    if([name isEqualToString:@"depth.update"]){
        
        NSArray* params = [data objectForKey:@"params"];
        
        if(params.count == 3){
            NSDictionary* result =params[1];
//            NSLog(@"数据详情:%@",result);
            NSArray* ask = [result objectForKey:@"asks"];
            NSArray* bid = [result objectForKey:@"bids"];
            
            if(ask.count>0){
                [self.asksArray removeAllObjects];
                self.asksArray = [[NSMutableArray alloc] initWithArray:ask];
                [self.askList reloadData];
            }
            
            if(bid.count>0){
                [self.bidsArray removeAllObjects];
                self.bidsArray = [[NSMutableArray alloc] initWithArray:bid];
                [self.bidsList reloadData];
            }
        }
        
        
    }
}
#pragma mark - Cancel Delegate

-(void)sendCancelNotice{
    [self.dealData removeAllObjects];
    [self.dealList reloadData];
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
    
    if(tableView == self.askList){
        return self.asksArray.count;
    }
    if(tableView == self.bidsList){
        return self.bidsArray.count;
    }
    
    if(tableView == self.dealList){
        if(self.dealData.count>0){
            return 1;
        }else{
            return 0;
        }
        
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
    
    if(tableView == self.dealList){
        return 105;
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
        
        
        NSMutableArray* info = self.asksArray[indexPath.row];
        if(info.count==2){
            cell.price.text = [NSString stringWithFormat:@"%.4f",[info[1] floatValue]] ;
            cell.amount.text = [NSString stringWithFormat:@"%.3f",[info[0] floatValue]];
        }
        cell.price.textColor = [UIColor colorWithRed:236/255.0 green:102/255.0 blue:95/255.0 alpha:1];
        return cell;
    }
    
    if(tableView == self.bidsList){
        askAndBidsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"askAndBidsTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        NSMutableArray* info = self.bidsArray[indexPath.row];
        if(info.count==2){
            cell.price.text = [NSString stringWithFormat:@"%.4f",[info[1] floatValue]] ;
            cell.amount.text = [NSString stringWithFormat:@"%.3f",[info[0] floatValue]];
        }
        
        cell.price.textColor = [UIColor colorWithRed:51/255.0 green:143/255.0 blue:71/255.0 alpha:1];
        
        return cell;
    }
    
    if(tableView == self.dealList){
        PendingOrderTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PendingOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            cell.delegate = self;
        }
        
        
        cell.typeLabel.text = [self.dealData objectForKey:@"DealType"];
        
        if([self.title isEqualToString:@"买入"]){
            cell.isBuyIn = YES;
        }else if([self.title isEqualToString:@"卖出"]){
            cell.isBuyIn = NO;
        }
        
        cell.stockName.text = [self.dealData objectForKey:@"StockName"];
        cell.timeLabel.text = [self.dealData objectForKey:@"DealTime"];
        cell.priceLabel.text = [self.dealData objectForKey:@"DealPrice"];
        cell.amountLabel.text = [self.dealData objectForKey:@"DealAmount"];
        cell.realLabel.text = [self.dealData objectForKey:@"DealMoney"];
        
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
        
        [self setStcokInfo:self.infoArray[indexPath.row]];
        
        
    }
    
    if(tableView == self.askList || tableView == self.bidsList){
        askAndBidsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        self.purchasePriceLabel.text = cell.price.text;
        self.purchaseAmountLabel.text = cell.amount.text;
        
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
