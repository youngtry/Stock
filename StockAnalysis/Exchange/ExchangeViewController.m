//
//  ExchangeViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/6/20.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ChargeViewController.h"
#import "AppData.h"
#import "HttpRequest.h"

@interface ExchangeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *RMBLabel;
@property (weak, nonatomic) IBOutlet UILabel *USDLabel;
@property (weak, nonatomic) IBOutlet UITableView *moneyList;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"交易账户";
    
    NSArray *parameters = @[ @{ @"name": @"type", @"value": @"exchange" },
                             @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                             @{ @"name": @"channel", @"value": @"0" } ];
    
    NSString* url = @"http://exchange-test.oneitfarm.com/server/wallet/balance";
    
    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"GetExchangeBack"];
    
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
- (IBAction)clickChargeButton:(id)sender {
//    [self.navigationController setNavigationBarHidden:NO];
    ChargeViewController *vc = [[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [[AppData getInstance] setExchangeButtonIndex:0];
}
- (IBAction)clickTixianButton:(id)sender {
    ChargeViewController *vc = [[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [[AppData getInstance] setExchangeButtonIndex:1];
}
- (IBAction)clickMoneyInOutButton:(id)sender {
}
- (IBAction)clickBillButton:(id)sender {
}
- (IBAction)hideZero:(id)sender {
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
