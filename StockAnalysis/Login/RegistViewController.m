//
//  RegistViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import "RegistViewController.h"
#import "XWCountryCodeController.h"
#import "MailRegistViewController.h"
#import "HttpRequest.h"
@interface RegistViewController ()<XWCountryCodeControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickMainRegist:(id)sender {
    MailRegistViewController *vc = [[MailRegistViewController alloc] initWithNibName:@"MailRegistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)clickCountryCode:(id)sender {
    
    XWCountryCodeController* countrycodeVC = [[XWCountryCodeController alloc] init];
    countrycodeVC.deleagete = self;
    [countrycodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        NSLog(@"countryCodeStr = %@",countryCodeStr);
        countryCodeStr = [countryCodeStr substringFromIndex:[countryCodeStr rangeOfString:@"+"].location];
        NSLog(@"countryCodeStr = %@",countryCodeStr);
        [self.countryCodeButton.titleLabel setText:countryCodeStr];
    }];
    
    [self presentViewController:countrycodeVC animated:YES completion:nil];
    
}
- (IBAction)clickGetVerify:(id)sender {
    
    NSString* url = @"https://www.oneitfarm.com/api-tool/mockserver.php/app/vfe35iuoyzqkcn0fijglprsbdrmoakch/captcha/phone";
    NSDictionary* params = @{@"phone":@"+8617751766214",
                             };
    [[HttpRequest getInstance] getWithUrl:url data:params];
}
//1.代理传值
#pragma mark - XWCountryCodeControllerDelegate
-(void)returnCountryCode:(NSString *)countryCode{
    
    countryCode = [countryCode substringFromIndex:[countryCode rangeOfString:@"+"].location];
    NSLog(@"countryCode = %@",countryCode);
    [self.countryCodeButton.titleLabel setText:countryCode];
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
