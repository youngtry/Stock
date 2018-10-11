//
//  ModifyMoneyPasswordViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/9/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ModifyMoneyPasswordViewController.h"

@interface ModifyMoneyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *originPwInput;
@property (weak, nonatomic) IBOutlet UITextField *anewPwInput;
@property (weak, nonatomic) IBOutlet UITextField *mailVerifyInput;
@property (weak, nonatomic) IBOutlet UITextField *phoneVerifyInput;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookOriginPwbtn;
@property (weak, nonatomic) IBOutlet UIButton *lookNewPwBtn;

@end

@implementation ModifyMoneyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改资金密码";
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    [_lookNewPwBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookNewPwBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
    [_lookOriginPwbtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookOriginPwbtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
}

-(void)test{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)clickSendVerifyBtn:(id)sender {
    
}
- (IBAction)sendMailVerify:(id)sender {
}
- (IBAction)clickSureBtn:(id)sender {
    if(self.originPwInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入旧密码"];
        return;
    }
    if(self.anewPwInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入新密码"];
        return;
    }
    if(self.mailVerifyInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入邮箱验证码"];
        return;
    }
    
    //    if(![self.moneyAgainPassword.text isEqualToString:self.moneyPassword.text]){
    //        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"两次输入不一致，请重新输入"];
    //        return;
    //    }
    
    if(self.phoneVerifyInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入验证码"];
        return;
    }
    
    NSDictionary *parameters = @{@"old_asset_password": self.originPwInput.text,
                                 @"new_asset_password": self.anewPwInput.text,
                                 @"phone_captcha": self.phoneVerifyInput.text,
                                 @"email_captcha": self.mailVerifyInput.text};
    
    NSString* url = @"account/update_assetpwd";
    
    //    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"SetMoneyPasswordBack"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            NSNumber* ret = [data objectForKey:@"ret"];
            if([ret intValue] == 1){
                //设置成功
                [self.navigationController popViewControllerAnimated:YES];
                
                NSString* msg = @"修改成功";
                
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:msg];
            }else{
                NSString* msg = [data objectForKey:@"msg"];
                
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:msg];
            }
        }
    }];
}
- (IBAction)clickLookOriginPwBtn:(id)sender {
    if (!_lookOriginPwbtn.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.originPwInput.text;
        self.originPwInput.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.originPwInput.secureTextEntry = NO;
        self.originPwInput.text = tempPwdStr;
        [_lookOriginPwbtn setSelected:YES];
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.originPwInput.text;
        self.originPwInput.text = @"";
        self.originPwInput.secureTextEntry = YES;
        self.originPwInput.text = tempPwdStr;
        [_lookOriginPwbtn setSelected:NO];
    }
}

- (IBAction)clickLookNewPwBtn:(id)sender {
    
    if (!_lookNewPwBtn.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.anewPwInput.text;
        self.anewPwInput.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.anewPwInput.secureTextEntry = NO;
        self.anewPwInput.text = tempPwdStr;
        [_lookNewPwBtn setSelected:YES];
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.anewPwInput.text;
        self.anewPwInput.text = @"";
        self.anewPwInput.secureTextEntry = YES;
        self.anewPwInput.text = tempPwdStr;
        [_lookNewPwBtn setSelected:NO];
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
