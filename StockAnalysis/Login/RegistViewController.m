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
#import "HUDUtil.h"
#import "LoginViewController.h"
@interface RegistViewController ()<XWCountryCodeControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneInput;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *lookPwBtn;
@property (weak, nonatomic) IBOutlet UILabel *distrcLabel;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =  @"注册";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeBack) name:@"RegisteBack" object:nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"已有账户?" style:UIBarButtonItemStylePlain target:self action:@selector(clickLogin)];
    self.navigationItem.rightBarButtonItem = right;
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    self.passwordInput.secureTextEntry = YES;
    
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
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
    
}

-(void)clickLogin{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)test{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        self.distrcLabel.text = countryCodeStr;
    }];
    
    [self.navigationController pushViewController:countrycodeVC animated:YES];
    
}
- (IBAction)clickGetVerify:(id)sender {
   
    //测试用
 
//    NSDictionary *parameters = @{  @"phone": @"17751766215",
//                                          @"captcha": @"8888",
//                                          @"password": @"123456" ,
//                                          @"district": @"+86"} ;
////    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithDictionary:para];
//
//    NSString* url = @"register/phone";
//
//    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
//
//    }];
}
- (IBAction)clickPhoneRegiste:(id)sender {
    
    if(![VerifyRules phoneNumberIsTure:self.phoneInput.text]){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入正确的手机号"];
        return;
    }
    
    if(self.verifyInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入验证码"];
        return;
    }
    
    if(![VerifyRules passWordIsTure:self.passwordInput.text]){
        [HUDUtil showSystemTipView:self title:@"密码格式错误" withContent:@"请输入8-16个字符,不能使用中文、空格,至少含数字/字母/符号2种组合,必须要同时包括大小写字母"];
        return;
    }
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"注册中……"];
    NSDictionary *parameters = @{ @"phone": self.phoneInput.text ,
                                  @"captcha": self.verifyInput.text ,
                                  @"password": self.passwordInput.text ,
                                  @"district": self.distrcLabel.text};

    NSString* url = @"register/phone";

    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        [HUDUtil hideHudView];
        if(success){
            NSNumber* number = [data objectForKey:@"ret"];
            if([number intValue] == 1){
                //注册成功
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //注册失败
                [HUDUtil showSystemTipView:self title:@"提示" withContent:[data objectForKey:@"msg"]];
            }
        }
    }];
}

-(void)registeBack{
    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSLog(@"data = %@",data);
    NSNumber* number = [data objectForKey:@"ret"];
    if([number intValue] == -1){
        //注册失败
        [HUDUtil showSystemTipView:self title:@"提示" withContent:[data objectForKey:@"msg"]];
    }else if([number intValue] == 1){
        //注册成功
        for (UIViewController*vc in self.navigationController.childViewControllers) {
            if([vc isKindOfClass:[LoginViewController class]]){
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
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
