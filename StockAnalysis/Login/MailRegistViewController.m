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
#import "MailLoginViewController.h"

@interface MailRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mailInput;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *lookPwBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifybtn;
@property(nonatomic,strong)NSTimer* update1;
@end

@implementation MailRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailRegisteBack) name:@"MailRegisteBack" object:nil];
    self.title =  Localize(@"Registe");
    self.update1 = nil;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Have_Acc") style:UIBarButtonItemStylePlain target:self action:@selector(clickLogin)];
    self.navigationItem.rightBarButtonItem = right;
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    _passwordInput.secureTextEntry = YES;
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
    _lookPwBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
    
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
    [_verifybtn setTitle:Localize(@"Send_Invition") forState:UIControlStateNormal];
    [_verifybtn setEnabled:YES];
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
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Mail_Addr")];
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
    NSDictionary *parameters = @{ @"email": self.mailInput.text,
                                  @"captcha": self.verifyInput.text,
                                  @"password": self.passwordInput.text};
    
    
    NSString* url = @"register/email";
    
//    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"MailRegisteBack"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        [HUDUtil hideHudView];
        if(success){
            [weakSelf mailRegisteBack:data];
        }
    }];
}

-(void)mailRegisteBack:(NSDictionary*)data{
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSLog(@"data = %@",data);
    NSNumber* number = [data objectForKey:@"ret"];
    if([number intValue] == -1){
        //注册失败
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:[data objectForKey:@"msg"]];
    }else if([number intValue] == 1){
        //注册成功
        BOOL ishavemailLogin = NO;
        for (UIViewController*vc in self.navigationController.childViewControllers) {
            if([vc isKindOfClass:[MailLoginViewController class]]){
                [self.navigationController popToViewController:vc animated:YES];
                ishavemailLogin = YES;
                break;
            }
        }
        //如果没找到邮箱登录界面
        if(!ishavemailLogin){
            for (UIViewController*vc in self.navigationController.childViewControllers) {
                if([vc isKindOfClass:[LoginViewController class]]){
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
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
- (IBAction)clickVerifybtn:(id)sender {
    
    if(![self.mailInput.text containsString:@"@"]){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:Localize(@"Input_Mail_Addr")];
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
    if([title isEqualToString:Localize(@"Send_Invition")]){
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
