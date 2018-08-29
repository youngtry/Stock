//
//  ResetPasswordViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/14.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "WSAuthCode.h"
#import "HttpRequest.h"
#import "HUDUtil.h"
@interface ResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIView *secondContainer;
@property (weak, nonatomic) IBOutlet UIView *firstContainer;
@property (weak, nonatomic) IBOutlet UIImageView *authCodeContainer;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@property (weak, nonatomic) IBOutlet UITextField *passwordAgainInput;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (nonatomic,strong) WSAuthCode *authCode;

@property (nonatomic,strong) NSString *captcha_id;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetBack) name:@"ResetPwdBack" object:nil];
    
    self.title = @"找回登录密码";
    
    self.secondContainer.hidden = YES;
    
    self.captcha_id = @"";
    
//    [self.authCodeContainer addSubview:self.authCode];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadAuthCode:)];
//    [self.authCodeContainer addGestureRecognizer:tap];
    self.authCodeContainer.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
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
    
    NSString* url = @"captcha/picture";
    NSDictionary* parameters = @{};
    
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            NSLog(@"data = %@",data);
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSDictionary* picdata = [data objectForKey:@"data"];
                
                self.captcha_id = [picdata objectForKey:@"captcha_id"];
                
                NSString* image = [picdata objectForKey:@"base64_png"];
                
                NSString* imagestr = [image substringFromIndex:22];
//                NSLog(@"imagestr = %@",imagestr);
                
                NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:imagestr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                UIImage* decodeImage = [UIImage imageWithData:decodeData];
                self.authCodeContainer.image = decodeImage;
                
                
            }
        }
    }];
}

-(void)test{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(WSAuthCode*)authCode{
    if(nil==_authCode){
        _authCode = [[WSAuthCode alloc] initWithFrame:self.authCodeContainer.bounds];
        _authCode.wordSpacingType = WordSpacingTypeNone;
    }
    return _authCode;
}

-(void)reloadAuthCode:(id)tap{
    [self.authCode reloadAuthCodeView];
}
-(void)verifyAuthImage{
    
    if(IsStrEmpty(self.userNameTextField.text)){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"请输入用户名"];
        return;
    }
    
    if(self.authCodeTextFiled.text.length == 0){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"请输入验证码"];
        return;
    }
    
    NSDictionary* paremeters = @{@"captcha_id":self.captcha_id,
                                 @"value":self.authCodeTextFiled.text};
    
    NSString* url = @"captcha/picture/verify";
    
    [[HttpRequest getInstance] postWithURL:url parma:paremeters block:^(BOOL success, id data) {
        if(success){
            NSLog(@"验证码信息:%@",data);
            
            if([[data objectForKey:@"ret"] intValue]== 1){
                //验证成功
                self.secondContainer.hidden = NO;
                self.firstContainer.hidden = YES;
            }else if ([[data objectForKey:@"ret"] intValue]== -1){
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

- (IBAction)clickNext:(id)sender {
    
    
    [self verifyAuthImage];
    return;

    
}
- (IBAction)clickReset:(id)sender {
    if(self.passwordInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入密码"];
        return;
    }
    if(self.passwordAgainInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请再次输入密码"];
        return;
    }
    
    if(![self.passwordAgainInput.text isEqualToString:self.passwordInput.text]){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"两次输入不一致，请重新输入"];
        return;
    }
    
    if(self.verifyInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入验证码"];
        return;
    }
    
    if([self.userNameTextField.text containsString:@"@"]){
        //邮箱重置
        NSDictionary *parameters = @{ @"email": self.userNameTextField.text ,
                                @"captcha": self.verifyInput.text ,
                                @"password": self.passwordInput.text};
        
//        NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithDictionary:para];
        NSString* url = @"account/resetpwd_by_email";
        
//        [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"ResetPwdBack"];
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
//                NSDictionary* info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [self resetBack:data];
            }
        }];
    }else{
        
        NSDictionary *parameters = @{ @"phone": self.userNameTextField.text ,
                                @"captcha": self.verifyInput.text ,
                                @"password": self.passwordInput.text};
        
//        NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithDictionary:para];
        
        
        NSString* url = @"account/resetpwd_by_phone";
        
//        [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"ResetPwdBack"];
        
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
//                NSDictionary* info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [self resetBack:data];
            }
        }];
    }
    
    
    
}

-(void)resetBack:(NSDictionary* )data{
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1){
        //设置成功
        [self.navigationController popViewControllerAnimated:YES];
        
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
