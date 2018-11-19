//
//  BindViewController.m
//  StockAnalysis
//
//  Created by try on 2018/9/5.
//  Copyright © 2018年 try. All rights reserved.
//

#import "BindViewController.h"
#import "XWCountryCodeController.h"

@interface BindViewController ()<XWCountryCodeControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bindName;
@property (weak, nonatomic) IBOutlet UITextField *bindAddressInput;
@property (weak, nonatomic) IBOutlet UILabel *verify1Name;
@property (weak, nonatomic) IBOutlet UITextField *verify1Input;
@property (weak, nonatomic) IBOutlet UILabel *verify2name;
@property (weak, nonatomic) IBOutlet UITextField *verify2Input;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *mailAddressInput;
@property (weak, nonatomic) IBOutlet UIButton *districtbtn;
@property (weak, nonatomic) IBOutlet UILabel *distrcLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn1;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn2;

@property(nonatomic,strong)NSTimer* update1;
@property(nonatomic,strong)NSTimer* update2;
@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _update1 = nil;
    _update2 = nil;
    
    if([self.title isEqualToString:@"绑定邮箱"]){
        _bindName.text = @"邮箱地址";
        [_bindAddressInput setHidden:YES];
        [_districtbtn setHidden:YES];
        [_mailAddressInput setHidden:NO];
        [self.distrcLabel setHidden:YES];
        [self.arrowImage setHidden:YES];
        _verify1Name.text = @"邮箱验证码";
        _verify1Input.placeholder = @"输入邮箱验证码";
        _verify2name.text = @"短信验证码";
        _verify2Input.placeholder = @"输入短信验证码";
        _tipLabel.text = @"注意：一经绑定，无法修改，请填写真实有效邮箱";
    }else if ([self.title isEqualToString:@"绑定手机"]){
        _bindName.text = @"手机号码";
        [_bindAddressInput setHidden:NO];
        [_districtbtn setHidden:NO];
        [_mailAddressInput setHidden:YES];
        [self.distrcLabel setHidden:NO];
        [self.arrowImage setHidden:NO];
        _verify1Name.text = @"短信验证码";
        _verify1Input.placeholder = @"输入短信验证码";
        _verify2name.text = @"邮箱验证码";
        _verify2Input.placeholder = @"输入邮箱验证码";
//        [self returnCountryCode:@"+86"];
        self.distrcLabel.text = @"+86";
        _tipLabel.text = @"注意：一经绑定，无法修改，请填写真实有效手机号";
    }
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    [self.confirmBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0]];
    [self.confirmBtn setEnabled:NO];
    
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
    [self.update1 invalidate];
    self.update1 = nil;
    [self.update2 invalidate];
    self.update2 = nil;
    [_verifyBtn1 setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_verifyBtn2 setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_verifyBtn1 setEnabled:YES];
    [_verifyBtn2 setEnabled:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)endEdit:(id)sender {
    if([self chechInput]){
        [self.confirmBtn setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0]];
        [self.confirmBtn setEnabled:YES];
    }else{
        [self.confirmBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0]];
        [self.confirmBtn setEnabled:NO];
    }
}
-(BOOL)chechInput{
    if([self.title isEqualToString:@"绑定邮箱"]){
        if(_mailAddressInput.text.length==0){
            
            [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"输入不正确,请重新输入"];
            
            return NO;
        }
    }else if ([self.title isEqualToString:@"绑定手机"]){
        if(_bindAddressInput.text.length==0){
            
            [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"输入不正确,请重新输入"];
            
            return NO;
        }
    }
    
    if(_verify1Input.text.length==0){
        [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"输入不正确,请重新输入"];
        return NO;
    }
    if(_verify2Input.text.length==0){
        [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"输入不正确,请重新输入"];
        return NO;
    }
    
    return YES;
    
}
- (IBAction)clickComfirm:(id)sender {
    
    if([self.title isEqualToString:@"绑定手机"]){
        NSString* url = @"account/bind_phone";
        NSDictionary* params = @{@"phone":_bindAddressInput.text,
                                 @"phone_captcha":_verify1Input.text,
                                 @"email_captcha":_verify2Input.text,
                                 @"district":self.distrcLabel.text
                                 };
//        [HUDUtil showHudViewInSuperView:self.navigationController.view withMessage:@"请求中…"];
        [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
            if(success){
                [HUDUtil hideHudView];
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"绑定成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
                }
            }
        }];
    }else if([self.title isEqualToString:@"绑定邮箱"]){
        NSString* url = @"account/bind_email";
        NSDictionary* params = @{@"email":_mailAddressInput.text,
                                 @"phone_captcha":_verify2Input.text,
                                 @"email_captcha":_verify1Input.text
                                 };
//        [HUDUtil showHudViewInSuperView:self.navigationController.view withMessage:@"请求中…"];
        [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
            if(success){
                [HUDUtil hideHudView];
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"绑定成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
                }
            }
        }];
    }
    
}
- (IBAction)clickDistrict:(id)sender {
    XWCountryCodeController* countrycodeVC = [[XWCountryCodeController alloc] init];
    countrycodeVC.deleagete = self;
    [countrycodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        NSLog(@"countryCodeStr = %@",countryCodeStr);
        countryCodeStr = [countryCodeStr substringFromIndex:[countryCodeStr rangeOfString:@"+"].location];
        NSLog(@"countryCodeStr = %@",countryCodeStr);
//        [self.districtbtn.titleLabel setText:countryCodeStr];
        self.distrcLabel.text = countryCodeStr;
    }];
    
    [self.navigationController pushViewController:countrycodeVC animated:YES];
}
- (IBAction)sendVerify1:(id)sender {
    if([self.title isEqualToString:@"绑定手机"]){
        
    }else if([self.title isEqualToString:@"绑定邮箱"]){
        
    }
    [_verifyBtn1 setTitle:@"60s" forState:UIControlStateNormal];
    [_verifyBtn1 setEnabled:NO];
    if(_update1){
        [_update1 invalidate];
        _update1 = nil;
    }
    
    _update1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeBtn1) userInfo:nil repeats:YES];
//    [_update1 fire];
    
    [[NSRunLoop mainRunLoop] addTimer:_update1 forMode:NSDefaultRunLoopMode];
}

-(void)changeBtn1{
    NSString* title = _verifyBtn1.titleLabel.text;
    if([title isEqualToString:@"发送验证码"]){
        return;
    }
    NSInteger sec = [[title substringToIndex:[title rangeOfString:@"s"].location] intValue];
    sec--;
    if(sec < 0){
        [_verifyBtn1 setTitle:@"发送验证码" forState:UIControlStateNormal];
//        [NSTimer ]
        [_update1 invalidate];
        _update1 = nil;
        [_verifyBtn1 setEnabled:YES];
    }else{
        [_verifyBtn1 setTitle:[NSString stringWithFormat:@"%lds",(long)sec] forState:UIControlStateNormal];
    }
    
}

- (IBAction)sendVerify2:(id)sender {
    if([self.title isEqualToString:@"绑定手机"]){
        
    }else if([self.title isEqualToString:@"绑定邮箱"]){
        
    }
    [_verifyBtn2 setTitle:@"60s" forState:UIControlStateNormal];
    [_verifyBtn2 setEnabled:NO];
    if(_update2){
        [_update2 invalidate];
        _update2 = nil;
    }
    
    _update2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeBtn2) userInfo:nil repeats:YES];
    //    [_update1 fire];
    
    [[NSRunLoop mainRunLoop] addTimer:_update2 forMode:NSDefaultRunLoopMode];
}

-(void)changeBtn2{
    NSString* title = _verifyBtn2.titleLabel.text;
    if([title isEqualToString:@"发送验证码"]){
        return;
    }
    NSInteger sec = [[title substringToIndex:[title rangeOfString:@"s"].location] intValue];
    sec--;
    if(sec < 0){
        [_verifyBtn2 setTitle:@"发送验证码" forState:UIControlStateNormal];
        //        [NSTimer ]
        [_update2 invalidate];
        _update2 = nil;
        [_verifyBtn2 setEnabled:YES];
    }else{
        [_verifyBtn2 setTitle:[NSString stringWithFormat:@"%lds",(long)sec] forState:UIControlStateNormal];
    }
    
}
#pragma mark - XWCountryCodeControllerDelegate
-(void)returnCountryCode:(NSString *)countryCode{
    
    countryCode = [countryCode substringFromIndex:[countryCode rangeOfString:@"+"].location];
    NSLog(@"countryCode = %@",countryCode);
//    [self.districtbtn.titleLabel setText:countryCode];
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
