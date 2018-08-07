//
//  LoginViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ResetPasswordViewController.h"
#import "XWCountryCodeController.h"
#import "MailRegistViewController.h"
#import "HUDUtil.h"
#import "HttpRequest.h"
#import "MailLoginViewController.h"
#import "GameData.h"
@interface LoginViewController ()<XWCountryCodeControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UIButton *lookPwBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"注册账户" style:UIBarButtonItemStylePlain target:self action:@selector(clickRegist:)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.title = @"登录";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneLoginSuccess) name:@"LoginSuccess" object:nil];
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    self.passwordInput.secureTextEntry = YES;
    
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];

    
}

-(void)test{
    [self.view endEditing:YES];
}

-(void)phoneLoginSuccess{
    [HUDUtil hideHudView];
    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* number = [data objectForKey:@"ret"];
    if([number intValue] == 1){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"登陆成功"];
        
        [GameData setUserAccount:self.usernameInput.text];
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
- (IBAction)clickMailRegist:(id)sender {
    MailLoginViewController *vc = [[MailLoginViewController alloc] initWithNibName:@"MailLoginViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickLoginIn:(id)sender {
    if(self.usernameInput.text.length != 11){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入正确的手机号"];
        return;
    }
    
    if(self.passwordInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入密码"];
        return;
    }
    /*
    NSArray *parameters = @[ @{ @"name": @"phone", @"value": self.usernameInput.text },
                             @{ @"name": @"password", @"value": self.passwordInput.text },
                             @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                             @{ @"name": @"channel", @"value": @"0" } ];
    NSString* url = @"http://exchange-test.oneitfarm.com/server/account/login/phone";
    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"LoginSuccess"];*/
    
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"登陆中……"];
    
    NSString* url = @"account/login/phone";
    NSDictionary *paramDic = @{ @"phone":self.usernameInput.text,@"password":self.passwordInput.text};
    
//    NSMutableDictionary* paramDic = [[NSMutableDictionary alloc] initWithDictionary:param];
    
    [[HttpRequest getInstance] postWithURL:url parma:paramDic block:^(BOOL success, id data) {
        if(success){
            //这里把判断ret才能知道是否正确登陆。
//            [self phoneLoginSuccess];
//            NSDictionary* info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil ];
            NSLog(@"登录消息：%@",data);
            NSNumber* number = [data objectForKey:@"ret"];
            if([number intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"登陆成功"];
                
                [GameData setUserAccount:self.usernameInput.text];
                [GameData setUserPassword:self.passwordInput.text];
                
                NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                [defaultdata setBool:YES forKey:@"IsLogin"];
                
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
            }else{
                //登陆失败
                [HUDUtil showSystemTipView:self title:@"提示" withContent:[data objectForKey:@"msg"]];
            }
        }else{
            [HUDUtil hideHudViewWithFailureMessage:@"登陆失败"];
        }
    }];
}

-(void)clickRegist:(id)sender{
    DLog(@"clickRegist");
    
    RegistViewController *vc = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickForgetPassword:(id)sender {
    ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
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

    [self.navigationController pushViewController:countrycodeVC animated:YES];
}
- (IBAction)clickLookPw:(id)sender {
    
    if (!_lookPwBtn.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.passwordInput.text;
        self.passwordInput.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordInput.secureTextEntry = NO;
        self.passwordInput.text = tempPwdStr;
        [_lookPwBtn setSelected:YES];
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.passwordInput.text;
        self.passwordInput.text = @"";
        self.passwordInput.secureTextEntry = YES;
        self.passwordInput.text = tempPwdStr;
        [_lookPwBtn setSelected:NO];
    }
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
