//
//  MailLoginViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/5.
//  Copyright © 2018年 try. All rights reserved.
//

#import "MailLoginViewController.h"
#import "ResetPasswordViewController.h"
#import "HttpRequest.h"
#import "HUDUtil.h"
#import "GameData.h"
@interface MailLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput
;

@end

@implementation MailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailLoginBack) name:@"MailLoginBack" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickLogin:(id)sender {
    if(![self.mailInput.text containsString:@"@"]){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入正确的邮箱"];
        return;
    }
    
    if(self.passwordInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入密码"];
        return;
    }
    
    NSArray *parameters = @[ @{ @"name": @"email", @"value": self.mailInput.text },
                             @{ @"name": @"password", @"value": self.passwordInput.text },
                             @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                             @{ @"name": @"channel", @"value": @"0" } ];
    
    
    NSString* url = @"http://exchange-test.oneitfarm.com/server/account/login/email";
    
    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"MailLoginBack"];
    
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"登陆中……"];
}
- (IBAction)clickPhoneLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickForgetPassword:(id)sender {
    ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)mailLoginBack{
    [HUDUtil hideHudView];
    
    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    
    NSNumber* number = [data objectForKey:@"ret"];
    if([number intValue] == 1){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"登陆成功"];
        [GameData setUserAccount:self.mailInput.text];
        [GameData setUserPassword:self.passwordInput.text];
        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setBool:YES forKey:@"IsLogin"];
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
    }else{
        //登陆失败
        [HUDUtil showSystemTipView:self title:@"提示" withContent:[data objectForKey:@"msg"]];
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
