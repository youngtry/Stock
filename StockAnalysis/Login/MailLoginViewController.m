//
//  MailLoginViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/5.
//  Copyright © 2018年 try. All rights reserved.
//

#import "MailLoginViewController.h"
#import "ResetPasswordViewController.h"
#import "HttpRequest.h"
#import "HUDUtil.h"
#import "GameData.h"
#import "MailRegistViewController.h"
@interface MailLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput
;
@property (weak, nonatomic) IBOutlet UIButton *lookPwBtn;

@end

@implementation MailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailLoginBack) name:@"MailLoginBack" object:nil];
    
    self.title =  Localize(@"Login");
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    self.passwordInput.secureTextEntry = YES;
    
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-c.png"] forState:UIControlStateNormal];
    [_lookPwBtn setImage:[UIImage imageNamed:@"eye-o.png"] forState:UIControlStateSelected];
    
    _lookPwBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Registe_Acc") style:UIBarButtonItemStylePlain target:self action:@selector(clickRegist:)];
    self.navigationItem.rightBarButtonItem = right;
    
}
-(void)clickRegist:(id)sender{
    NSLog(@"clickRegist");
    
    MailRegistViewController *vc = [[MailRegistViewController alloc] initWithNibName:@"MailRegistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


-(void)test{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickLogin:(id)sender {
    if(![self.mailInput.text containsString:@"@"]){
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:Localize(@"Input_Correct_Mail")];
        return;
    }
    
    if(![VerifyRules passWordIsTure:self.passwordInput.text]){
        [HUDUtil showSystemTipView:self title:Localize(@"Pwd_Error") withContent:Localize(@"Pwd_Error_Tip")];
        return;
    }
    [HUDUtil showHudViewInSuperView:self.view withMessage:Localize(@"Logining")];
    NSDictionary *parameters = @{ @"email": self.mailInput.text ,
                                  @"password": self.passwordInput.text};
    
//    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithDictionary:para];
    NSString* url = @"account/login/email";
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        [HUDUtil hideHudView];
        if(success){
            [weakSelf mailLoginBack:data];
        }
    }];
    
//    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"MailLoginBack"];
    
    [HUDUtil showHudViewInSuperView:self.view withMessage:Localize(@"Logining")];
}
- (IBAction)clickPhoneLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickForgetPassword:(id)sender {
    ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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

-(void)mailLoginBack:(NSDictionary*)data{
    [HUDUtil hideHudView];
    
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    
    NSNumber* number = [data objectForKey:@"ret"];
    if([number intValue] == 1){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:Localize(@"Login_Succ")];
        [GameData setUserAccount:self.mailInput.text];
        [GameData setUserPassword:self.passwordInput.text];
        [GameData setAccountList:self.mailInput.text withPassword:self.passwordInput.text withDistrict:@""];
        [GameData setNeedNoticeGuesture:YES];
        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setBool:YES forKey:@"IsLogin"];
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
    }else{
        //登陆失败
        [HUDUtil showSystemTipView:self title:Localize(@"Menu_Title") withContent:[data objectForKey:@"msg"]];
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
