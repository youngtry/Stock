//
//  SetMoneyPasswordViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/2.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SetMoneyPasswordViewController.h"
#import "HttpRequest.h"

@interface SetMoneyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *moneyPassword;
@property (weak, nonatomic) IBOutlet UITextField *moneyAgainPassword;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (weak, nonatomic) IBOutlet UIButton *lookPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookPwdAgainBtn;

@end

@implementation SetMoneyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMoneyPasswordBack) name:@"SetMoneyPasswordBack" object:nil];
    self.title = @"设置资金密码";
    [_lookPwdBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookPwdBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
    [_lookPwdAgainBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookPwdAgainBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
    self.moneyPassword.secureTextEntry = YES;

    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
}

-(void)test{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickLookPassword:(id)sender {
    
    if (!_lookPwdBtn.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.moneyPassword.text;
        self.moneyPassword.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.moneyPassword.secureTextEntry = NO;
        self.moneyPassword.text = tempPwdStr;
        [_lookPwdBtn setSelected:YES];
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.moneyPassword.text;
        self.moneyPassword.text = @"";
        self.moneyPassword.secureTextEntry = YES;
        self.moneyPassword.text = tempPwdStr;
        [_lookPwdBtn setSelected:NO];
    }
}

- (IBAction)clickVerify:(id)sender {
}
- (IBAction)clickMailVerify:(id)sender {
    if (!_lookPwdAgainBtn.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.moneyAgainPassword.text;
        self.moneyAgainPassword.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.moneyAgainPassword.secureTextEntry = NO;
        self.moneyAgainPassword.text = tempPwdStr;
        [_lookPwdAgainBtn setSelected:YES];
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.moneyAgainPassword.text;
        self.moneyAgainPassword.text = @"";
        self.moneyAgainPassword.secureTextEntry = YES;
        self.moneyAgainPassword.text = tempPwdStr;
        [_lookPwdAgainBtn setSelected:NO];
    }
}
- (IBAction)clickResetPassword:(id)sender {
    if(self.moneyPassword.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入密码"];
        return;
    }
//    if(self.moneyAgainPassword.text.length == 0){
//        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入邮箱验证码"];
//        return;
//    }
    
    if(![self.moneyAgainPassword.text isEqualToString:self.moneyPassword.text]){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"两次输入不一致，请重新输入"];
        return;
    }
    
    if(self.verifyInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入验证码"];
        return;
    }
    
    NSDictionary *parameters = @{@"asset_password": self.moneyPassword.text,
                                 @"phone_captcha": self.verifyInput.text,
//                                 @"email_captcha": self.verifyInput.text
                                 };
    
    NSString* url = @"account/set_assetpwd";
    
//    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"SetMoneyPasswordBack"];
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            [self setMoneyPasswordBack:data];
        }
    }];
    
}

-(void)setMoneyPasswordBack:(NSDictionary* )data{
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1){
        //设置成功
        [self.navigationController popViewControllerAnimated:YES];
        
        NSString* msg = @"设置成功";
        
        [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:msg];
    }else{
        NSString* msg = [data objectForKey:@"msg"];
        
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:msg];
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
