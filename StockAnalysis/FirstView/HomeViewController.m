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
@interface HomeViewController ()<TTAutoRunLabelDelegate,UITableViewDataSource,UITableViewDelegate,SocketDelegate>

@property (weak, nonatomic) IBOutlet UIView *activityContainer;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UITableView *randList;
@property (nonatomic,strong) TCRotatorImageView *adScrollView;

@property (nonatomic,strong) NSMutableArray* stockName;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTipsAndAdsBack) name:@"FirstTipAndAds" object:nil];
//    [[SocketInterface sharedManager] openWebSocket];
    [SocketInterface sharedManager].delegate = self;
    self.stockName =  [NSMutableArray new];
    self.randList.delegate = self;
    self.randList.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
//    NSLog(@"viewWillAppear");
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    NSString* url = @"news/home";
    
    NSDictionary* parameters = @{};
//    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithDictionary:para];
    
//    [[HttpRequest getInstance] getWithUrl:url notification:@"FirstTipAndAds"];
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [self getTipsAndAdsBack:data];
        }
    }];
    
    NSDictionary* parameters1 = @{@"market":@""};
    NSString* url1 = @"market/search";
//
    [[HttpRequest getInstance] getWithURL:url1 parma:parameters1 block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSLog(@"股市数据:%@",data);
                NSDictionary* market = [data objectForKey:@"data"];
            
                if(market.count>0){
                    NSArray* result = [market objectForKey:@"market"];
                    if(result.count >0){
                        [self.stockName removeAllObjects];
                        for (int i=0; i<result.count; i++) {
                            
                            NSDictionary* info = result[i];
                            [self.stockName addObject:info];
                            
                            NSString* name = [info objectForKey:@"market"];
                            NSArray *dicParma = @[name
                                                  ];
                            NSDictionary *dicAll = @{@"method":@"state.subscribe",@"params":dicParma,@"id":@(PN_StateSubscribe)};
                            
                            NSString *strAll = [dicAll JSONString];
                            
                            [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.subscribe"];
                            
                        }
                        
                        [_randList reloadData];
                    }
                }
            }
        }
    }];
    
}

-(void)getTipsAndAdsBack:(NSDictionary*)data{
    [self createAutoRunLabel:@"" view:self.activityContainer fontsize:14];
//    [self createAutoRunLabel:@"" view:self.adView fontsize:30];
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1)
    {
        NSDictionary* info = [data objectForKey:@"data"];
        NSLog(@"首页广告:%@",info);
    }
    
    NSArray *ads = data[@"data"][@"ads"];
    [self refreshAdView:ads];
}


- (void)viewDidAppear:(BOOL)animated{
//    NSLog(@"viewdidappear");
    
}

-(void)createAutoRunLabel:(NSString *)content view:(UIView* )contentview fontsize:(int)size{
    content = @"繁华声 遁入空门 折煞了梦偏冷 辗转一生 情债又几 如你默认 生死枯等 枯等一圈 又一圈的 浮图塔 断了几层 断了谁的痛直奔 一盏残灯 倾塌的山门 容我再等 历史转身 等酒香醇 等你弹 一曲古筝";
    TTAutoRunLabel* runLabel = [[TTAutoRunLabel alloc] initWithFrame:CGRectMake(contentview.frame.size.width*0.05, contentview.frame.size.height*0.1, contentview.frame.size.width*0.95, contentview.frame.size.height)];
    runLabel.delegate = self;
    runLabel.directionType = Leftype;
    //    [runLabel setRunViewColor:[UIColor colorWithRed:16./255.0 green:142.0/255.0 blue:233.0/255.0 alpha:0.1]];
    [contentview addSubview:runLabel];
    [runLabel addContentView:[self createLabelWithText:content textColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] labelFont:[UIFont systemFontOfSize:size]]];
    [runLabel startAnimation];
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
    
    if ([name isEqualToString:@"state.update"]){
        
//        NSDictionary*
//        NSLog(@"data = %@",data);
        NSArray* params = [data objectForKey:@"params"];
        if(params.count == 2){
            NSDictionary* info = params[1];
            //            NSLog(@"info = %@",info);
            NSString* open = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"open"] floatValue]];
            NSString* price =[NSString stringWithFormat:@"%.4f",[[info objectForKey:@"last"] floatValue]];
            float rate = ([price floatValue])/([open floatValue])-1;
            
            NSString* name = params[0];
            NSLog(@"name = %@ 涨幅 = %f",name,rate);
            [self addRateToArray:name withRate:[NSString stringWithFormat:@"%f",rate] withPrice:price];
            
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
    for (NSMutableDictionary* info in self.stockName) {
        float ratedata = [[info objectForKey:@"rate"] floatValue];
        if(temp.count == 0){
            [temp setObject:info atIndexedSubscript:0];
        }else{
            for (int i=0;i<temp.count;i++){
                NSMutableDictionary* lastinfo =temp[i];
                float lastrate = [[lastinfo objectForKey:@"rate"] floatValue];
                if(ratedata<lastrate){
                    [temp setObject:info atIndexedSubscript:i+1];
                    break;
                }
            }
        }
    }
    
    if(temp.count == self.stockName.count){
        [self.stockName removeAllObjects];
        self.stockName = temp;
        
        NSDictionary *dicAll = @{@"method":@"state.unsubscribe",@"params":@[],@"id":@(PN_StateUnsubscribe)};
        
        NSString *strAll = [dicAll JSONString];
        [[SocketInterface sharedManager] sendRequest:strAll withName:@"state.unsubscribe"];
        [_randList reloadData];
    }
    
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
    
                                    
    NSMutableDictionary* info = self.stockName[indexPath.row];
    
    cell.nameLabel.text = [info objectForKey:@"market"];
    float rate = [[info objectForKey:@"rate"] floatValue]*100;
    NSString* ratetext = [NSString stringWithFormat:@"%.2f%%",rate];
    cell.upOrDownRateLabel.text = ratetext;
    cell.priceLabel.text = [NSString stringWithFormat:@"%.4f",[[info objectForKey:@"last"] floatValue]];
    
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
