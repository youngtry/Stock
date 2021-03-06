//
//  HomeViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/19.
//  Copyright © 2018年 try. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "TTAutoRunLabel.h"
#import "FirstListTableViewCell.h"
#import "HttpRequest.h"
#import "TCRotatorImageView.h"
#import "SocketInterface.h"
#import "StockLittleViewController.h"
#import "AdsViewController.h"
#import "MarqueeView.h"
#import "MarqueeContentViewController.h"
@interface HomeViewController ()<TTAutoRunLabelDelegate,UITableViewDataSource,UITableViewDelegate,SocketDelegate>

@property (weak, nonatomic) IBOutlet UIView *activityContainer;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UITableView *randList;
@property (nonatomic,strong) TCRotatorImageView *adScrollView;

@property (nonatomic,strong) NSMutableArray* stockName;
@property (nonatomic,strong) TTAutoRunLabel* runLabel;
@property (nonatomic,strong) NSMutableArray* tipsTitle;
@property (nonatomic,strong) NSMutableArray* tipsContent;

@property (nonatomic, strong) MarqueeView *marqueeView;

@property (nonatomic, assign) NSInteger updateIndex;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTipsAndAdsBack) name:@"FirstTipAndAds" object:nil];
    
    self.stockName =  [NSMutableArray new];
    self.randList.delegate = self;
    self.randList.dataSource = self;
    self.tipsTitle = [NSMutableArray new];
    self.tipsContent = [NSMutableArray new];
    self.updateIndex = 0;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_runLabel stopAnimation];
    [_runLabel removeFromSuperview];
    _runLabel = nil;
    
    NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
    //
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestStockAllData) object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
//    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    [SocketInterface sharedManager].delegate = self;
    [[SocketInterface sharedManager] openWebSocket];
    if(_marqueeView){
        [_marqueeView removeFromSuperview];
        _marqueeView = nil;
    }
    
    NSString* url = @"news/home";
    
    NSDictionary* parameters = @{};
//    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithDictionary:para];
    
//    [[HttpRequest getInstance] getWithUrl:url notification:@"FirstTipAndAds"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [weakSelf getTipsAndAdsBack:data];
        }
    }];
    
    
    [self requestStockAllData];
}

-(void)requestStockAllData{
    
    self.updateIndex = 0;
    [self.stockName removeAllObjects];
    
    NSDictionary* parameters1 = @{@"market":@""};
    NSString* url1 = @"market/search";
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] getWithURL:url1 parma:parameters1 block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
//                NSLog(@"股市数据:%@",data);
                NSDictionary* market = [data objectForKey:@"data"];
                
                if(market.count>0){
                    NSArray* result = [market objectForKey:@"market"];
                    if(result.count >0){
                        [weakSelf.stockName removeAllObjects];
                        for (int i=0; i<result.count; i++) {
                            
                            NSDictionary* info = result[i];
                            [weakSelf.stockName addObject:info];
                        }
                        [_randList reloadData];
                        [weakSelf requestStockInfo:weakSelf.updateIndex];
                    }
                }
            }
        }
    }];
}

-(void)requestStockInfo:(NSInteger)index{
    
//    if(index >= self.stockName.count){
//        NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
//        //
//        NSString *strAll = [dicAll JSONString];
//        [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
//        [_randList reloadData];
//
//        [self performSelector:@selector(requestStockAllData) withObject:nil afterDelay:2.0];
//
//        return;
//    }
    NSDictionary* info = self.stockName[index];
    NSString* name = [info objectForKey:@"market"];
    NSMutableArray* names = [NSMutableArray new];
    for(NSDictionary* data in self.stockName){
        [names addObject:[data objectForKey:@"market"]];
        
    }
    NSArray *dicParma = names;
    NSDictionary *dicAll = @{@"method":@"state.subscribe",@"params":dicParma,@"id":@(PN_StateSubscribe)};
    
    NSString *strAll = [dicAll JSONString];
    [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.subscribe"];
}

-(void)getTipsAndAdsBack:(NSDictionary*)data{
//    [self createAutoRunLabel:@"" view:self.activityContainer fontsize:14];
//    [self createAutoRunLabel:@"" view:self.adView fontsize:30];
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1)
    {
        NSDictionary* info = [data objectForKey:@"data"];
        //        NSLog(@"首页广告:%@",info);
        NSArray *ads = data[@"data"][@"ads"];
        if(ads.count>0){
            [self refreshAdView:ads];
        }
        
        NSArray* tips = data[@"data"][@"tips"];
        if(tips.count>0){
            [self.tipsContent removeAllObjects];
            [self.tipsTitle removeAllObjects];
            for (NSDictionary* tip in tips) {
                NSString* text = [tip objectForKey:@"content"];
                NSString* title = [tip objectForKey:@"title"];
                //            NSLog(@"text = %@,  title = %@",text,title);
                [self.tipsTitle addObject:title];
                [self.tipsContent addObject:text];
            }
        }
        
        if(self.tipsTitle.count>0){
            //            [self createAutoRunLabel:self.tipsContent[0] view:self.autoRunActivityView fontsize:14 withTag:0];
            if(_marqueeView){
                [_marqueeView removeFromSuperview];
                _marqueeView = nil;
            }
            [self.activityContainer addSubview:self.marqueeView];
        }
    }else{
        
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
        
    }
    
}

- (MarqueeView *)marqueeView{
    if (!_marqueeView) {
        MarqueeView *marqueeView =[[MarqueeView alloc]initWithFrame:CGRectMake(10, 0, self.activityContainer.width-15, self.activityContainer.height) withTitle:self.tipsTitle];
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

#pragma mark TTAutoRunLabelDelegate

-(void)operateLabel:(TTAutoRunLabel *)autoLabel animationDidStopFinished:(BOOL)finished{
//    NSLog(@"autoLabel = %ld",autoLabel.contentTag);
    [autoLabel stopAnimation];
    if(autoLabel.contentTag<self.tipsContent.count-1){
        [self createAutoRunLabel:self.tipsTitle[autoLabel.contentTag+1] view:self.activityContainer fontsize:14 withTag:autoLabel.contentTag+1];
    }else{
        [self createAutoRunLabel:self.tipsTitle[0] view:self.activityContainer fontsize:14 withTag:0];
    }
}
- (void)viewDidAppear:(BOOL)animated{
//    NSLog(@"viewdidappear");
    
}

-(void)createAutoRunLabel:(NSString *)content view:(UIView* )contentview fontsize:(int)size withTag:(NSInteger) tag{
//    content = @"繁华声 遁入空门 折煞了梦偏冷 辗转一生 情债又几 如你默认 生死枯等 枯等一圈 又一圈的 浮图塔 断了几层 断了谁的痛直奔 一盏残灯 倾塌的山门 容我再等 历史转身 等酒香醇 等你弹 一曲古筝";
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
    [_runLabel addContentView:[self createLabelWithText:content textColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] labelFont:[UIFont systemFontOfSize:size]]];
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

- (IBAction)LoginCallback:(id)sender {
    [self.navigationController setNavigationBarHidden:NO];
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    //返回白色
    return UIStatusBarStyleLightContent;
    //返回黑色
    //return UIStatusBarStyleDefault;
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
        _adScrollView.rotateTimeInterval = 10.0f;
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
    if(nil == message && [name isEqualToString:@"closed"]){
        //断开链接了
        [[SocketInterface sharedManager] openWebSocket];
        [SocketInterface sharedManager].delegate = self;
        
        [self requestStockInfo:self.updateIndex];
        return;
    }
    NSString* str = message;
    NSData* strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
    
//    int requestID = [[data objectForKey:@"id"] intValue];
    
    if ([name isEqualToString:@"state.update"]){
        
//        NSDictionary*
//        NSLog(@"data = %@",data);
        NSArray* params = [data objectForKey:@"params"];
        if(params.count == 2){
            NSDictionary* info = params[1];
            //            NSLog(@"info = %@",info);
            NSString* open = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"open"] floatValue]];
            NSString* price =[NSString stringWithFormat:@"%.4f",[[info objectForKey:@"last"] floatValue]];
            float rate = ([open floatValue] == 0)?0:([price floatValue])/([open floatValue])-1;
            
            NSString* name = params[0];
//            NSLog(@"name = %@ 涨幅 = %f",name,rate);
            [self addRateToArray:name withRate:[NSString stringWithFormat:@"%f",rate*100] withPrice:price];
            
//            NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
//            //
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
    
    if(self.stockName.count>indexPath.row){
        NSMutableDictionary* info = self.stockName[indexPath.row];
        
        cell.nameLabel.text = [info objectForKey:@"market"];
        float rate = [[info objectForKey:@"rate"] floatValue];
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
        //        id temp = self.parentViewController.view.selfViewController.navigationController;
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
