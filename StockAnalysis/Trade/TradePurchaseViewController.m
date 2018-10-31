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
#import "StockLittleViewController.h"
#import "ChargeViewController.h"
#import "ChargeAddressViewController.h"
#import "LoginViewController.h"
@interface TradePurchaseViewController ()<SocketDelegate,UITableViewDelegate,UITableViewDataSource,CancelDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
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
@property (nonatomic,strong)NSMutableArray* dealArray;
@property (weak, nonatomic) IBOutlet UITableView *dealList;

@property (weak, nonatomic) IBOutlet UIImageView *enterKLine;
@property (nonatomic,strong)NSMutableDictionary* dealData;

@property (nonatomic)BOOL firstOpen;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL isUpdate;

@property (nonatomic,assign)NSInteger assetSelectIndex;

@property (nonatomic,assign)NSInteger numberDepth;

@property(nonatomic,assign)BOOL isGetPrice;

@end



@implementation TradePurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleArray = [NSMutableArray new];
    self.infoArray = [NSMutableArray new];
   
    self.asksArray = [NSMutableArray new];
    self.bidsArray = [NSMutableArray new];
    self.dealArray = [NSMutableArray new];
    
    self.dealData = [NSMutableDictionary new];
    self.isUpdate = YES;
    self.currentPage = 0;
    self.assetSelectIndex = 0;
    self.numberDepth = 4;
    
    _tradeName = @"";
    _isGetPrice = NO;
    
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
//    self.dealList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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

    [self customeView];
    
    if([self.title isEqualToString:@"卖出"]){
        [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
        [self.purchaseBtn setTitle:@"卖出" forState:UIControlStateNormal];
        [self.selectBuyTypeBtn setTitle:@"限价卖出" forState:UIControlStateNormal];
        [self.buyTypeMarketBtn setTitle:@"市价快速卖出" forState:UIControlStateNormal];
        [self.buyTypeLimitBtn setTitle:@"限价卖出" forState:UIControlStateNormal];
    }else if([self.title isEqualToString:@"买入"]){
        [self.purchaseBtn setBackgroundColor:kColor(80, 184, 115)];
        [self.purchaseBtn setTitle:@"买入" forState:UIControlStateNormal];
        [self.selectBuyTypeBtn setTitle:@"限价买入" forState:UIControlStateNormal];
        [self.buyTypeMarketBtn setTitle:@"市价快速买入" forState:UIControlStateNormal];
        [self.buyTypeLimitBtn setTitle:@"限价买入" forState:UIControlStateNormal];
    }
    
    //单选按钮
    NSArray *tiles = @[@"25%",@"50%",@"75%",@"100%"];
    self.radioBtn = [[RadioButton alloc] initWithFrame:self.editPercentContainer.bounds titles:tiles selectIndex:-1];
    [self.editPercentContainer addSubview:self.radioBtn];
    self.editPercentContainer.backgroundColor = [UIColor whiteColor];
    WeakSelf(weakSelf);
    self.radioBtn.indexChangeBlock = ^(NSInteger index){
//        DLog(@"index:%li",index);
        float available = [[weakSelf.avaliableMoney.text substringFromIndex:[weakSelf.avaliableMoney.text rangeOfString:@"可用 "].length] floatValue];
        if([[weakSelf.priceRMBLabel.text substringFromIndex:1] floatValue] > 0){
            
            float willbuy = available*0.25*(index+1)/[[self.priceRMBLabel.text substringFromIndex:1] floatValue];
            float willmoney = available*0.25*(index+1);
           
            weakSelf.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",willmoney];
            weakSelf.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8f",willbuy];
        }
    };
    
    [self.radioBtn setSelectIndex:0];
    
    if(kScreenWidth == 320){
//        [self.marketNamelabel.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    
    [self setSortListTitleView];
//    [self setMoneyInfo];
 
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    f.delegate = self;
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    self.purchasePriceInput.delegate = self;
    self.purchaseAmountInput.delegate = self;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


-(void)test{
    [self.view endEditing:YES];
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    if(textView == self.purchasePriceInput){
        float price = [self.purchasePriceInput.text floatValue];
        float available = [[self.avaliableMoney.text substringFromIndex:[self.avaliableMoney.text rangeOfString:@"可用 "].length] floatValue];
        
        if(price>available){
            [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"购买总价不可高于总余额"];
        }else{
            self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
            float amount = price/([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
            self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8f",amount];
        }
    }else if (textView == self.purchaseAmountInput){
        float amount = [self.purchaseAmountInput.text floatValue];
        
        if(amount<0){
            [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"数目不可小于0"];
        }else{
            self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8f",amount];
            float price = amount*([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
            self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
        }
    }
}

-(void)setMoneyInfo{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSDictionary *parameters = @{};
    
    NSString* url = @"wallet/balance";

    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            NSNumber* rest = [data objectForKey:@"ret"];
            if([rest intValue] == 1){
                NSDictionary* datainfo = [data objectForKey:@"data"];
//                NSLog(@"datainfo = %@",datainfo);
                NSDictionary* exchangeinfo = [datainfo objectForKey:@"exchange"];
                
                NSArray* keys = [exchangeinfo allKeys];
                NSDictionary* money;
                for (NSString* keyinfo in keys) {
//                    NSLog(@"keyinfo = %@",keyinfo);
//                    NSLog(@"marketNamelabel = %@",self.marketNamelabel.titleLabel.text);
                    if([self.marketNamelabel.titleLabel.text containsString:keyinfo]){
                        
                        if([self.title isEqualToString:@"卖出"]){
                            if([self.marketNamelabel.titleLabel.text rangeOfString:keyinfo].location == 0){
                                money = [exchangeinfo objectForKey:keyinfo];
                            }
                        }else{
                            if([self.marketNamelabel.titleLabel.text rangeOfString:keyinfo].location+[self.marketNamelabel.titleLabel.text rangeOfString:keyinfo].length == self.marketNamelabel.titleLabel.text.length){
                                money = [exchangeinfo objectForKey:keyinfo];
                            }
                        }
                    }
                }
//                NSLog(@"money = %@",money);
                float available = [[money objectForKey:@"available"] floatValue];
                self.avaliableMoney.text = [NSString stringWithFormat:@"可用 %.4f",available];
                if([[self.priceRMBLabel.text substringFromIndex:1] floatValue] > 0){
                    float canbuy = available/[[self.priceRMBLabel.text substringFromIndex:1] floatValue];
                    self.canButAmount.text = [NSString stringWithFormat:@"可买 %.8f",canbuy];
                }
                
                if([self.title isEqualToString:@"卖出"]){
                    
                    if(available <= 0){
                        [self.purchaseBtn setBackgroundColor:[UIColor grayColor]];
                        [self.purchaseBtn setEnabled:NO];
                    }else{
                        [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
                        [self.purchaseBtn setEnabled:YES];
                    }
                }else if([self.title isEqualToString:@"买入"]){
                    
                    if(available <= 0){
                        [self.purchaseBtn setBackgroundColor:[UIColor grayColor]];
                        [self.purchaseBtn setEnabled:NO];
                    }else{
                        [self.purchaseBtn setBackgroundColor:kColor(80, 184, 115)];
                        [self.purchaseBtn setEnabled:YES];
                    }
                }
                
                if(_firstOpen){
                    [self.radioBtn setSelectIndex:0];
                    _firstOpen = NO;
                }else{
                    [self.radioBtn setSelectIndex:[self.radioBtn getSelectIndex]];
                }
                
            }else{
                
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                
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
    [sort2 setTitleWithFont:12 withColor:kColor(136, 136, 136)];
    sort2.block = ^(BOOL isUp){
        //TODO 数据排序，reload
    };
    sort2.centerY = _sortContantView.centerY-5;
    sort2.centerX = _sortContantView.width/2;
    [_sortContantView addSubview:sort2];
    
    SortView *sort3 = [[SortView alloc] initWithFrame:CGRectMake(0, 0, 0, 15) title:@"成交量"];
    [sort3 setTitleWithFont:12 withColor:kColor(136, 136, 136)];
    sort3.block = ^(BOOL isUp){
        //TODO 数据排序，reload
    };
    sort3.right = _sortContantView.width;
    sort3.centerY = _sortContantView.centerY-5;
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
    self.tabBarController.tabBar.hidden = YES;
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
//        [HUDUtil showSystemTipView:temp title:@"提示" withContent:@"未登录,请先登录"];
//        return;
    }
    
//    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
//
//    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
//    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
//    if(!islogin){
//        SCAlertController *alert = [SCAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:  UIAlertControllerStyleAlert];
//        alert.messageColor = kColor(136, 136, 136);
//
//        //退出
//        SCAlertAction *exitAction = [SCAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //登录
//            LoginViewController* vc = [[LoginViewController alloc ] initWithNibName:@"LoginViewController" bundle:nil];
//            [temp pushViewController:vc animated:YES];
//        }];
//        //单独修改一个按钮的颜色
//        exitAction.textColor = kColor(243, 186, 46);
//        [alert addAction:exitAction];
//
//        [temp presentViewController:alert animated:YES completion:nil];
//    }
    
    
  
    
    _isGetPrice = NO;
    _assetSelectIndex = 0;
    
     self.firstOpen = YES;
    NSLog(@"title = %@",self.title);
    if([self.title isEqualToString:@"卖出"]){
        [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
    }else if([self.title isEqualToString:@"买入"]){
        [self.purchaseBtn setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:185.0/255.0 blue:112.0/255.0 alpha:1.0]];
    }
    
    [SocketInterface sharedManager].delegate = self;
    [[SocketInterface sharedManager] openWebSocket];

    self.askList.tableFooterView = [UIView new];
    self.bidsList.tableFooterView = [UIView new];
    
    self.askList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bidsList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.dealArray removeAllObjects];
    [self requestAnalysis];
    
    [self.enterKLine setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.enterKLine addGestureRecognizer:singleTap];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
    //
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
//    [[SocketInterface sharedManager] closeWebSocket];
    _isGetPrice = NO;
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSString* name = self.marketNamelabel.titleLabel.text;
    StockLittleViewController* vc = [[StockLittleViewController alloc] initWithNibName:@"StockLittleViewController" bundle:nil];
    vc.title = name;
    [temp pushViewController:vc animated:YES];
}

-(void)setTradeName:(NSString *)tradeName{
    _tradeName = tradeName;
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }

    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
//        [HUDUtil showSystemTipView:temp title:@"提示" withContent:@"未登录,请先登录"];
        return;
    }
    
//    [self.marketNamelabel setTitle:_tradeName forState:UIControlStateNormal];
//    //        self.marketNamelabel.titleLabel.text = cell.name.text;
//
//    [self getPendingOrders];
//
//    [self.sortGuideView setHidden:YES];
//
    self.isUpdate = YES;
    self.currentPage = 0;
    _firstOpen = NO;
    _assetSelectIndex = 0;
    [self.marketNamelabel setTitle:_tradeName forState:UIControlStateNormal];
    [self getPendingOrders:1];
    
    [self requestSubscribe];
    
    [self getTradeInfo:_tradeName];
    
//    NSDictionary* parameters = @{@"order_by":@"price",
//                                 @"order":@"desc",
//                                 @"asset":_tradeName
//                                 };
//    NSString* url = @"market/item";
//
//    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
//        if(success){
//            if([[data objectForKey:@"ret"] intValue] == 1){
//                self.infoArray = [[data objectForKey:@"data"] objectForKey:@"items"];
//                if(self.infoArray){
//                    NSLog(@"items = %@",self.infoArray);
//
//                    if(self.infoArray.count>0){
//                        NSDictionary* stockinfo = self.infoArray[0];
//                        [self setStcokInfo:stockinfo];
//                    }
//                    [self.stcokInfoView reloadData];
//
//                    NSInteger selectedIndex1 = 0;
//                    NSIndexPath *selectedIndexPath1 = [NSIndexPath indexPathForRow:selectedIndex1 inSection:0];
//                    [self.stcokInfoView selectRowAtIndexPath:selectedIndexPath1 animated:NO scrollPosition:UITableViewScrollPositionNone];
//
//
//                    [self.marketNamelabel setTitle:_tradeName forState:UIControlStateNormal];
//                }
//            }else{
//
//                [HUDUtil showHudViewInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
//
//            }
//        }
//    }];
}

-(void)getTradeInfo:(NSString*)name{
    NSArray *dicParma = @[name
//                          @(10),
//                          @"0.1"
                          ];
    NSDictionary *dicAll = @{@"method":@"deals.subscribe",@"params":dicParma,@"id":@(PN_DepthSubscribe)};
    
    NSString *strAll = [dicAll JSONString];
    
    
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"deals.subscribe"];
}

-(void)requestAnalysis{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSDictionary* parameters = @{};
    NSString* url = @"market/assortment";
    [self.titleArray removeAllObjects];
    [self.titleArray addObject:@"自选"];
    [HUDUtil showHudViewInSuperView:temp.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
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
                    
                    NSInteger selectedIndex = self.assetSelectIndex;
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                    [self.stcokSelectView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
              
                    if(_firstOpen){
                        [self getSelectInfo];
                    }

                }
            }else{
                [HUDUtil showHudViewInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
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

-(void)getSelectInfo{
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(islogin){
        NSDictionary* parameters = @{@"page":@(1),
                                     @"page_limit":@(10),
                                     @"order_by":@"price",
                                     @"order":@"desc"
                                     };
        NSString* url = @"market/follow/list";
        
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            
            if(success){
                [HUDUtil hideHudView];
                //            NSLog(@"list = %@",data);
                if([[data objectForKey:@"ret"] intValue] == 1){
                    NSArray* items = [[data objectForKey:@"data"] objectForKey:@"items"];
                    
                    if(_firstOpen){
                        if(items.count>0){
                            [self.infoArray removeAllObjects];
                            [self.infoArray addObjectsFromArray:items];
                            if(self.infoArray.count>0){
                                NSDictionary* stockinfo = self.infoArray[0];
                                [self setStcokInfo:stockinfo];
                            }
                            [self.stcokInfoView reloadData];
                            self.assetSelectIndex = 0;
                            NSInteger selectedIndex = 0;
                            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                            [self.stcokSelectView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

                            NSInteger selectedIndex1 = 0;
                            NSIndexPath *selectedIndexPath1 = [NSIndexPath indexPathForRow:selectedIndex1 inSection:0];
                            [self.stcokInfoView selectRowAtIndexPath:selectedIndexPath1 animated:NO scrollPosition:UITableViewScrollPositionNone];
                            
                            [self.radioBtn setSelectIndex:0];
                            
                            self.currentPage = 0;
                            self.isUpdate = YES;
                            [self getPendingOrders:1];
                            
                            if(self.block){
                                self.block();
                            }
                            
                        }else{
                            [self setOpenSelect];
                            
                        }
                        
                        
                    }else{
                        [self.infoArray removeAllObjects];
                        [self.infoArray addObjectsFromArray:items];
                        if(self.infoArray){
                            [self.stcokInfoView reloadData];
                        }
                        self.assetSelectIndex = 0;
                    }
                    
                    
                }else{
                    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
                    if(nil == temp){
                        temp = self.navigationController;
                    }
                    [HUDUtil showHudViewTipInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                    
                }
            }
        }];
    }else{
        if(_firstOpen){
            [self setOpenSelect];
            
        }
    }
    
    
}

-(void)setOpenSelect{
    NSInteger selectedIndex = 1;
    self.assetSelectIndex = 1;
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
                    
                    TradeStockInfoTableViewCell* cell1 = [self.stcokInfoView cellForRowAtIndexPath:selectedIndexPath1];
                    
                    [self.marketNamelabel setTitle:cell1.name.text forState:UIControlStateNormal];
                    
                    self.currentPage = 0;
                    self.isUpdate = YES;
                    [self getPendingOrders:1];
                    
                    [self.radioBtn setSelectIndex:0];
                    
                    if(self.block){
                        self.block();
                    }
                }
            }else{
                UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
                if(nil == temp){
                    temp = self.navigationController;
                }
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
}

-(void)setStcokInfo:(NSDictionary*)info{
    
    [self.marketNamelabel setTitle:[info objectForKey:@"market"] forState:UIControlStateNormal];
    
    [self requestSubscribe];
    
    [self getTradeInfo:[info objectForKey:@"market"]];
    
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
    if(self.sortGuideView.isHidden){
        [self.sortGuideView setHidden:NO];
        
        [self requestAnalysis];
    }else{
        [self.sortGuideView setHidden:YES];
    }
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
    _numberDepth = 4;
}
- (IBAction)clickOne:(id)sender {
    [self.depthView setHidden:YES];
    _numberDepth = 1;
}
- (IBAction)clickZero:(id)sender {
    [self.depthView setHidden:YES];
    _numberDepth = 0;
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
    if(nil == temp){
        temp = self.navigationController;
    }
    NSString* url1 = @"account/getConfirmState";
    NSDictionary* params = @{};
    [HUDUtil showHudViewInSuperView:temp.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] getWithURL:url1 parma:params block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSString* state = [[data objectForKey:@"data"] objectForKey:@"state"];
                if([state isEqualToString:@"on"]){
                    
                    
                    MoneyVerifyViewController* vc = [[MoneyVerifyViewController alloc] initWithNibName:@"MoneyVerifyViewController" bundle:nil];
                    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    temp.definesPresentationContext = YES;
                    [temp presentViewController:vc animated:YES completion:nil];
                    
                    vc.block = ^(NSString* token) {
                        if(token.length>0){
                            if([self.title isEqualToString:@"买入"]){
                                [self buyStock:token];
                            }else if ([self.title isEqualToString:@"卖出"]){
                                [self sellStock:token];
                            }
                        }else{
                            [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"资金密码验证错误"];
                        }
                    };
                    
                }else{
                    
                    [self.purchaseBtn setBackgroundColor:[UIColor grayColor]];
                    [self.purchaseBtn setEnabled:NO];
                    
                    if([self.title isEqualToString:@"买入"]){
                        [self buyStock:@""];
                    }else if ([self.title isEqualToString:@"卖出"]){
                        [self sellStock:@""];
                    }
                }
            }else{
                [HUDUtil showHudViewInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
    
    
}

-(void)buyStock:(NSString*)token{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSString* url = @"exchange/trade/add";
    float price = [self.priceRMBLabel.text floatValue];
    NSInteger limit = 1;
    if(!self.marketPriceView.isHidden){
        price = [self.marketPriceLabel.text floatValue];
        limit = 0;
    }
    NSDictionary* parameters = @{@"market":self.marketNamelabel.titleLabel.text,
                                 @"num":@([self.purchaseAmountInput.text floatValue]),
                                 @"price":@(price),
                                 @"mode":@"buy",
                                 @"is_limit":@(limit),
                                 @"asset_token":token
                                 };
    [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if([self.title isEqualToString:@"卖出"]){
            
            [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
            [self.purchaseBtn setEnabled:YES];
        }else if([self.title isEqualToString:@"买入"]){
            
            [self.purchaseBtn setBackgroundColor:kColor(80, 184, 115)];
            [self.purchaseBtn setEnabled:YES];
        }
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"挂单成功"];
    
//                NSString* type = self.title;
//                NSString* stcokname = self.marketNamelabel.titleLabel.text;
//                NSDate *currentDate = [NSDate date];
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
//                NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
//                NSString* price = self.priceRMBLabel.text;
//                NSString* amount = self.purchaseAmountInput.text;
//                NSString* real = self.purchasePriceInput.text;
                
//                [self.dealData removeAllObjects];
//                [self.dealData setObject:type forKey:@"DealType"];
//                [self.dealData setObject:stcokname forKey:@"StockName"];
//                [self.dealData setObject:currentDateString forKey:@"DealTime"];
//                [self.dealData setObject:price forKey:@"DealPrice"];
//                [self.dealData setObject:amount forKey:@"DealAmount"];
//                [self.dealData setObject:real forKey:@"DealMoney"];

                [self setMoneyInfo];
//                [self.radioBtn setSelectIndex:-1];
//                self.purchaseAmountInput.text = @"000.0000";
//                self.purchasePriceInput.text = @"000.000";
                
                self.currentPage = 0;
                self.isUpdate = YES;
                [self getPendingOrders:1];
                
//                [self.dealList reloadData];
            }else{
                
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
}

-(void)sellStock:(NSString*)token{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    
    float price = [self.marketPriceLabel.text floatValue];
    NSInteger limit = 1;
    if(!self.marketPriceView.isHidden){
        price = [self.marketPriceLabel.text floatValue];
        limit = 0;
    }
    
    NSString* url = @"exchange/trade/add";
    NSDictionary* parameters = @{@"market":self.marketNamelabel.titleLabel.text,
                                 @"num":@([self.purchaseAmountInput.text floatValue]),
                                 @"price":@(price),
                                 @"mode":@"sell",
                                 @"is_limit":@(limit),
                                 @"asset_token":token
                                 };
    [HUDUtil showHudViewInSuperView:temp.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if([self.title isEqualToString:@"卖出"]){
            
            [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
            [self.purchaseBtn setEnabled:YES];
        }else if([self.title isEqualToString:@"买入"]){
            
            [self.purchaseBtn setBackgroundColor:kColor(80, 184, 115)];
            [self.purchaseBtn setEnabled:YES];
        }
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"挂单成功"];
                
//                NSString* type = self.title;
//                NSString* stcokname = self.marketNamelabel.titleLabel.text;
//                NSDate *currentDate = [NSDate date];
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
//                NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
//                NSString* price = self.priceRMBLabel.text;
//                NSString* amount = self.purchaseAmountInput.text;
//                NSString* real = self.purchasePriceInput.text;
                
//                [self.dealData removeAllObjects];
//                [self.dealData setObject:type forKey:@"DealType"];
//                [self.dealData setObject:stcokname forKey:@"StockName"];
//                [self.dealData setObject:currentDateString forKey:@"DealTime"];
//                [self.dealData setObject:price forKey:@"DealPrice"];
//                [self.dealData setObject:amount forKey:@"DealAmount"];
//                [self.dealData setObject:real forKey:@"DealMoney"];
                
                [self setMoneyInfo];
//                [self.radioBtn setSelectIndex:-1];
//                self.purchaseAmountInput.text = @"000.0000";
//                self.purchasePriceInput.text = @"000.000";
                
                self.currentPage = 0;
                self.isUpdate = YES;
                [self getPendingOrders:1];
//                [self.dealList reloadData];
            }else{
                
                [HUDUtil showHudViewInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
}
- (IBAction)clickAddPruchaseAmount:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    float amount = [self.purchaseAmountInput.text floatValue];
    float available = [[self.canButAmount.text substringFromIndex:[self.canButAmount.text rangeOfString:@"可买 "].length] floatValue];
    amount++;
    if(amount>available){
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"超出所能购买的最多数目了"];
    }else{
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8f",amount];
        float price = amount*([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
    }
    
}
- (IBAction)clickAReducePruchaseAmount:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    float amount = [self.purchaseAmountInput.text floatValue];
    amount--;
    if(amount<0){
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"数目不可小于0"];
    }else{
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8f",amount];
        float price = amount*([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
    }
    
}
- (IBAction)clickReducePruchasePrice:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    float price = [self.purchasePriceInput.text floatValue];
    price--;
    if(price<0){
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"购买总价不可低于0"];
    }else{
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
        
        float amount = price/([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8f",amount];
    }
    
}
- (IBAction)clickAddPruchasePrice:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    float price = [self.purchasePriceInput.text floatValue];
    float available = [[self.avaliableMoney.text substringFromIndex:[self.avaliableMoney.text rangeOfString:@"可用 "].length] floatValue];
    price++;
    if(price>available){
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"购买总价不可高于总余额"];
    }else{
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
        float amount = price/([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8f",amount];
    }
    
}
- (IBAction)clickCancel:(id)sender {
    
}
- (IBAction)clickChargeBtn:(id)sender {
    
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSDictionary *parameters = @{};
    
    NSString* url = @"wallet/balance";
    
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            NSNumber* rest = [data objectForKey:@"ret"];
            if([rest intValue] == 1){
                NSString* market = @"";
                NSDictionary* datainfo = [data objectForKey:@"data"];
                NSLog(@"datainfo = %@",datainfo);
                NSDictionary* exchangeinfo = [datainfo objectForKey:@"exchange"];
                
                NSArray* keys = [exchangeinfo allKeys];

                for (NSString* keyinfo in keys) {
                    NSLog(@"keyinfo = %@",keyinfo);
                    NSLog(@"marketNamelabel = %@",self.marketNamelabel.titleLabel.text);
                    if([self.marketNamelabel.titleLabel.text containsString:keyinfo]){
                        market = keyinfo;
                    }
                }
                
                ChargeAddressViewController *vc = [[ChargeAddressViewController alloc] initWithNibName:@"ChargeAddressViewController" bundle:nil];
                
                [[AppData getInstance] setAssetName:market];
                if(self.navigationController){
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [temp pushViewController:vc animated:YES];
                }
                
                
            }else{
                
                [HUDUtil showHudViewInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
    
    
}

-(void)getPendingOrders:(NSInteger)page{
    if(page == 1){
        [self.dealArray removeAllObjects];
    }
    self.currentPage = page;
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSString* mode = @"buy";
    if([self.title isEqualToString:@"买入"]){
        mode = @"buy";
    }else if ([self.title isEqualToString:@"卖出"]){
        mode = @"sell";
    }
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"market":self.marketNamelabel.titleLabel.text,
                             @"page":@(page),
                             @"page_limit":@(5),
                             @"mode":mode,
                             @"state":@"pending"
                             };
    
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
//        [HUDUtil hideHudView];
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* trades = [[data objectForKey:@"data"] objectForKey:@"trades"];
//                [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"已经全部加载完毕"];
                if(trades.count == 0){
                    self.isUpdate = NO;
                    [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"全部加载完毕"];
                }else{
                    [self.dealArray addObjectsFromArray:trades];
                    [self.dealList reloadData];
                }
                
                
            }else{
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}
-(void)requestSubscribe{
    NSDictionary *dicAll1 = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
    //
    NSString *strAll1 = [dicAll1 JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll1 withName:@"state.unsubscribe"];
    
    NSArray *dicParma = @[self.marketNamelabel.titleLabel.text
                          ];

    
    NSDictionary *dicAll = @{@"method":@"state.subscribe",@"params":dicParma,@"id":@(PN_StateSubscribe)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.subscribe"];
    
 
    
}
#pragma mark ---------SocketDalegate------------
-(void)getWebData:(id)message withName:(NSString *)name{
//    [HUDUtil hideHudView];
    NSString* str = message;
    NSData* strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
    
    NSNull* err =[data objectForKey:@"error"];
    
    if(err){
//        NSLog(@"err = %@",err);
    }
//    int requestID = [[data objectForKey:@"id"] intValue];
    if([name isEqualToString:@"deals.update"]){
        
        NSArray* params = [data objectForKey:@"params"];
        
        if(params.count == 2){
            NSArray* result =params[1];
//            NSLog(@"数据详情:%ld",result.count);
            
            NSMutableArray* buy = [NSMutableArray new];
            NSMutableArray* sell = [NSMutableArray new];
            
            for (NSDictionary* info in result) {
                if([[info objectForKey:@"type"] isEqualToString:@"buy"]){
                    [buy addObject:info];
                }else if ([[info objectForKey:@"type"] isEqualToString:@"sell"]){
                    [sell addObject:info];
                }
            }
            
            
//            NSArray* ask = [result objectForKey:@"asks"];
//            NSArray* bid = [result objectForKey:@"bids"];
//
            if(sell.count>0){
                [self.asksArray removeAllObjects];
                self.asksArray = [[NSMutableArray alloc] initWithArray:sell];
                [self.askList reloadData];
            }

            if(buy.count>0){
                [self.bidsArray removeAllObjects];
                self.bidsArray = [[NSMutableArray alloc] initWithArray:buy];
                [self.bidsList reloadData];
            }
        }
        
        
    }else if ([name isEqualToString:@"state.update"]){
        NSArray* params = [data objectForKey:@"params"];
        if(params.count == 2){
            NSDictionary* info = params[1];
            //            NSLog(@"info = %@",info);
            self.priceRMBLabel.text = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"last"] floatValue]];

            float price = [[info objectForKey:@"open"] floatValue];
            float nowprice = [[info objectForKey:@"last"] floatValue];
            
            float rate = (float)((float)(nowprice-price)/(float)price)*100;
//            NSLog(@"price = %f,nowprice = %f,rate = %f",price,nowprice,rate);
            if(rate>0){
                [self.rateLabel setTextColor:kSoldOutRed];
            }else{
                [self.rateLabel setTextColor:kColor(51, 147, 71)];
            }
            self.rateLabel.text = [NSString stringWithFormat:@"%.2f%%",rate];

            
            self.marketPriceLabel.text = [NSString stringWithFormat:@"¥%@",[info objectForKey:@"last"]];
            
            if(!_isGetPrice){
                _isGetPrice = YES;
                self.periodPrice.text =[NSString stringWithFormat:@"%.4f",[[info objectForKey:@"open"] floatValue]];
                NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
                if(islogin){
                    [self setMoneyInfo];
                }
            }
            
            
            
        }
    }
}
#pragma mark - Cancel Delegate

-(void)sendCancelNotice:(BOOL)success withReason:(NSString *)msg{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    if(success){
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"撤销成功"];
        self.isUpdate = YES;
        self.currentPage = 0;
        [self getPendingOrders:1];
        [self.dealList reloadData];
    }else{
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:msg];
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
    
    if(tableView == self.askList){
        return self.asksArray.count;
    }
    if(tableView == self.bidsList){
        return self.bidsArray.count;
    }
    
    if(tableView == self.dealList){
//        if(self.dealData.count>0){
//            return 1;
//        }else{
//            return 0;
//        }
        return self.dealArray.count;
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
            cell = [[NSBundle mainBundle] loadNibNamed:@"TradeStockSelectTableViewCell" owner:self options:nil].firstObject;
        }
        if(self.titleArray.count>indexPath.row){
            NSString* titletext = self.titleArray[indexPath.row];
            NSLog(@"titletext = %@",titletext);
            cell.name.text = titletext;
        }
        
        return cell;
    }
    
    if(tableView == self.stcokInfoView){
        TradeStockInfoTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"TradeStockInfoTableViewCell" owner:self options:nil].firstObject;
        }
        if(self.infoArray.count>indexPath.row){
            NSDictionary* info = self.infoArray[indexPath.row];
            
            NSString* name = [info objectForKey:@"market"];
            NSString* rate = [NSString stringWithFormat:@"%.2f%%",[[info objectForKey:@"increase"] floatValue]*100];
            NSString* volume = [NSString stringWithFormat:@"%.0f",[[info objectForKey:@"volume"] floatValue]];
            
            cell.name.text = name;
            cell.upRate.text = rate;
            cell.volume.text = volume;
        }
        
        
        return cell;
    }
    
    if(tableView == self.askList){
        askAndBidsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"askAndBidsTableViewCell" owner:self options:nil].firstObject;
        }
        
        if(self.asksArray.count>indexPath.row){
            NSDictionary* info = self.asksArray[indexPath.row];
            if(_numberDepth == 4){
                cell.price.text = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"price"] floatValue]] ;
            }else if (_numberDepth == 1){
                cell.price.text = [NSString stringWithFormat:@"%.1f000",[[info objectForKey:@"price"] floatValue]] ;
            }else if (_numberDepth == 0){
                cell.price.text = [NSString stringWithFormat:@"%.f0000",[[info objectForKey:@"price"] floatValue]] ;
            }
            
            cell.amount.text = [NSString stringWithFormat:@"%.3f",[[info objectForKey:@"amount"] floatValue]];
            cell.price.textColor = [UIColor colorWithRed:236/255.0 green:102/255.0 blue:95/255.0 alpha:1];
        }
        
        return cell;
    }
    
    if(tableView == self.bidsList){
        askAndBidsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"askAndBidsTableViewCell" owner:self options:nil].firstObject;
        }
        if(self.bidsArray.count>indexPath.row){
            NSDictionary* info = self.bidsArray[indexPath.row];
            if(_numberDepth == 4){
                cell.price.text = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"price"] floatValue]] ;
            }else if (_numberDepth == 1){
                cell.price.text = [NSString stringWithFormat:@"%.1f000",[[info objectForKey:@"price"] floatValue]] ;
            }else if (_numberDepth == 0){
                cell.price.text = [NSString stringWithFormat:@"%.f0000",[[info objectForKey:@"price"] floatValue]] ;
            }
            
            cell.amount.text = [NSString stringWithFormat:@"%.3f",[[info objectForKey:@"amount"] floatValue]];
            
            cell.price.textColor = [UIColor colorWithRed:51/255.0 green:143/255.0 blue:71/255.0 alpha:1];
        }
        
        
        return cell;
    }
    
    if(tableView == self.dealList){
        PendingOrderTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"PendingOrderTableViewCell" owner:self options:nil].firstObject;
            
            cell.delegate = self;
        }
        if(self.dealArray.count>indexPath.row){
            NSDictionary* info = self.dealArray[indexPath.row];
            cell.typeLabel.text = [info objectForKey:@"mode"];
            cell.stockName.text = [info objectForKey:@"market"];
            cell.timeLabel.text = [info objectForKey:@"updated_at"];
            cell.priceLabel.text = [info objectForKey:@"price"];
            cell.amountLabel.text = [info objectForKey:@"num"];
            cell.realLabel.text = [info objectForKey:@"deal_money"];
            //        cell.typeLabel.text = [self.dealData objectForKey:@"DealType"];
            cell.tradeID = [info objectForKey:@"id"];
            
            if([cell.typeLabel.text isEqualToString:@"buy"]){
                cell.isBuyIn = YES;
            }else if([cell.typeLabel.text isEqualToString:@"sell"]){
                cell.isBuyIn = NO;
            }
        }
        
        
//        cell.stockName.text = [self.dealData objectForKey:@"StockName"];
//        cell.timeLabel.text = [self.dealData objectForKey:@"DealTime"];
//        cell.priceLabel.text = [self.dealData objectForKey:@"DealPrice"];
//        cell.amountLabel.text = [self.dealData objectForKey:@"DealAmount"];
//        cell.realLabel.text = [self.dealData objectForKey:@"DealMoney"];
        
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
        
        if([name isEqualToString:@"自选"]){
            self.assetSelectIndex = 0;
            [self getSelectInfo];
            return;
        }
        self.assetSelectIndex = indexPath.row;
        NSDictionary* parameters = @{@"order_by":@"price",
                                     @"order":@"desc",
                                     @"asset":name
                                     };
        NSString* url = @"market/item";
        UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
        if(nil == temp){
            temp = self.navigationController;
        }
        [HUDUtil showHudViewInSuperView:temp.view withMessage:@"请求中…"];
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
                [HUDUtil hideHudView];
                //            NSLog(@"list = %@",data);
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [self.infoArray removeAllObjects];
                    self.infoArray = [[data objectForKey:@"data"] objectForKey:@"items"];
                    if(self.infoArray){
//                        NSLog(@"items = %@",self.infoArray);
                        [self.stcokInfoView reloadData];
                    }
                }else{
                    
                    [HUDUtil showHudViewInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                    
                }
            }
        }];
        
    }
    if(tableView == self.stcokInfoView){
        TradeStockInfoTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [self.marketNamelabel setTitle:cell.name.text forState:UIControlStateNormal];
        
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8f",0.0000000000];
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",0.0000000000];
        
        
//        self.marketNamelabel.titleLabel.text = cell.name.text;
        self.currentPage = 0;
        self.isUpdate = YES;
        self.isGetPrice = NO;
        
        [self.sortGuideView setHidden:YES];
        
        [self setStcokInfo:self.infoArray[indexPath.row]];
        
        [self.radioBtn setSelectIndex:0];
        [self.dealArray removeAllObjects];
        [self.dealList reloadData];
        [self getPendingOrders:1];
        
    }
    
    if(tableView == self.askList || tableView == self.bidsList){
        askAndBidsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        self.purchasePriceLabel.text = cell.price.text;
        self.purchaseAmountLabel.text = cell.amount.text;
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if(!self.isUpdate){
        
        return;
    }
    if(self.isUpdate && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
        [self getPendingOrders:self.currentPage+1];
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
