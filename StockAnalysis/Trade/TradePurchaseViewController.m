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
#import "AnaysisSearchViewController.h"
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

@property (weak, nonatomic) IBOutlet UIButton *depthBtn;

@property (weak, nonatomic) IBOutlet UILabel *noPendingLabel;
@property (nonatomic,strong)NSMutableDictionary* dealData;

@property (nonatomic)BOOL firstOpen;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL isUpdate;

@property (nonatomic,assign)NSInteger assetSelectIndex;

@property (nonatomic,assign)NSInteger numberDepth;

@property(nonatomic,assign)BOOL isGetPrice;
@property(nonatomic,assign)BOOL isLogin;

@end



@implementation TradePurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    self.isLogin = islogin;
    
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
    
    if([self.title isEqualToString:Localize(@"Sell")]){
        [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
        [self.purchaseBtn setTitle:Localize(@"Sell") forState:UIControlStateNormal];
        [self.selectBuyTypeBtn setTitle:Localize(@"Limit_Sell") forState:UIControlStateNormal];
        [self.buyTypeMarketBtn setTitle:Localize(@"Quick_Sell") forState:UIControlStateNormal];
        [self.buyTypeLimitBtn setTitle:Localize(@"Limit_Sell") forState:UIControlStateNormal];
    }else if([self.title isEqualToString:Localize(@"Buy")]){
        [self.purchaseBtn setBackgroundColor:kColor(80, 184, 115)];
        [self.purchaseBtn setTitle:Localize(@"Buy") forState:UIControlStateNormal];
        [self.selectBuyTypeBtn setTitle:Localize(@"Limit_Buy") forState:UIControlStateNormal];
        [self.buyTypeMarketBtn setTitle:Localize(@"Quick_Buy") forState:UIControlStateNormal];
        [self.buyTypeLimitBtn setTitle:Localize(@"Limit_Buy") forState:UIControlStateNormal];
    }
    
    //单选按钮
    NSArray *tiles = @[@"25%",@"50%",@"75%",@"100%"];
    self.radioBtn = [[RadioButton alloc] initWithFrame:self.editPercentContainer.bounds titles:tiles selectIndex:-1];
    [self.editPercentContainer addSubview:self.radioBtn];
    self.editPercentContainer.backgroundColor = [UIColor whiteColor];
    WeakSelf(weakSelf);
    self.radioBtn.indexChangeBlock = ^(NSInteger index){
//        NSLog(@"index:%li",index);
        
        if(index == -1){
            return ;
        }
        double available = [[weakSelf.avaliableMoney.text substringFromIndex:[weakSelf.avaliableMoney.text rangeOfString:Localize(@"Can_Use")].length] doubleValue];
        if([[weakSelf.priceRMBLabel.text substringFromIndex:1] doubleValue] > 0){
            
            double willbuy = available*0.25*(index+1)/[self.purchasePriceInput.text doubleValue];
//            double willmoney = available*0.25*(index+1);
           
//            weakSelf.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",willmoney];
            weakSelf.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",willbuy];
        }
    };
    
//    [self.radioBtn setSelectIndex:0];
    
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
    
    _isGetPrice = NO;
    _assetSelectIndex = 0;
    
    self.firstOpen = YES;
    NSLog(@"title = %@",self.title);
    if([self.title isEqualToString:Localize(@"Sell")]){
        [self.purchaseBtn setBackgroundColor:[UIColor redColor]];
    }else if([self.title isEqualToString:Localize(@"Buy")]){
        [self.purchaseBtn setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:185.0/255.0 blue:112.0/255.0 alpha:1.0]];
    }
//    [[SocketInterface sharedManager] closeWebSocket];
    [SocketInterface sharedManager].delegate = self;
    [[SocketInterface sharedManager] openWebSocket];
    
    self.askList.tableFooterView = [UIView new];
    self.bidsList.tableFooterView = [UIView new];
    
    self.askList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bidsList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.dealArray removeAllObjects];
    
    
    [self.enterKLine setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.enterKLine addGestureRecognizer:singleTap];
    
    self.purchasePriceInput.text = Localize(@"Price_Label");
    self.purchaseAmountInput.text = Localize(@"Number_Label");
    if(!self.isLogin){
        [self.purchaseBtn setBackgroundColor:[UIColor grayColor]];
        [self.purchaseBtn setEnabled:NO];
    }
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
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if(textView == self.purchaseAmountInput){
        if([self.purchaseAmountInput.text isEqualToString:Localize(@"Number_Label")] || [self.purchaseAmountInput.text isEqualToString:Localize(@"Price_Number")]){
            self.purchaseAmountInput.text = @"";
        }
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    if(textView == self.purchasePriceInput){
        double price = [self.purchasePriceInput.text doubleValue];
        double available = [[self.avaliableMoney.text substringFromIndex:[self.avaliableMoney.text rangeOfString:Localize(@"Can_Use")].length] doubleValue];
        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4lf",price];
        
        double canbuynum = available/price;
        [self.canButAmount setText:[NSString stringWithFormat:@"%@%8lf",Localize(@"Can_Buy"),canbuynum]];
        
        if(![self.purchaseAmountInput.text isEqualToString:Localize(@"Number_Label")]){
            if(self.radioBtn.getSelectIndex == -1){
//                double amount = available/(price);
//                self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",amount];
            }else{
                double amount = available*((self.radioBtn.getSelectIndex+1)*0.25)/(price);
                self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",amount];
            }
            
        }
        
    }else if (textView == self.purchaseAmountInput){
        if(self.purchaseAmountInput.text.length == 0){
            if([self.editPriceContainer isHidden]){
                if([self.title isEqualToString:Localize(@"Buy")]){
                    self.purchaseAmountInput.text = Localize(@"Price_Number");
                }else if ([self.title isEqualToString:Localize(@"Sell")]){
                    self.purchaseAmountInput.text = Localize(@"Number_Label");
                }
            }else{
                self.purchaseAmountInput.text = Localize(@"Number_Label");
            }
        }else{
            double amount = [self.purchaseAmountInput.text doubleValue];
            
            if(amount<0){
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Number_Tip")];
            }else{
                self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",amount];
                //            float price = amount*([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
                [self.radioBtn setSelectIndex:-1];
                //            self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
            }
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
    WeakSelf(weakSelf);
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
                    if([weakSelf.marketNamelabel.titleLabel.text containsString:keyinfo]){
                        
                        if([weakSelf.title isEqualToString:Localize(@"Sell")]){
                            if([weakSelf.marketNamelabel.titleLabel.text rangeOfString:keyinfo].location == 0){
                                money = [exchangeinfo objectForKey:keyinfo];
                            }
                        }else{
                            if([weakSelf.marketNamelabel.titleLabel.text rangeOfString:keyinfo].location+[self.marketNamelabel.titleLabel.text rangeOfString:keyinfo].length == self.marketNamelabel.titleLabel.text.length){
                                money = [exchangeinfo objectForKey:keyinfo];
                            }
                        }
                    }
                }
//                NSLog(@"money = %@",money);
                double available = [[money objectForKey:@"available"] doubleValue];
                weakSelf.avaliableMoney.text = [NSString stringWithFormat:@"%@%.4lf",Localize(@"Can_Use"),available];
                if([[weakSelf.priceRMBLabel.text substringFromIndex:1] doubleValue] > 0){
                    double canbuy = available/[[weakSelf.priceRMBLabel.text substringFromIndex:1] doubleValue];
                    weakSelf.canButAmount.text = [NSString stringWithFormat:@"%@%.8lf",Localize(@"Can_Buy"),canbuy];
                }
                
                if([weakSelf.title isEqualToString:Localize(@"Sell")]){
                    
                    if(available <= 0){
                        [weakSelf.purchaseBtn setBackgroundColor:[UIColor grayColor]];
                        [weakSelf.purchaseBtn setEnabled:NO];
                    }else{
                        [weakSelf.purchaseBtn setBackgroundColor:[UIColor redColor]];
                        [weakSelf.purchaseBtn setEnabled:YES];
                    }
                }else if([weakSelf.title isEqualToString:Localize(@"Buy")]){
                    
                    if(available <= 0){
                        [weakSelf.purchaseBtn setBackgroundColor:[UIColor grayColor]];
                        [weakSelf.purchaseBtn setEnabled:NO];
                    }else{
                        [weakSelf.purchaseBtn setBackgroundColor:kColor(80, 184, 115)];
                        [weakSelf.purchaseBtn setEnabled:YES];
                    }
                }
                [self.radioBtn setSelectIndex:[self.radioBtn getSelectIndex]];
//                if(_firstOpen){
//                    _firstOpen = NO;
//                }else{
//                    [self.radioBtn setSelectIndex:[self.radioBtn getSelectIndex]];
//                }
                
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
    
    SortView *sort2 = [[SortView alloc] initWithFrame:CGRectMake(0, 0, 0, 15) title:Localize(@"Rise_Down_Rate")];
    [sort2 setTitleWithFont:12 withColor:kColor(136, 136, 136)];
    sort2.block = ^(BOOL isUp){
        //TODO 数据排序，reload
    };
    sort2.centerY = _sortContantView.centerY;
    sort2.right = _sortContantView.centerX-sort2.width/2;
    [_sortContantView addSubview:sort2];
    
    SortView *sort3 = [[SortView alloc] initWithFrame:CGRectMake(0, 0, 0, 15) title:Localize(@"Deal_Num")];
    [sort3 setTitleWithFont:12 withColor:kColor(136, 136, 136)];
    sort3.block = ^(BOOL isUp){
        //TODO 数据排序，reload
    };
    sort3.right = _sortContantView.width+sort3.width-10;
    sort3.centerY = _sortContantView.centerY;
    [_sortContantView addSubview:sort3];
    
    NSLog(@"屏幕宽：%f,%f",sort3.width,sort2.width);
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
    self.isLogin = islogin;
    if(!islogin){
//        [HUDUtil showSystemTipView:temp title:Localize(@"Menu_Title") withContent:Localize(@"Login_Tip")];
//        return;
    }
    
    if(!self.isLogin){
        [self.purchaseBtn setBackgroundColor:[UIColor grayColor]];
        [self.purchaseBtn setEnabled:NO];
        
        [self.noPendingLabel setHidden:NO];
    }
//    [[SocketInterface sharedManager] closeWebSocket];
    [SocketInterface sharedManager].delegate = self;
    [[SocketInterface sharedManager] openWebSocket];
    
    
    [self requestAnalysis];
    NSDictionary* info = [[AppData getInstance] getTradeInfo];
    if(info.count>0 && !_firstOpen){
        NSString* name = [info objectForKey:@"name"];
        [self setTradeName:name];
    }
    
    
    
    if(!_firstOpen){
        [self requestSubscribe];
        
        NSString* depth = @"0.0001";
        
        if(_numberDepth == 4){
            depth = @"0.0001";
        }else if (_numberDepth == 1){
            depth = @"0.1";
        }else if(_numberDepth == 0){
            depth = @"1";
        }
        
        [self getTradeInfo:self.marketNamelabel.titleLabel.text withDepth:depth];
        
        self.isUpdate = YES;
        self.currentPage = 0;
        [self getPendingOrders:1];
        [self.dealList reloadData];
    }
    
    
//    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
//
//    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
//    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
//    if(!islogin){
//        SCAlertController *alert = [SCAlertController alertControllerWithTitle:Localize(@"Menu_Title") message:@"请先登录" preferredStyle:  UIAlertControllerStyleAlert];
//        alert.messageColor = kColor(136, 136, 136);
//
//        //退出
//        SCAlertAction *exitAction = [SCAlertAction actionWithTitle:Localize(@"Menu_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    [[AppData getInstance] setTradeInfo:@{}];
    
    [self.sortGuideView setHidden:YES];
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
//        [HUDUtil showSystemTipView:temp title:Localize(@"Menu_Title") withContent:Localize(@"Login_Tip")];
//        return;
    }

    self.isUpdate = YES;
    self.currentPage = 0;
    _firstOpen = NO;
    _assetSelectIndex = 0;
    [self.marketNamelabel setTitle:_tradeName forState:UIControlStateNormal];
    [self getPendingOrders:1];
    
    [self requestSubscribe];
    
    NSString* depth = @"0.0001";
    
    if(_numberDepth == 4){
        depth = @"0.0001";
    }else if (_numberDepth == 1){
        depth = @"0.1";
    }else if(_numberDepth == 0){
        depth = @"1";
    }
    
    [self getTradeInfo:_tradeName withDepth:depth];

}

-(void)getTradeInfo:(NSString*)name withDepth:(NSString*)depth{
    NSArray *dicParma = @[name,
                          @(100),
                          depth
                          ];
    NSDictionary *dicAll = @{@"method":@"depth.subscribe",@"params":dicParma,@"id":@(PN_DepthSubscribe)};
    
    NSString *strAll = [dicAll JSONString];
    
    
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"depth.subscribe"];
}

-(void)requestAnalysis{
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSDictionary* parameters = @{};
    NSString* url = @"market/assortment";
    [self.titleArray removeAllObjects];
    [self.titleArray addObject:Localize(@"MySelect")];
//    [HUDUtil showHudViewInSuperView:temp.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                if([[data objectForKey:@"data"] objectForKey:@"tabs"]){
                    NSArray* tabs = [[data objectForKey:@"data"] objectForKey:@"tabs"];
                    for (NSDictionary* tab in tabs) {
                        NSString* tabtitle = [tab objectForKey:@"asset"];
//                        [chinaTitles addObject:tabtitle];
                        [weakSelf.titleArray addObject:tabtitle];
                    }
                    
                    NSLog(@"111self.titleArray = %@",weakSelf.titleArray);
//                    [_sortTitleView ]
                    
                    [_stcokSelectView reloadData];
                    
                    NSInteger selectedIndex = weakSelf.assetSelectIndex;
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                    [weakSelf.stcokSelectView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
              
                    if(_firstOpen){
                        [weakSelf getSelectInfo];
                    }

                }
            }else{
                [HUDUtil showHudViewInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];

    
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
        WeakSelf(weakSelf);
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            
            if(success){
                [HUDUtil hideHudView];
                //            NSLog(@"list = %@",data);
                if([[data objectForKey:@"ret"] intValue] == 1){
                    NSArray* items = [[data objectForKey:@"data"] objectForKey:@"items"];
                    
                    if(_firstOpen){
                        if(items.count>0){
                            [weakSelf.infoArray removeAllObjects];
                            [weakSelf.infoArray addObjectsFromArray:items];
                            if(weakSelf.infoArray.count>0){
                                NSDictionary* stockinfo = weakSelf.infoArray[0];
                                [weakSelf setStcokInfo:stockinfo];
                            }
                            [weakSelf.stcokInfoView reloadData];
                            weakSelf.assetSelectIndex = 0;
                            NSInteger selectedIndex = 0;
                            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                            [weakSelf.stcokSelectView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

                            NSInteger selectedIndex1 = 0;
                            NSIndexPath *selectedIndexPath1 = [NSIndexPath indexPathForRow:selectedIndex1 inSection:0];
                            [weakSelf.stcokInfoView selectRowAtIndexPath:selectedIndexPath1 animated:NO scrollPosition:UITableViewScrollPositionNone];
                            
//                            [self.radioBtn setSelectIndex:0];
                            
                            weakSelf.currentPage = 0;
                            weakSelf.isUpdate = YES;
                            [weakSelf getPendingOrders:1];
                            
                            NSDictionary* info = [[AppData getInstance] getTradeInfo];
                            if(info.count>0){
                                NSString* name = [info objectForKey:@"name"];
                                [weakSelf setTradeName:name];
                            }
                            
                        }else{
                            [weakSelf setOpenSelect];
                            
                        }
                        
                        
                    }else{
                        [weakSelf.infoArray removeAllObjects];
                        [weakSelf.infoArray addObjectsFromArray:items];
                        if(weakSelf.infoArray){
                            [weakSelf.stcokInfoView reloadData];
                        }
                        weakSelf.assetSelectIndex = 0;
                    }
                    
                    
                }else{
                    UINavigationController* temp = weakSelf.parentViewController.view.selfViewController.navigationController;
                    if(nil == temp){
                        temp = weakSelf.navigationController;
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
    if(nil == cell){
        return;
    }
    NSString* name = cell.name.text;
    
    NSDictionary* parameters = @{@"order_by":@"price",
                                 @"order":@"desc",
                                 @"asset":name
                                 };
    NSString* url = @"market/item";
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                weakSelf.infoArray = [[data objectForKey:@"data"] objectForKey:@"items"];
                if(weakSelf.infoArray){
//                    NSLog(@"items = %@",self.infoArray);
                    
                    if(weakSelf.infoArray.count>0){
                        NSDictionary* stockinfo = weakSelf.infoArray[0];
                        [weakSelf setStcokInfo:stockinfo];
                    }
                    [weakSelf.stcokInfoView reloadData];
                    
                    NSInteger selectedIndex1 = 0;
                    NSIndexPath *selectedIndexPath1 = [NSIndexPath indexPathForRow:selectedIndex1 inSection:0];
                    [weakSelf.stcokInfoView selectRowAtIndexPath:selectedIndexPath1 animated:NO scrollPosition:UITableViewScrollPositionNone];
                    
                    TradeStockInfoTableViewCell* cell1 = [weakSelf.stcokInfoView cellForRowAtIndexPath:selectedIndexPath1];
                    
                    [weakSelf.marketNamelabel setTitle:cell1.name.text forState:UIControlStateNormal];
                    
                    weakSelf.currentPage = 0;
                    weakSelf.isUpdate = YES;
                    [weakSelf getPendingOrders:1];
                    
//                    [self.radioBtn setSelectIndex:0];
                    
                    NSDictionary* info = [[AppData getInstance] getTradeInfo];
                    if(info.count>0){
                        NSString* name = [info objectForKey:@"name"];
                        [weakSelf setTradeName:name];
                    }
                    
                    
                }
                
                if(_firstOpen){
                    _firstOpen = NO;
                }
                
            }else{
                UINavigationController* temp = weakSelf.parentViewController.view.selfViewController.navigationController;
                if(nil == temp){
                    temp = weakSelf.navigationController;
                }
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
}

-(void)setStcokInfo:(NSDictionary*)info{
 
    [self.marketNamelabel setTitle:[info objectForKey:@"market"] forState:UIControlStateNormal];
    
    [self requestSubscribe];
    
    NSString* depth = @"0.0001";
    
    if(_numberDepth == 4){
        depth = @"0.0001";
    }else if (_numberDepth == 1){
        depth = @"0.1";
    }else if(_numberDepth == 0){
        depth = @"1";
    }
    
    [self getTradeInfo:[info objectForKey:@"market"] withDepth:depth];
    
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
    
    self.purchaseAmountInput.text = Localize(@"Number_Label");
}

- (IBAction)clickQuickBuy:(id)sender {
    UIButton* btn = sender;
    [self.buyTypeView setHidden:YES];
    [self.selectBuyTypeBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    
    [self.marketPriceView setHidden:NO];
    
    [self.editPriceContainer setHidden:YES];
    
    self.purchaseAmountInput.text = Localize(@"Number_Label");
    if([self.title isEqualToString:Localize(@"Buy")]){
        self.purchaseAmountInput.text = Localize(@"Price_Number");
    }
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
    [self.depthBtn setTitle:[NSString stringWithFormat:@"4%@",Localize(@"Point_Num")] forState:UIControlStateNormal];
    [self getTradeInfo:self.marketNamelabel.titleLabel.text withDepth:@"0.0001"];
    [self.askList reloadData];
    [self.bidsList reloadData];
}
- (IBAction)clickOne:(id)sender {
    [self.depthView setHidden:YES];
    _numberDepth = 1;
    [self.depthBtn setTitle:[NSString stringWithFormat:@"1%@",Localize(@"Point_Num")] forState:UIControlStateNormal];
    [self getTradeInfo:self.marketNamelabel.titleLabel.text withDepth:@"0.1"];
    [self.askList reloadData];
    [self.bidsList reloadData];
}
- (IBAction)clickZero:(id)sender {
    [self.depthView setHidden:YES];
    _numberDepth = 0;
    [self.depthBtn setTitle:[NSString stringWithFormat:@"0%@",Localize(@"Point_Num")] forState:UIControlStateNormal];
    [self getTradeInfo:self.marketNamelabel.titleLabel.text withDepth:@"1"];
    [self.askList reloadData];
    [self.bidsList reloadData];
}
- (IBAction)clickDepth:(id)sender {
    if(self.depthView.isHidden){
        [self.depthView setHidden:NO];
    }else{
        [self.depthView setHidden:YES];
    }
    
}
- (IBAction)clickPurchase:(id)sender {
    
    [self.purchaseAmountInput endEditing:YES];
    [self.purchasePriceInput endEditing:YES];
    
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    self.isLogin = islogin;
    if(!islogin){
        [HUDUtil showSystemTipView:temp title:Localize(@"Menu_Title") withContent:Localize(@"Login_Tip")];
        return;
    }
    
    if([self.purchaseAmountInput.text isEqualToString:Localize(@"Number_Label")]){
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Input_Number")];
        return;
    }
    
    NSString* url1 = @"account/getConfirmState";
    NSDictionary* params = @{};
//    [HUDUtil showHudViewInSuperView:temp.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
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
                            if([weakSelf.title isEqualToString:Localize(@"Buy")]){
                                [weakSelf buyStock:token];
                            }else if ([weakSelf.title isEqualToString:Localize(@"Sell")]){
                                [weakSelf sellStock:token];
                            }
                        }else{
                            [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Money_Pwd_Verify_Tip")];
                        }
                    };
                    
                }else{
                    
                    [weakSelf.purchaseBtn setBackgroundColor:[UIColor grayColor]];
                    [weakSelf.purchaseBtn setEnabled:NO];
                    
                    if([weakSelf.title isEqualToString:Localize(@"Buy")]){
                        [weakSelf buyStock:@""];
                    }else if ([weakSelf.title isEqualToString:Localize(@"Sell")]){
                        [weakSelf sellStock:@""];
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
//    NSLog(@"self.marketPriceLabel.text  = %@",self.marketPriceLabel.text );
    double price = [self.purchasePriceInput.text doubleValue];
    NSInteger limit = 1;
    if(!self.marketPriceView.isHidden){
//        price = [[self.marketPriceLabel.text substringFromIndex:[self.marketPriceLabel.text rangeOfString:@"¥"].location+[self.marketPriceLabel.text rangeOfString:@"¥"].length] doubleValue];
        price = 0;
        limit = 0;
    }
    NSDictionary* parameters = @{@"market":self.marketNamelabel.titleLabel.text,
                                 @"num":@([self.purchaseAmountInput.text doubleValue]),
                                 @"price":@(price),
                                 @"mode":@"buy",
                                 @"is_limit":@(limit),
                                 @"asset_token":token
                                 };
//    [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if([weakSelf.title isEqualToString:Localize(@"Sell")]){
            
            [weakSelf.purchaseBtn setBackgroundColor:[UIColor redColor]];
            [weakSelf.purchaseBtn setEnabled:YES];
        }else if([weakSelf.title isEqualToString:Localize(@"Buy")]){
            
            [weakSelf.purchaseBtn setBackgroundColor:kColor(80, 184, 115)];
            [weakSelf.purchaseBtn setEnabled:YES];
        }
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Pending_Succ")];


                [weakSelf setMoneyInfo];
                [weakSelf.radioBtn setSelectIndex:-1];
                if([weakSelf.editPriceContainer isHidden]){
                    if([weakSelf.title isEqualToString:Localize(@"Buy")]){
                        weakSelf.purchaseAmountInput.text = Localize(@"Price_Number");
                    }else if ([weakSelf.title isEqualToString:Localize(@"Sell")]){
                        weakSelf.purchaseAmountInput.text = Localize(@"Number_Label");
                    }
                }else{
                    weakSelf.purchaseAmountInput.text = Localize(@"Number_Label");
                }
                
                
                
                weakSelf.currentPage = 0;
                weakSelf.isUpdate = YES;
                
                
                
                [weakSelf getPendingOrders:1];
                
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
    
    double price = [self.purchasePriceInput.text doubleValue];
    NSInteger limit = 1;
    if(!self.marketPriceView.isHidden){
//        price = [[self.marketPriceLabel.text substringFromIndex:[self.marketPriceLabel.text rangeOfString:@"¥"].location+[self.marketPriceLabel.text rangeOfString:@"¥"].length] doubleValue];
        price = 0;
        limit = 0;
    }
    
    double num = [self.purchaseAmountInput.text doubleValue];
   
    NSString* url = @"exchange/trade/add";
    NSDictionary* parameters = @{@"market":self.marketNamelabel.titleLabel.text,
                                 @"num":@(num),
                                 @"price":@(price),
                                 @"mode":@"sell",
                                 @"is_limit":@(limit),
                                 @"asset_token":token
                                 };
//    [HUDUtil showHudViewInSuperView:temp.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if([weakSelf.title isEqualToString:Localize(@"Sell")]){
            
            [weakSelf.purchaseBtn setBackgroundColor:[UIColor redColor]];
            [weakSelf.purchaseBtn setEnabled:YES];
        }else if([weakSelf.title isEqualToString:Localize(@"Buy")]){
            
            [weakSelf.purchaseBtn setBackgroundColor:kColor(80, 184, 115)];
            [weakSelf.purchaseBtn setEnabled:YES];
        }
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Pending_Succ")];

                
                [weakSelf setMoneyInfo];
                [weakSelf.radioBtn setSelectIndex:-1];
                
                if([weakSelf.editPriceContainer isHidden]){
                    if([weakSelf.title isEqualToString:Localize(@"Buy")]){
                        weakSelf.purchaseAmountInput.text = Localize(@"Price_Number");
                    }else if ([weakSelf.title isEqualToString:Localize(@"Sell")]){
                        weakSelf.purchaseAmountInput.text = Localize(@"Number_Label");
                    }
                }else{
                    weakSelf.purchaseAmountInput.text = Localize(@"Number_Label");
                }
                
                weakSelf.currentPage = 0;
                weakSelf.isUpdate = YES;
                [weakSelf getPendingOrders:1];
//                [self.dealList reloadData];
            }else{
                
                [HUDUtil showHudViewTipInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
}
- (IBAction)clickAddPruchaseAmount:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    
    if([self.purchaseAmountInput.text isEqualToString:Localize(@"Number_Label")]){
        self.purchaseAmountInput.text = @"0.000000000";
    }
    
    double amount = [self.purchaseAmountInput.text doubleValue];
    double available = [[self.canButAmount.text substringFromIndex:[self.canButAmount.text rangeOfString:Localize(@"Can_Buy")].length] doubleValue];
    amount++;
    if(amount>available){
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Over_Num")];
    }else{
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",amount];
//        float price = amount*([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
//        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
    }
    
}
- (IBAction)clickAReducePruchaseAmount:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    if([self.purchaseAmountInput.text isEqualToString:Localize(@"Number_Label")]){
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"NO_Imput_Num")];
        return;
    }
    double amount = [self.purchaseAmountInput.text doubleValue];
    amount--;
    if(amount<0){
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Number_Tip")];
    }else{
        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",amount];
        float price = amount*([[self.priceRMBLabel.text substringFromIndex:1] floatValue]);
//        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
    }
    
}
- (IBAction)clickReducePruchasePrice:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    double price = [self.purchasePriceInput.text doubleValue];
    price--;
    self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",price];
    double available = [[self.avaliableMoney.text substringFromIndex:[self.avaliableMoney.text rangeOfString:Localize(@"Can_Use")].length] doubleValue];
    
    double canbuynum = available/price;
    [self.canButAmount setText:[NSString stringWithFormat:@"%@%8lf",Localize(@"Can_Buy"),canbuynum]];
    
    if(![self.purchaseAmountInput.text isEqualToString:Localize(@"Number_Label")]){
        if(self.radioBtn.getSelectIndex == -1){
            //                double amount = available/(price);
            //                self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",amount];
        }else{
            double amount = available*((self.radioBtn.getSelectIndex+1)*0.25)/(price);
            self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",amount];
        }
        
    }
    
}
- (IBAction)clickAddPruchasePrice:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    double price = [self.purchasePriceInput.text doubleValue];
    double available = [[self.avaliableMoney.text substringFromIndex:[self.avaliableMoney.text rangeOfString:Localize(@"Can_Use")].length] doubleValue];
    price++;
    self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4lf",price];
    double canbuynum = available/price;
    [self.canButAmount setText:[NSString stringWithFormat:@"%@%8lf",Localize(@"Can_Buy"),canbuynum]];
    if(![self.purchaseAmountInput.text isEqualToString:Localize(@"Number_Label")]){
        if(self.radioBtn.getSelectIndex == -1){
            //                double amount = available/(price);
            //                self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",amount];
        }else{
            double amount = available*((self.radioBtn.getSelectIndex+1)*0.25)/(price);
            self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8lf",amount];
        }
        
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
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            NSNumber* rest = [data objectForKey:@"ret"];
            if([rest intValue] == 1){
                NSString* market = @"";
                NSDictionary* datainfo = [data objectForKey:@"data"];
                NSLog(@"datainfo = %@",datainfo);
                if([weakSelf.title isEqualToString:Localize(@"Buy")]){
                    NSDictionary* exchangeinfo = [datainfo objectForKey:@"exchange"];
                    
                    NSArray* keys = [exchangeinfo allKeys];
                    int index = -1;
                    for (NSString* keyinfo in keys) {
                        NSLog(@"keyinfo = %@",keyinfo);
                        NSLog(@"marketNamelabel = %@",weakSelf.marketNamelabel.titleLabel.text);
                        NSInteger location = [weakSelf.marketNamelabel.titleLabel.text rangeOfString:keyinfo].location;
                        if(location != NSNotFound){
                            if(location>index){
                                index = location;
                                market = keyinfo;
                            }
                        }
                        
                        
                    }
                }else if ([weakSelf.title isEqualToString:Localize(@"Sell")]){
                    NSDictionary* exchangeinfo = [datainfo objectForKey:@"shop"];
                    
                    NSArray* keys = [exchangeinfo allKeys];
                    int index = 10000;
                    for (NSString* keyinfo in keys) {
                        NSLog(@"keyinfo = %@",keyinfo);
                        NSLog(@"marketNamelabel = %@",weakSelf.marketNamelabel.titleLabel.text);
                        NSInteger location = [weakSelf.marketNamelabel.titleLabel.text rangeOfString:keyinfo].location;
                        if(location != NSNotFound){
                            if(location<index && location>-1){
                                index = location;
                                market = keyinfo;
                            }
                        }
                        
                    }
                }
                
                
                ChargeAddressViewController *vc = [[ChargeAddressViewController alloc] initWithNibName:@"ChargeAddressViewController" bundle:nil];
                
                [[AppData getInstance] setAssetName:market];
                if(weakSelf.navigationController){
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    [temp pushViewController:vc animated:YES];
                }
                
                
            }else{
                
                [HUDUtil showHudViewInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
    
    
}
- (IBAction)clickSearch:(id)sender {
    AnaysisSearchViewController* search = [[AnaysisSearchViewController alloc] initWithNibName:@"AnaysisSearchViewController" bundle:nil];
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    [temp pushViewController:search animated:YES];
}

-(void)getPendingOrders:(NSInteger)page{
    
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
        return;
    }
    if(page == 1){
        [self.dealArray removeAllObjects];
    }
    self.currentPage = page;
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSString* mode = @"buy";
    if([self.title isEqualToString:Localize(@"Buy")]){
        mode = @"buy";
    }else if ([self.title isEqualToString:Localize(@"Sell")]){
        mode = @"sell";
    }
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"market":self.marketNamelabel.titleLabel.text,
                             @"page":@(page),
                             @"page_limit":@(5),
                             @"mode":mode,
                             @"state":@"pending"
                             };
//    NSLog(@"获取pending挂单数据请求参数：%@",params);
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
//        [HUDUtil hideHudView];
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* trades = [[data objectForKey:@"data"] objectForKey:@"trades"];
//                [HUDUtil showHudViewTipInSuperView:self.view withMessage:Localize(@"Load_Finish")];
                if(trades.count == 0){
                    if(weakSelf.dealArray.count == 0){
                        [weakSelf.noPendingLabel setHidden:NO];
                        [weakSelf.dealList reloadData];
                    }else{
                        [weakSelf.noPendingLabel setHidden:YES];
                        weakSelf.isUpdate = NO;
                    }
                    
//                    [HUDUtil showHudViewTipInSuperView:temp.view withMessage:@"全部加载完毕"];
                    
                }else{
                    
                    NSLog(@"挂单数据为：%@",trades);
                    [weakSelf.noPendingLabel setHidden:YES];
                    [weakSelf.dealArray addObjectsFromArray:trades];
                    [weakSelf.dealList reloadData];
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
    
    if(nil == message){
        //断线了，需要重连
        [[SocketInterface sharedManager] openWebSocket];
        [SocketInterface sharedManager].delegate = self;
        
        NSString* depth  = @"0.0001";
        
        if(_numberDepth == 4){
            depth = @"0.0001";
        }else if (_numberDepth == 1){
            depth = @"0.1";
        }else if(_numberDepth == 0){
            depth = @"1";
        }
        
        [self getTradeInfo:self.marketNamelabel.titleLabel.text withDepth:depth];
        
        [self requestSubscribe];
        return;
    }
    
    NSString* str = message;
    NSData* strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
    
    NSNull* err =[data objectForKey:@"error"];
    
    if(err){
//        NSLog(@"err = %@",err);
    }
//    int requestID = [[data objectForKey:@"id"] intValue];
    if([name isEqualToString:@"depth.update"]){
        
        NSArray* params = [data objectForKey:@"params"];
        
        if(params.count > 2){
            
            NSInteger isadd = [params[0] integerValue];
//            NSLog(@"********isadd == %ld*********",isadd);
            NSDictionary* result =params[1];
//            NSLog(@"数据详情:%ld",result.count);

            
            
            NSMutableArray* ask = [result objectForKey:@"asks"];
            NSMutableArray* bid = [result objectForKey:@"bids"];
            
//            NSLog(@"***************************************");
//            for (int i=0;i<ask.count;i++) {
//                if(i<ask.count){
//                    NSLog(@"i= %d,price = %@,num = %@",i,ask[i][0],ask[i][1]);
//                }
//            }


            if(ask.count>0){
                NSMutableArray* temp = [NSMutableArray new];
                [temp addObjectsFromArray:ask];
                
//                NSLog(@"******************原始数据*********************");
//                for (int i=0;i<ask.count;i++) {
//                    if(i<ask.count){
//                        NSLog(@"i= %d,price = %@,num = %@",i,ask[i][0],ask[i][1]);
//                    }
//                }
//                NSLog(@"******************复制数据*********************");
//                for (int i=0;i<temp.count;i++) {
//                    if(i<temp.count){
//                        NSLog(@"i= %d,price = %@,num = %@",i,temp[i][0],temp[i][1]);
//                    }
//                }

                //排序，从低到高
                for (int i=0; i<temp.count; i++) {
                    for (int j=0; j<temp.count-1-i; j++) {
                        if([temp[j][0] doubleValue]   > [temp[j+1][0] doubleValue]){
                            NSArray* temp2 = temp[j+1];
                            temp[j+1] = temp[j];
                            temp[j] = temp2;
                        }
                    }
                }
                
                if(isadd == 1){
                    [self.asksArray removeAllObjects];
                    
                    NSIndexSet* indexSet = [temp indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        return [obj[1] floatValue] == 0;
                    }];
                    
                    [temp removeObjectsAtIndexes:indexSet];
                    
                    [self.asksArray addObjectsFromArray:temp];
                    
                    NSMutableArray* temp3 = [NSMutableArray new];
                    for (int i=0; i<self.asksArray.count; i++) {
                        if(![temp3 containsObject:self.asksArray[i]]){
                            [temp3 addObject:self.asksArray[i]];
                        }
                    }
                    [self.asksArray removeAllObjects];
                    [self.asksArray addObjectsFromArray:temp3];
                    
//                    NSLog(@"****************isadd == 1显示数据***********************");
//
//                    for (int i=0;i<self.asksArray.count;i++) {
//                        if(i<self.asksArray.count){
//                            NSLog(@"i= %d,price = %@,num = %@",i,self.asksArray[i][0],self.asksArray[i][1]);
//                        }
//                    }
                    
                    [self.askList reloadData];
                }else{
                    
//                    NSLog(@"***************************************");
//                    for (int i=0;i<self.asksArray.count;i++) {
//                        if(i<self.asksArray.count){
//                            NSLog(@"i= %d,price = %@,num = %@",i,self.asksArray[i][0],self.asksArray[i][1]);
//                        }
//                    }
//                    NSLog(@"******************更新数据*********************");
//                    for (int i=0;i<ask.count;i++) {
//                        if(i<ask.count){
//                            NSLog(@"i= %d,price = %@,num = %@",i,ask[i][0],ask[i][1]);
//                        }
//                    }
//
                    NSMutableArray* temp1 = [NSMutableArray new];
                    
                    for (NSArray* askdata in temp) {
                        float num = [askdata[1] floatValue];
                        double price = [askdata[0] doubleValue];
                        if(num == 0){
                            //数量为0的价格全部找出，删除出队列
                            NSIndexSet* indexSet = [self.asksArray indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                return  [obj[0] doubleValue] == price;
                            }];
                            [self.asksArray removeObjectsAtIndexes:indexSet];
                        }else{
                            //数量不为0，找出价格相同的，更新数量
                            [self.asksArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if([obj[0] doubleValue] == price){
                                    obj[1] = askdata[1];
                                }
                            }];
                        }
                    }
                    
                    
                    NSIndexSet* indexSet = [temp indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        return [obj[1] floatValue] == 0;
                    }];
                    
                    [temp removeObjectsAtIndexes:indexSet];
                    
                    //新旧数据相加
                    [temp1 addObjectsFromArray:self.asksArray];
                    
                    for(int i=0;i<self.asksArray.count;i++){
                        double price = [self.asksArray[i][0] doubleValue];
                        float num = [self.asksArray[i][1] floatValue];
                        NSIndexSet* indexSet = [temp indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            return [obj[0] doubleValue] == price && [obj[1] floatValue] == num;
                        }];
                        [temp removeObjectsAtIndexes:indexSet];
                    }
                    
                    [temp1 addObjectsFromArray:temp];
//                    NSLog(@"*****************temp1显示数据-排序前**********************");
//                    for (int i=0;i<temp1.count;i++) {
//                        NSLog(@"i= %d,price = %@,num = %@",i,temp1[i][0],temp1[i][1]);
//                    }
                    //排序，从低到高
                    for (int i = 0; i < temp1.count; i ++) {
                        for (int j = 0; j < temp1.count-1-i; j ++) {
                            if ([temp1[j][0] floatValue] > [temp1[j+1][0] floatValue]) {
                                NSArray* temp2 = temp1[j+1];
                                temp1[j+1] = temp1[j];
                                temp1[j] = temp2;
                            }
                        }
                    }
                    
//                    NSLog(@"*****************temp1显示数据**********************");
//                    for (int i=0;i<temp1.count;i++) {
//                        NSLog(@"i= %d,price = %@,num = %@",i,temp1[i][0],temp1[i][1]);
//                    }
                    
                    NSMutableArray* temp3 = [NSMutableArray new];
                    for (int i=0; i<temp1.count; i++) {
                        if(![temp3 containsObject:temp1[i]]){
                            [temp3 addObject:temp1[i]];
                        }
                    }
                    
//                    NSLog(@"*****************temp3显示数据**********************");
//                    for (int i=0;i<temp3.count;i++) {
//                        NSLog(@"i= %d,price = %@,num = %@",i,temp3[i][0],temp3[i][1]);
//                    }
                    
                    [self.asksArray removeAllObjects];
                    [self.asksArray addObjectsFromArray:temp3];
                    
//                    NSLog(@"*****************显示数据**********************");
//                    for (int i=0;i<self.asksArray.count;i++) {
//                        if(i<self.asksArray.count){
//                            NSLog(@"i= %d,price = %@,num = %@",i,self.asksArray[i][0],self.asksArray[i][1]);
//                        }
//                    }
                    
                    [self.askList reloadData];
                }
            }

            if(bid.count>0){
                
                NSMutableArray* temp = [NSMutableArray new];
                
                [temp addObjectsFromArray:bid];
                
                
                for (int i=0; i<temp.count; i++) {
                    for (int j=i+1; j<temp.count; j++) {
                        if([temp[i][0] floatValue] < [temp[j][0] floatValue]){
                            NSArray* temp2 = temp[i];
                            temp[i] = temp[j];
                            temp[j] = temp2;
                        }
                    }
                }
                
                if(isadd == 1){
                    [self.bidsArray removeAllObjects];
                    
                    NSIndexSet* indexSet = [temp indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        return [obj[1] floatValue] == 0;
                    }];
                    
                    [temp removeObjectsAtIndexes:indexSet];
                    
                    [self.bidsArray addObjectsFromArray:temp];
                    
                    [self.bidsList reloadData];
                }else{
                    NSMutableArray* temp1 = [NSMutableArray new];
                    
                    for (NSArray* askdata in temp) {
                        float num = [askdata[1] floatValue];
                        double price = [askdata[0] doubleValue];
                        if(num == 0){
                            
                            NSIndexSet* indexSet = [self.bidsArray indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                return  [obj[0] doubleValue] == price;
                            }];
                            [self.bidsArray removeObjectsAtIndexes:indexSet];
                        }else{
                            [self.bidsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if([obj[0] doubleValue] == price){
                                    obj[1] = askdata[1];
                                }
                            }];
                        }  
                    }
                    
                    NSIndexSet* indexSet = [temp indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        return [obj[1] floatValue] == 0;
                    }];
                    
                    [temp removeObjectsAtIndexes:indexSet];
                    
                    //新旧数据相加
                    [temp1 addObjectsFromArray:self.bidsArray];
                    
                    for(int i=0;i<temp.count;i++){
                        if(![self.bidsArray containsObject:temp[i]]){
                            [temp1 addObject:temp[i]];
                        }
                    }
                    
                    for (int i = 0; i < temp1.count; i ++) {
                        for (int j = i + 1; j < temp1.count; j ++) {
                            if ([temp1[i][0] floatValue] < [temp1[j][0] floatValue]) {
                                NSArray* temp2 = temp1[i];
                                temp1[i] = temp1[j];
                                temp1[j] = temp2;
                            }
                        }
                    }
                    
                    NSMutableArray* temp2  = [NSMutableArray new ];
                    
                    for(NSArray* temp1data in temp1){
                        if(![temp2 containsObject:temp1data]){
                            [temp2 addObject:temp1data];
                        }
                    }
                    
                    
                    [self.bidsArray removeAllObjects];
                    [self.bidsArray addObjectsFromArray:temp2];
                    
                    [self.bidsList reloadData];
                }
            }
        }
        
        
    }else if ([name isEqualToString:@"state.update"]){
        NSArray* params = [data objectForKey:@"params"];
        if(params.count == 2){
            NSDictionary* info = params[1];
            //            NSLog(@"info = %@",info);
            self.priceRMBLabel.text = [NSString stringWithFormat:@"¥%.4f",[[info objectForKey:@"last"] floatValue]];

            float price = [[info objectForKey:@"open"] floatValue];
            float nowprice = [[info objectForKey:@"last"] floatValue];
            
            float rate = (float)((float)(nowprice-price)/(float)price)*100;
//            NSLog(@"price = %f,nowprice = %f,rate = %f",price,nowprice,rate);
            if(price == 0){
                rate = 0;
            }
            if(rate>0){
                [self.rateLabel setTextColor:kSoldOutRed];
            }else{
                [self.rateLabel setTextColor:kColor(51, 147, 71)];
            }
            self.rateLabel.text = [NSString stringWithFormat:@"%.2f%%",rate];

            
            self.marketPriceLabel.text = [NSString stringWithFormat:@"¥%@",[info objectForKey:@"last"]];
            self.periodPrice.text =[NSString stringWithFormat:@"%.4f",[[info objectForKey:@"last"] floatValue]];
            if(!_isGetPrice){
                _isGetPrice = YES;
                self.purchasePriceInput.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"last"]];
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
        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Cancel_Succ")];
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
        return self.asksArray.count<5?self.asksArray.count:5;
    }
    if(tableView == self.bidsList){
        return self.bidsArray.count<5?self.bidsArray.count:5;
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
            cell.volume.text = [Util countNumAndChangeformat:cell.volume.text];
        }
        
        
        return cell;
    }
    
    if(tableView == self.askList){
        askAndBidsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"askAndBidsTableViewCell" owner:self options:nil].firstObject;
        }
        NSInteger index = 0;
        if(self.asksArray.count>=5){
            index = 4-indexPath.row;
        }else{
            index = self.asksArray.count- 1 - indexPath.row;
        }
        
        if(self.asksArray.count>indexPath.row){
            NSArray* info = self.asksArray[index];
            if(_numberDepth == 4){
                cell.price.text = [NSString stringWithFormat:@"%.4f",[info[0] floatValue]] ;
            }else if (_numberDepth == 1){
                cell.price.text = [NSString stringWithFormat:@"%.1f000",[info[0] floatValue]] ;
            }else if (_numberDepth == 0){
                cell.price.text = [NSString stringWithFormat:@"%.0f.0000",[info[0] floatValue]] ;
            }
            
            cell.amount.text = [NSString stringWithFormat:@"%.3f",[info[1] floatValue]];
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
            NSArray* info = self.bidsArray[indexPath.row];
            if(_numberDepth == 4){
                cell.price.text = [NSString stringWithFormat:@"%.4f",[info[0] floatValue]] ;
            }else if (_numberDepth == 1){
                cell.price.text = [NSString stringWithFormat:@"%.1f000",[info[0] floatValue]] ;
            }else if (_numberDepth == 0){
                cell.price.text = [NSString stringWithFormat:@"%.0f.0000",[info[0] floatValue]] ;
            }
            
            cell.amount.text = [NSString stringWithFormat:@"%.3f",[info[1] floatValue]];
            
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
            cell.priceLabel.text = [NSString stringWithFormat:@"%.8lf",[[info objectForKey:@"price"] doubleValue]] ;
            cell.amountLabel.text = [NSString stringWithFormat:@"%.8lf",[[info objectForKey:@"num"] doubleValue]] ;
            cell.realLabel.text = [NSString stringWithFormat:@"%.8lf",[[info objectForKey:@"deal_money"] doubleValue]] ;
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
        
        if([name isEqualToString:Localize(@"MySelect")]){
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
//        [HUDUtil showHudViewInSuperView:temp.view withMessage:@"请求中…"];
        WeakSelf(weakSelf);
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
                [HUDUtil hideHudView];
                //            NSLog(@"list = %@",data);
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [weakSelf.infoArray removeAllObjects];
                    weakSelf.infoArray = [[data objectForKey:@"data"] objectForKey:@"items"];
                    if(weakSelf.infoArray){
//                        NSLog(@"items = %@",self.infoArray);
                        [weakSelf.stcokInfoView reloadData];
                    }
                }else{
                    
                    [HUDUtil showHudViewInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                    
                }
            }
        }];
        
    }
    if(tableView == self.stcokInfoView){
        
        [SocketInterface sharedManager].delegate = self;
        [[SocketInterface sharedManager] openWebSocket];
        
        TradeStockInfoTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [self.marketNamelabel setTitle:cell.name.text forState:UIControlStateNormal];
        
//        self.purchaseAmountInput.text = [NSString stringWithFormat:@"%.8f",0.0000000000];
        
        [[AppData getInstance] setTradeInfo:@{}];
        
        
        self.purchasePriceInput.text = Localize(@"Price_Label");
        if([self.editPriceContainer isHidden]){
            if([self.title isEqualToString:Localize(@"Buy")]){
                self.purchaseAmountInput.text = Localize(@"Price_Number");
            }else if ([self.title isEqualToString:Localize(@"Sell")]){
                self.purchaseAmountInput.text = Localize(@"Number_Label");
            }
        }else{
            self.purchaseAmountInput.text = Localize(@"Number_Label");
        }
//        self.purchasePriceInput.text = [NSString stringWithFormat:@"%.4f",0.0000000000];
        
        
//        self.marketNamelabel.titleLabel.text = cell.name.text;
        self.currentPage = 0;
        self.isUpdate = YES;
        self.isGetPrice = NO;
        
        
        [self.sortGuideView setHidden:YES];
        
        [self setStcokInfo:self.infoArray[indexPath.row]];
        
//        [self.radioBtn setSelectIndex:0];
        [self.dealArray removeAllObjects];
        [self.dealList reloadData];
        [self getPendingOrders:1];
        
        
        [self.asksArray removeAllObjects];
        [self.askList reloadData];
        [self.bidsArray removeAllObjects];
        [self.bidsList reloadData];
        
    }
    
    
    if(tableView == self.askList || tableView == self.bidsList){
        askAndBidsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
//        self.purchasePriceLabel.text = cell.price.text;
//        self.purchaseAmountLabel.text = cell.amount.text;
        
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
