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
@property (weak, nonatomic) IBOutlet UIButton *verifybtn;
@property(nonatomic,strong)NSTimer* update1;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =  Localize(@"Registe");
    self.update1 = nil;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeBack) name:@"RegisteBack" object:nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Have_Acc") style:UIBarButtonItemStylePlain target:self action:@selector(clickLogin)];
    self.navigationItem.rightBarButtonItem = right;
    
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
    
    [self.update1 invalidate];
    self.update1 = nil;
    [_verifybtn setTitle:Localize(@"Send_Verify") forState:UIControlStateNormal];
    [_verifybtn setEnabled:YES];
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
    if(self.phoneInput.text.length == 0){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:Localize(@"Input_Phone")];
        return;
    }
    [_verifybtn setTitle:@"60s" forState:UIControlStateNormal];
    [_verifybtn setEnabled:NO];
    if(_update1){
        [_update1 invalidate];
        _update1 = nil;
    }
    
    _update1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeBtn1) userInfo:nil repeats:YES];
    //    [_update1 fire];
    
    [[NSRunLoop mainRunLoop] addTimer:_update1 forMode:NSDefaultRunLoopMode];
}
-(void)changeBtn1{
    NSString* title = _verifybtn.titleLabel.text;
    if([title isEqualToString:Localize(@"Send_Verify")]){
        return;
    }
    NSInteger sec = [[title substringToIndex:[title rangeOfString:@"s"].location] intValue];
    sec--;
    if(sec < 0){
        [_verifybtn setTitle:Localize(@"Send_Verify") forState:UIControlStateNormal];
        //        [NSTimer ]
        [_update1 invalidate];
        _update1 = nil;
        [_verifybtn setEnabled:YES];
    }else{
        [_verifybtn setTitle:[NSString stringWithFormat:@"%lds",(long)sec] forState:UIControlStateNormal];
    }
    
}
- (IBAction)clickPhoneRegiste:(id)sender {
    
    if(![VerifyRules phoneNumberIsTure:self.phoneInput.text]){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Correct_Phone")];
        return;
    }
    
    if(self.verifyInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Verify")];
        return;
    }
    
    if(![VerifyRules passWordIsTure:self.passwordInput.text]){
        [HUDUtil showSystemTipView:self title:Localize(@"Pwd_Error") withContent:Localize(@"Pwd_Error_Tip")];
        return;
    }
    [HUDUtil showHudViewInSuperView:self.view withMessage:Localize(@"Registing")];
    NSDictionary *parameters = @{ @"phone": self.phoneInput.text ,
                                  @"captcha": self.verifyInput.text ,
                                  @"password": self.passwordInput.text ,
                                  @"district": self.distrcLabel.text};

    NSString* url = @"register/phone";

    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        [HUDUtil hideHudView];
        if(success){
            NSNumber* number = [data objectForKey:@"ret"];
            if([number intValue] == 1){
                //注册成功
                [HUDUtil showHudViewTipInSuperView:weakSelf.navigationController.view withMessage:@"注册成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                //注册失败
                [HUDUtil showSystemTipView:weakSelf title:Localize(@"Menu_Title") withContent:[data objectForKey:@"msg"]];
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
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:[data objectForKey:@"msg"]];
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
