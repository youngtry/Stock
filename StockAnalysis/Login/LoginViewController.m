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
@property (weak, nonatomic) IBOutlet UILabel *distrcLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //添加顶栏注册入口
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Registe_Acc") style:UIBarButtonItemStylePlain target:self action:@selector(clickRegist:)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.title = Localize(@"Login");
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneLoginSuccess) name:@"LoginSuccess" object:nil];
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    self.passwordInput.secureTextEntry = YES;
    
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
    _lookPwBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
    
//    [self.countryCodeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.countryCodeButton.imageView.size.width-5, 0, self.countryCodeButton.imageView.size.width+5)];
//    [self.countryCodeButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.countryCodeButton.titleLabel.bounds.size.width+5, 0, -self.countryCodeButton.titleLabel.bounds.size.width-5)];
    
    self.distrcLabel.text = @"+86";
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self returnCountryCode:@"+86"];
    
//    [self.countryCodeButton setTitle:@"+86" forState:UIControlStateNormal];
}

-(void)test{
    [self.view endEditing:YES];
}

//手机号登录成功
-(void)phoneLoginSuccess{
    [HUDUtil hideHudView];
    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* number = [data objectForKey:@"ret"];
    if([number intValue] == 1){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:Localize(@"Login_Succ")];
        
        //设置登录数据
        [GameData setUserAccount:self.usernameInput.text];
        [GameData setUserPassword:self.passwordInput.text];
        [GameData setDistrict:self.distrcLabel.text];
        
        [GameData setAccountList:self.usernameInput.text withPassword:self.passwordInput.text withDistrict:self.distrcLabel.text];
        
        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setBool:YES forKey:@"IsLogin"];
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
    }else{
        //登陆失败
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:[data objectForKey:@"msg"]];
    }
    
}
//邮箱注册
- (IBAction)clickMailRegist:(id)sender {
    MailLoginViewController *vc = [[MailLoginViewController alloc] initWithNibName:@"MailLoginViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//登录
- (IBAction)clickLoginIn:(id)sender {
    if(![VerifyRules phoneNumberIsTure:self.usernameInput.text]){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Correct_Phone")];
        return;
    }
    if(![VerifyRules passWordIsTure:self.passwordInput.text]){
        [HUDUtil showSystemTipView:self title:Localize(@"Pwd_Error") withContent:Localize(@"Pwd_Error_Tip")];
        return;
    }
    
    [HUDUtil showHudViewInSuperView:self.view withMessage:Localize(@"Logining")];
    
    NSString* url = @"account/login/phone";
    NSDictionary *paramDic = @{ @"phone":self.usernameInput.text,
                                @"password":self.passwordInput.text,
                                @"district":self.distrcLabel.text
                                };

    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:paramDic block:^(BOOL success, id data) {
//        [HUDUtil hideHudView];
        if(success){
            //这里把判断ret才能知道是否正确登陆。
            NSLog(@"登录消息：%@",data);
            NSNumber* number = [data objectForKey:@"ret"];
            if([number intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:Localize(@"Login_Succ")];
                
                [GameData setUserAccount:weakSelf.usernameInput.text];
                [GameData setUserPassword:weakSelf.passwordInput.text];
                [GameData setDistrict:weakSelf.distrcLabel.text];
                [GameData setAccountList:weakSelf.usernameInput.text withPassword:weakSelf.passwordInput.text withDistrict:weakSelf.distrcLabel.text];
                
                [GameData setNeedNoticeGuesture:YES];
                
                NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                [defaultdata setBool:YES forKey:@"IsLogin"];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
            }else{
                [HUDUtil hideHudView];
                //登陆失败
                [HUDUtil showSystemTipView:weakSelf title:Localize(@"Menu_Title") withContent:[data objectForKey:@"msg"]];
            }
        }else{
            [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:Localize(@"Login_Fail")];
        }
    }];
}
//手机号注册
-(void)clickRegist:(id)sender{
    NSLog(@"clickRegist");
    
    RegistViewController *vc = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
//忘记密码
- (IBAction)clickForgetPassword:(id)sender {
    ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
//选择区号
- (IBAction)clickCountryCode:(id)sender {
    
    XWCountryCodeController* countrycodeVC = [[XWCountryCodeController alloc] init];
    countrycodeVC.deleagete = self;
    [countrycodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        NSLog(@"countryCodeStr = %@",countryCodeStr);
        countryCodeStr = [countryCodeStr substringFromIndex:[countryCodeStr rangeOfString:@"+"].location];
        NSLog(@"countryCodeStr = %@",countryCodeStr);
//        [self.countryCodeButton.titleLabel setText:countryCodeStr];
        self.distrcLabel.text = countryCodeStr;
    }];

    [self.navigationController pushViewController:countrycodeVC animated:YES];
}
//查看密码
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
//    [self.countryCodeButton.titleLabel setText:countryCode];
//    [self.countryCodeButton setTitle:countryCode forState:UIControlStateNormal];
    self.distrcLabel.text = countryCode;
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
