//
//  MailRegistViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/20.
//  Copyright © 2018年 try. All rights reserved.
//

#import "MailRegistViewController.h"
#import "RegistViewController.h"
#import "HttpRequest.h"
#import "HUDUtil.h"
#import "LoginViewController.h"

@interface MailRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mailInput;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *lookPwBtn;

@end

@implementation MailRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailRegisteBack) name:@"MailRegisteBack" object:nil];
    self.title =  @"注册";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"已有账户?" style:UIBarButtonItemStylePlain target:self action:@selector(clickLogin)];
    self.navigationItem.rightBarButtonItem = right;
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    _passwordInput.secureTextEntry = YES;
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)clickLogin{
    for (UIViewController*vc in self.navigationController.childViewControllers) {
        if([vc isKindOfClass:[LoginViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

-(void)test{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickPhoneRegist:(id)sender {
    RegistViewController *vc = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickMailRegist:(id)sender {
    if(self.mailInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入邮箱"];
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
    
    NSDictionary *parameters = @{ @"email": self.mailInput.text,
                                  @"captcha": self.verifyInput.text,
                                  @"password": self.passwordInput.text};
    
    
    NSString* url = @"register/email";
    
//    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"MailRegisteBack"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [self mailRegisteBack:data];
        }
    }];
}

-(void)mailRegisteBack:(NSDictionary*)data{
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
