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
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyBtn;
@property(nonatomic,strong)NSTimer* update1;

@end

@implementation SetMoneyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.update1 = nil;
    // Do any additional setup after loading the view from its nib.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMoneyPasswordBack) name:@"SetMoneyPasswordBack" object:nil];
    self.title = Localize(@"Set_Money_Pwd");
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
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [self.update1 invalidate];
    self.update1 = nil;
    [_sendVerifyBtn setTitle:Localize(@"Send_Verify") forState:UIControlStateNormal];
    [_sendVerifyBtn setEnabled:YES];
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
    [_sendVerifyBtn setTitle:@"60s" forState:UIControlStateNormal];
    [_sendVerifyBtn setEnabled:NO];
    if(_update1){
        [_update1 invalidate];
        _update1 = nil;
    }
    
    _update1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeBtn1) userInfo:nil repeats:YES];
    //    [_update1 fire];
    
    [[NSRunLoop mainRunLoop] addTimer:_update1 forMode:NSDefaultRunLoopMode];
}
-(void)changeBtn1{
    NSString* title = _sendVerifyBtn.titleLabel.text;
    if([title isEqualToString:Localize(@"Send_Verify")]){
        return;
    }
    NSInteger sec = [[title substringToIndex:[title rangeOfString:@"s"].location] intValue];
    sec--;
    if(sec < 0){
        [_sendVerifyBtn setTitle:Localize(@"Send_Verify") forState:UIControlStateNormal];
        //        [NSTimer ]
        [_update1 invalidate];
        _update1 = nil;
        [_sendVerifyBtn setEnabled:YES];
    }else{
        [_sendVerifyBtn setTitle:[NSString stringWithFormat:@"%lds",(long)sec] forState:UIControlStateNormal];
    }
    
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
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Please_Input_Pwd")];
        return;
    }
//    if(self.moneyAgainPassword.text.length == 0){
//        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:@"请输入邮箱验证码"];
//        return;
//    }
    
    if(![self.moneyAgainPassword.text isEqualToString:self.moneyPassword.text]){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Dif")];
        return;
    }
    
    if(self.verifyInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Verify")];
        return;
    }
    
    NSDictionary *parameters = @{@"asset_password": self.moneyPassword.text,
                                 @"phone_captcha": self.verifyInput.text,
//                                 @"email_captcha": self.verifyInput.text
                                 };
    
    NSString* url = @"account/set_assetpwd";
    
//    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"SetMoneyPasswordBack"];
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            [weakSelf setMoneyPasswordBack:data];
        }
    }];
    
}

-(void)setMoneyPasswordBack:(NSDictionary* )data{
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1){
        //设置成功
        [self.navigationController popViewControllerAnimated:YES];
        
        NSString* msg = Localize(@"Set_Success");
        
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
