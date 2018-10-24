//
//  UserFirstViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/6/20.
//  Copyright © 2018年 try. All rights reserved.
//

#import "UserFirstViewController.h"
#import "ExchangeViewController.h"
#import "Business ViewController.h"
#import "UserInfoViewController.h"
#import "HttpRequest.h"
#import "GameData.h"
#import "TTAutoRunLabel.h"
#import "FirstListTableViewCell.h"
#import "TCRotatorImageView.h"
#import "SocketInterface.h"
#import "StockLittleViewController.h"
#import "SetPasswordViewController.h"
#import "AppData.h"
#import "AdsViewController.h"
#import "MarqueeView.h"
#import "MarqueeContentViewController.h"
@interface UserFirstViewController ()<TTAutoRunLabelDelegate,UITableViewDelegate,UITableViewDataSource,SocketDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeRMBLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeUSDLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopRMBLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopUSDLabel;
@property (weak, nonatomic) IBOutlet UIView *autoRunActivityView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UITableView *randList;
@property (nonatomic,strong) TCRotatorImageView *adScrollView;

@property (nonatomic,strong) NSMutableArray* stockName;
@property (nonatomic,strong) NSMutableArray* tipsTitle;
@property (nonatomic,strong) NSMutableArray* tipsContent;
@property (nonatomic,strong) TTAutoRunLabel* runLabel;

@property (nonatomic, strong) MarqueeView *marqueeView;
@property (nonatomic, assign) NSInteger updateIndex;
@property (weak, nonatomic) IBOutlet UIButton *userInfoBtn;

@end

@implementation UserFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    //
    self.stockName = [NSMutableArray new];
    self.randList.delegate = self;
    self.randList.dataSource = self;
    self.tipsTitle = [NSMutableArray new];
    self.tipsContent = [NSMutableArray new];
    self.updateIndex = 0;
    _usernameLabel.text = @"用户名";
    
    NSString* username = [GameData getUserAccount];
    NSString* password = [GameData getUserPassword];
    
    NSLog(@"username = %@,password = %@",username,password);
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"登录中，请稍后"];
    if([username containsString:@"@"]){
        //邮箱登录
        NSDictionary *parameters = @{@"email": [GameData getUserAccount],
                                     @"password": [GameData getUserPassword]};
        
        NSString* url = @"account/login/email";
        
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            
            if(success){
                [HUDUtil hideHudView];
                //                NSLog(@"登录消息 = %@",data);
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [self autoLoginBack];
                    [GameData setUserPassword:password];
                }else{
                    NSString* msg = [data objectForKey:@"msg"];
                    [HUDUtil showSystemTipView:self.navigationController title:@"登录失败" withContent:msg];
                    
                    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                    [defaultdata setBool:NO forKey:@"IsLogin"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
                }
            }
        }];
    }else{
        //手机号登录
        NSDictionary *parameters = @{@"phone": [GameData getUserAccount],
                                     @"password": [GameData getUserPassword],
                                     @"district":[GameData getDistrict]
                                     };
        
        
        NSString* url = @"account/login/phone";
        
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            
            if(success){
                [HUDUtil hideHudView];
                //                NSLog(@"登录消息1 = %@",data);
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [self autoLoginBack];
                    [GameData setUserPassword:password];
                }else{
                    NSString* msg = [data objectForKey:@"msg"];
                    [HUDUtil showSystemTipView:self.navigationController title:@"登录失败" withContent:msg];
                    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                    [defaultdata setBool:NO forKey:@"IsLogin"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
                }
                
                
            }
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_runLabel stopAnimation];
    [_runLabel removeFromSuperview];
    _runLabel = nil;
    
    NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
}

#pragma mark TTAutoRunLabelDelegate

-(void)operateLabel:(TTAutoRunLabel *)autoLabel animationDidStopFinished:(BOOL)finished{
//    NSLog(@"autoLabel = %ld",autoLabel.contentTag);
    [autoLabel stopAnimation];
    if(autoLabel.contentTag<self.tipsTitle.count-1){
        [self createAutoRunLabel:self.tipsTitle[autoLabel.contentTag+1] view:self.autoRunActivityView fontsize:14 withTag:autoLabel.contentTag+1];
    }else{
        [self createAutoRunLabel:self.tipsTitle[0] view:self.autoRunActivityView fontsize:14 withTag:0];
    }
}

-(void)createAutoRunLabel:(NSString *)content view:(UIView* )contentview fontsize:(int)size withTag:(NSInteger) tag{
//    content = @"繁华声 遁入空门 折煞了梦偏冷 辗转一生 情债又几 如你默认 生死枯等 枯等一圈 又一圈的 浮图塔 断了几层 断了谁的痛直奔 一盏残灯 倾塌的山门 容我再等 历史转身 等酒香醇 等你弹 一曲古筝";
//    NSLog(@"contentview.frame.size.width = %f",contentview.frame.size.width);
    if(_runLabel){
        [_runLabel stopAnimation];
        [_runLabel removeFromSuperview];
        _runLabel = nil;
    }
    _runLabel = [[TTAutoRunLabel alloc] initWithFrame:CGRectMake(contentview.frame.size.width*0.07, contentview.frame.size.height*0.1, contentview.frame.size.width*0.95, contentview.frame.size.height)];
    _runLabel.delegate = self;
    _runLabel.directionType = Leftype;
//    [runLabel setRunViewColor:[UIColor colorWithRed:16./255.0 green:142.0/255.0 blue:233.0/255.0 alpha:0.1]];
    [contentview addSubview:_runLabel];
    UILabel* contentLabel = [self createLabelWithText:content textColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] labelFont:[UIFont systemFontOfSize:size]];
    contentLabel.tag = tag;
    [_runLabel addContentView:contentLabel];
    
    [_runLabel startAnimation];
}

-(UILabel*)createLabelWithText:(NSString* )text textColor:(UIColor* )textColor labelFont:(UIFont *)font{
    NSString* string = [NSString stringWithFormat:@"%@",text];
    CGFloat width = string.length*font.pointSize;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width, 32)];
    label.font = font;
    label.text = string;
    label.textColor = textColor;
    return label;
}


-(void)autoLoginBack{
    NSDictionary *parameters = @{};
    
    NSString* url = @"wallet/balance";
    
//    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"GetMoneyBack"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [self setAccountInfo:data];
                [self showGuestureSettingView];
            }else{
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
            
        }
    }];
}

-(void)showGuestureSettingView{
    NSString* url = @"account/has_gesture";
    NSDictionary* params = @{};
    [[HttpRequest getInstance] getWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                if([[[data objectForKey:@"data"] objectForKey:@"has_gesture"] boolValue]){
                    //已经设置过手势密码
                    SetPasswordViewController* vc = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
                    [vc setTitle:@"输入手势密码"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self getTempVerify];
                }
            }
        }
    }];
}



-(void)getTempVerify{
    NSString* url = @"account/veritypwd";
    NSDictionary* params = @{@"password":[GameData getUserPassword]};
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSString* temp = [[data objectForKey:@"data"] objectForKey:@"verity_token"];
                
                [[AppData getInstance] setTempVerify:temp];
                
                SetPasswordViewController *vc = [[SetPasswordViewController alloc] init];
                [vc setTitle:@"设置手势密码"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
    
}

-(void)setAccountInfo:(NSDictionary*)data{
    
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];

    NSString* username = [GameData getUserAccount];
    NSString* showname = @"";
    if([username containsString:@"@"]){
        showname = username;
    }else{
        showname = [showname stringByAppendingString:[username substringWithRange:NSMakeRange(0, 3)]];
        showname = [showname stringByAppendingString:@"****"];
        showname = [showname stringByAppendingString:[username substringFromIndex:7]];
    }

    _usernameLabel.text = showname;
    
    NSNumber* rest = [data objectForKey:@"ret"];
    if([rest intValue] == 1){
        
        NSDictionary* datainfo = [data objectForKey:@"data"];
//        NSLog(@"exchange = %@",data);
        
        NSString* cny = [datainfo objectForKey:@"total_cny"];
        self.exchangeRMBLabel.text = cny;
        
        NSString* usd = [datainfo objectForKey:@"total_usd"];
        
        self.exchangeUSDLabel.text = [NSString stringWithFormat:@"$%@",usd];

        self.shopRMBLabel.text = cny;
        
        self.shopUSDLabel.text = [NSString stringWithFormat:@"$%@",usd];
        
    }
//
//    NSString* shopUSD = [[exchange objectForKey:@"USD"] objectForKey:@"available"];
//
//    self.shopUSDLabel.text = [NSString stringWithFormat:@"$%@",shopUSD];
}

- (void)viewWillAppear:(BOOL)animated{
    //    NSLog(@"viewWillAppear");
    [self.navigationController setNavigationBarHidden:YES];
    
    [SocketInterface sharedManager].delegate = self;
    [[SocketInterface sharedManager] openWebSocket];
    
    if(_marqueeView){
        [_marqueeView removeFromSuperview];
        _marqueeView = nil;
    }
    self.updateIndex = 0;
    [self.stockName removeAllObjects];
    
    NSString* url1 = @"news/home";
    NSDictionary* parameters1 = @{};
//    [[HttpRequest getInstance] getWithUrl:url notification:@"FirstTipAndAds"];
    [[HttpRequest getInstance] getWithURL:url1 parma:parameters1 block:^(BOOL success, id data) {
        if(success){
            [self getTipsAndAdsBack:data];
        }
    }];
    
    
    
    [self requestAllData];
    
}

-(void)requestAllData{
    
    self.updateIndex = 0;
    [self.stockName removeAllObjects];
    
    NSDictionary* parameters2 = @{@"market":@""};
    NSString* url2 = @"market/search";
    //
    [[HttpRequest getInstance] getWithURL:url2 parma:parameters2 block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
//                NSLog(@"股市数据:%@",data);
                NSDictionary* market = [data objectForKey:@"data"];
                
                if(market.count>0){
                    NSArray* result = [market objectForKey:@"market"];
                    if(result.count >0){
                        [self.stockName removeAllObjects];
                        for (int i=0; i<result.count; i++) {
                            
                            NSDictionary* info = result[i];
                            [self.stockName addObject:info];
                        
                        }
                        [_randList reloadData];
                        [self requestStockInfo:self.updateIndex];
                    }
                }
            }
        }
    }];
}

-(void)requestStockInfo:(NSInteger)index{
    NSLog(@"更新index = %ld,************%ld",index,self.stockName.count);
//    if(index >= self.stockName.count){
//        NSLog(@"*********更新结束*********");
//        NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
//        //
//        NSString *strAll = [dicAll JSONString];
//        [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
//        [_randList reloadData];
//
//        [self performSelector:@selector(requestAllData) withObject:nil afterDelay:2.0];
//
//        return;
//    }
    NSDictionary* info = self.stockName[index];
    NSMutableArray* names = [NSMutableArray new];
    for(NSDictionary* data in self.stockName){
        [names addObject:[data objectForKey:@"market"]];
        
    }
    NSString* name = [info objectForKey:@"market"];
//    NSLog(@"更新name = %@",name);
    NSArray *dicParma = names;
//    NSArray* dicParma = @[@"LDGFHUWEI"];
    NSDictionary *dicAll = @{@"method":@"state.subscribe",@"params":dicParma,@"id":@(PN_StateSubscribe)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.subscribe"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getTipsAndAdsBack:(NSDictionary* )data{
    
//    [self createAutoRunLabel:@"" view:self.adView fontsize:30];
//    NSLog(@"data = %@",data);
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1)
    {
        NSDictionary* info = [data objectForKey:@"data"];
//        NSLog(@"首页广告:%@",info);
        NSArray *ads = data[@"data"][@"ads"];
        [self refreshAdView:ads];
        NSArray* tips = data[@"data"][@"tips"];
        
        [self.tipsContent removeAllObjects];
        [self.tipsTitle removeAllObjects];
        for (NSDictionary* tip in tips) {
            NSString* text = [tip objectForKey:@"content"];
            NSString* title = [tip objectForKey:@"title"];
//            NSLog(@"text = %@,  title = %@",text,title);
            [self.tipsTitle addObject:title];
            [self.tipsContent addObject:text];
        }
        if(self.tipsTitle.count>0){
//            [self createAutoRunLabel:self.tipsContent[0] view:self.autoRunActivityView fontsize:14 withTag:0];
            if(_marqueeView){
                [_marqueeView removeFromSuperview];
                _marqueeView = nil;
            }
            [self.autoRunActivityView addSubview:self.marqueeView];
        }
        
    }
    
}

- (MarqueeView *)marqueeView{
    if (!_marqueeView) {
        MarqueeView *marqueeView =[[MarqueeView alloc]initWithFrame:CGRectMake(10, 0, self.autoRunActivityView.width-15, self.autoRunActivityView.height) withTitle:self.tipsTitle];
        marqueeView.titleColor = kColor(102, 102, 102);
        marqueeView.titleFont = [UIFont systemFontOfSize:14];
        marqueeView.backgroundColor = [UIColor clearColor];
        __weak MarqueeView *marquee = marqueeView;
        marqueeView.handlerTitleClickCallBack = ^(NSInteger index){
            
            NSLog(@"%@----%zd",marquee.titleArr[index-1],index);
            
            MarqueeContentViewController* vc = [[MarqueeContentViewController alloc] initWithNibName:@"MarqueeContentViewController" bundle:nil];
            vc.title = marquee.titleArr[index-1];
            
            [self.navigationController pushViewController:vc animated:YES];
            if(self.tipsContent.count>= index){
                vc.block = ^{
                    vc.contentTextView.text = self.tipsContent[index-1];
                };
            }
            
        };
        _marqueeView = marqueeView;
    }
    return _marqueeView;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //返回白色
    return UIStatusBarStyleLightContent;
    //返回黑色
    //return UIStatusBarStyleDefault;
}

- (IBAction)clickExchange:(id)sender {
    [self.navigationController setNavigationBarHidden:NO];
    ExchangeViewController *vc = [[ExchangeViewController alloc] initWithNibName:@"ExchangeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickBusiness:(id)sender {
    
    [self.navigationController setNavigationBarHidden:NO];
    Business_ViewController *vc = [[Business_ViewController alloc] initWithNibName:@"Business ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickUserInfo:(id)sender {
    
    [self.navigationController setNavigationBarHidden:NO];
    UserInfoViewController *vc = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshAdView:(NSArray*)ads{
    //
    NSMutableArray *images = [NSMutableArray new];
    //parse
    //    NSArray *ads = data[@"data"][@"ads"];
    for (NSDictionary *dic in ads) {
        NSString*img = dic[@"img"];
        [images addObject:img];
    }
    //view
    if(nil==_adScrollView){
        _adScrollView = [TCRotatorImageView rotatorImageViewWithFrame:self.adView.bounds imageURLStrigArray:images placeholerImage:nil];
        _adScrollView.pageControll.hidden = YES;
//        _adScrollView.rotateTimeInterval = 3.0f;
        [self.adView addSubview:_adScrollView];
        WeakSelf(weakSelf)
        _adScrollView.clickBlock = ^(NSInteger index){
            //循环引用
            //            [weakSelf xxxx];
            [weakSelf.navigationController setNavigationBarHidden:NO];
            AdsViewController* vc = [[AdsViewController alloc] initWithNibName:@"AdsViewController" bundle:nil];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        };
    }else{
        _adScrollView.imageURLStrigArray = images;
        [_adScrollView reloadData];
    }
}

#pragma mark -SocketDelegates
-(void)getWebData:(id)message withName:(NSString *)name{
    NSString* str = message;
    NSData* strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
    
//    int requestID = [[data objectForKey:@"id"] intValue];
//    NSLog(@"应答消息:%@,消息体为:%@",name,data);
    if ([name isEqualToString:@"state.update"]){
        NSArray* params = [data objectForKey:@"params"];
        
        if(params.count == 2){
            
            NSDictionary* info = params[1];
//            NSLog(@"获得数据:%ld************%@",params.count,info);
            NSString* open = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"open"] floatValue]];
            NSString* price =[NSString stringWithFormat:@"%.4f",[[info objectForKey:@"last"] floatValue]];
            float rate = ([open floatValue] == 0)?0:([price floatValue])/([open floatValue])-1;
            
            NSString* name = params[0];
//            NSLog(@"name = %@ 涨幅 = %f",name,rate);
            
            [self addRateToArray:name withRate:[NSString stringWithFormat:@"%f",rate*100] withPrice:price];
            
//            NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
//
//            NSString *strAll = [dicAll JSONString];
//            [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
            
//            self.updateIndex++;
//            [self requestStockInfo:self.updateIndex];
            
        }
        
    }
}

-(void)addRateToArray:(NSString*) name withRate:(NSString* )rate withPrice:(NSString*)price{
    
    for (NSMutableDictionary* info in self.stockName) {
        if([[info objectForKey:@"market"] isEqualToString:name]){
            [info setObject:rate forKey:@"rate"];
            [info setObject:price forKey:@"last"];
            break;
        }
    }
    
    
    
    NSMutableArray* temp = [NSMutableArray new];
    
    while (self.stockName.count>0) {
        NSInteger index = 0;
        NSString* rate = [self.stockName[0] objectForKey:@"rate"];
        float ratevalue = 0;
        if(rate){
            ratevalue = [rate floatValue];
        }
        
        for (int j=1; j<self.stockName.count; j++) {
            NSString* rate1 = [self.stockName[j] objectForKey:@"rate"];
            float ratevalue1 = 0;
            if(rate1){
                ratevalue1 = [rate1 floatValue];
            }
            
            if(ratevalue1>ratevalue){
                ratevalue = ratevalue1;
                index = j;
            }
        }
        
        [temp addObject:self.stockName[index]];
        [self.stockName removeObjectAtIndex:index];
    }
    
    self.stockName = temp;
    [_randList reloadData];
    
    
}

#pragma mark -UITableVIewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stockName.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    indexPath.section
    //    indexPath.row
    //    if (indexPath.section == 0) {
    //        return 50;
    //    }
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FirstListTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
//    NSLog(@"indexPath.row = %ld,self.stockName = %ld",indexPath.row,self.stockName.count);
    if(self.stockName.count > indexPath.row){
        NSMutableDictionary* info = self.stockName[indexPath.row];
        
        cell.nameLabel.text = [info objectForKey:@"market"];
        float rate = [[info objectForKey:@"rate"] floatValue]*100;
        NSString* ratetext = [NSString stringWithFormat:@"%.2f%%",rate];
        cell.upOrDownRateLabel.text = ratetext;
        cell.priceLabel.text = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"last"] floatValue]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    FirstListTableViewCell *vc = [[ChargeDetailViewController alloc] initWithNibName:@"FirstListTableViewCell" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
    FirstListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell){

        NSString* name = cell.nameLabel.text;
        StockLittleViewController* vc = [[StockLittleViewController alloc] initWithNibName:@"StockLittleViewController" bundle:nil];
        vc.title = name;
        [self.navigationController pushViewController:vc animated:YES];
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
