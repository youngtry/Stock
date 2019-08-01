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
@property (weak, nonatomic) IBOutlet UIButton *lookNewPwdAgainBtn;
@property(nonatomic,strong)NSTimer* update1;
@end

@implementation ModifyMoneyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"Modify_Money_Pwd");
    self.update1 = nil;
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    [_lookNewPwBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookNewPwBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
    [_lookOriginPwbtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookOriginPwbtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
    [_lookNewPwdAgainBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookNewPwdAgainBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
    [_lookNewPwBtn setHidden:YES];
    [_lookOriginPwbtn setHidden:YES];
    [_lookNewPwdAgainBtn setHidden:YES];
    
//    _lookNewPwBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
//    _lookOriginPwbtn.imageEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
//    _lookNewPwdAgainBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
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
    
    [self.update1 invalidate];
    self.update1 = nil;
    [_sendVerifyBtn setTitle:Localize(@"Send_Verify") forState:UIControlStateNormal];
    [_sendVerifyBtn setEnabled:YES];
}
- (IBAction)clickSendVerifyBtn:(id)sender {
    
//    if(self.phoneVerifyInput.text.length == 0){
//        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"请输入手机号"];
//        return;
//    }
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
- (IBAction)sendMailVerify:(id)sender {
    if (!_lookNewPwdAgainBtn.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.mailVerifyInput.text;
        self.mailVerifyInput.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.mailVerifyInput.secureTextEntry = NO;
        self.mailVerifyInput.text = tempPwdStr;
        [_lookNewPwdAgainBtn setSelected:YES];
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.mailVerifyInput.text;
        self.mailVerifyInput.text = @"";
        self.mailVerifyInput.secureTextEntry = YES;
        self.mailVerifyInput.text = tempPwdStr;
        [_lookNewPwdAgainBtn setSelected:NO];
    }
}
- (IBAction)clickSureBtn:(id)sender {
    if(self.originPwInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Old_Pwd")];
        return;
    }
    if(self.anewPwInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_New_Pwd")];
        return;
    }
    if(![self.mailVerifyInput.text isEqualToString:self.anewPwInput.text]){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Dif")];
        return;
    }
    
    //    if(![self.moneyAgainPassword.text isEqualToString:self.moneyPassword.text]){
    //        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:@"两次输入不一致，请重新输入"];
    //        return;
    //    }
    
    if(self.phoneVerifyInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Verify")];
        return;
    }
    
    NSDictionary *parameters = @{@"old_asset_password": self.originPwInput.text,
                                 @"new_asset_password": self.anewPwInput.text,
                                 @"phone_captcha": self.phoneVerifyInput.text,
//                                 @"email_captcha": self.mailVerifyInput.text
                                 };
    
    NSString* url = @"account/update_assetpwd";
    
    //    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"SetMoneyPasswordBack"];
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            NSNumber* ret = [data objectForKey:@"ret"];
            if([ret intValue] == 1){
                //设置成功
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                NSString* msg = Localize(@"Reset_Succ");
                
                [HUDUtil showHudViewTipInSuperView:weakSelf.navigationController.view withMessage:msg];
            }else{
                NSString* msg = [data objectForKey:@"msg"];
                
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:msg];
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
