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
@interface UserFirstViewController ()<TTAutoRunLabelDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeRMBLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeUSDLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopRMBLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopUSDLabel;
@property (weak, nonatomic) IBOutlet UIView *autoRunActivityView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UITableView *randList;

@end

@implementation UserFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAccountInfo) name:@"GetMoneyBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoginBack) name:@"AutoLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTipsAndAdsBack) name:@"FirstTipAndAds" object:nil];
    
    
    NSString* username = [GameData getUserAccount];
    NSString* password = [GameData getUserPassword];
    NSLog(@"username = %@,password = %@",username,password);
    if([username containsString:@"@"]){
        //邮箱登录
        NSArray *parameters = @[ @{ @"name": @"email", @"value": [GameData getUserAccount] },
                                 @{ @"name": @"password", @"value": [GameData getUserPassword] },
                                 @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                                 @{ @"name": @"channel", @"value": @"0" } ];
        
        
        NSString* url = @"http://exchange-test.oneitfarm.com/server/account/login/email";
        [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"AutoLogin"];
    }else{
        //手机号登录
        NSArray *parameters = @[ @{ @"name": @"phone", @"value": [GameData getUserAccount] },
                                 @{ @"name": @"password", @"value": [GameData getUserPassword] },
                                 @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                                 @{ @"name": @"channel", @"value": @"0" } ];
        
        
        NSString* url = @"http://exchange-test.oneitfarm.com/server/account/login/phone";
        [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"AutoLogin"];
    }
    
    //
    
    self.randList.delegate = self;
    self.randList.dataSource = self;
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


-(void)autoLoginBack{
    NSArray *parameters = @[ @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                             @{ @"name": @"channel", @"value": @"0" } ];
    
    NSString* url = @"http://exchange-test.oneitfarm.com/server/wallet/balance";
    
    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"GetMoneyBack"];
}

-(void)setAccountInfo{
    
    NSDictionary* data = [[HttpRequest getInstance] httpBack];

    NSNumber* rest = [data objectForKey:@"ret"];
    if([rest intValue] == 1){
        
        NSDictionary* exchange = [[data objectForKey:@"data"] objectForKey:@"exchange"];
        NSLog(@"exchange = %@",exchange);
        
        NSString* exchangeRMB = [[exchange objectForKey:@"RMB"] objectForKey:@"available"];
        self.exchangeRMBLabel.text = exchangeRMB;
        
        NSString* exchangeUSD = [[exchange objectForKey:@"USD"] objectForKey:@"available"];
        
        self.exchangeUSDLabel.text = [NSString stringWithFormat:@"$%@",exchangeUSD];
        
        NSDictionary* shop = [[data objectForKey:@"data"] objectForKey:@"shop"];
        NSLog(@"shop = %@",shop);
        
    }
    
    
    
//    NSString* shopRMB = [[exchange objectForKey:@"RMB"] objectForKey:@"available"];
//    self.shopRMBLabel.text = shopRMB;
//
//    NSString* shopUSD = [[exchange objectForKey:@"USD"] objectForKey:@"available"];
//
//    self.shopUSDLabel.text = [NSString stringWithFormat:@"$%@",shopUSD];
}

- (void)viewWillAppear:(BOOL)animated{
    //    NSLog(@"viewWillAppear");
    [self.navigationController setNavigationBarHidden:YES];
    NSString* url = @"http://exchange-test.oneitfarm.com/server/news/home?appkey=5yupjrc7tbhwufl8oandzidjyrmg6blc&channel=0";
    [[HttpRequest getInstance] getWithUrl:url notification:@"FirstTipAndAds"];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getTipsAndAdsBack{
    [self createAutoRunLabel:@"" view:self.autoRunActivityView fontsize:14];
    [self createAutoRunLabel:@"" view:self.adView fontsize:30];
    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1)
    {
        NSDictionary* info = [data objectForKey:@"data"];
        NSLog(@"首页广告:%@",info);
    }
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

#pragma mark -UITableVIewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
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
    
    FirstListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FirstListTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    FirstListTableViewCell *vc = [[ChargeDetailViewController alloc] initWithNibName:@"FirstListTableViewCell" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
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
