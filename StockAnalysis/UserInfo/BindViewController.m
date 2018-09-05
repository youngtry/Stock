//
//  BindViewController.m
//  StockAnalysis
//
//  Created by try on 2018/9/5.
//  Copyright © 2018年 try. All rights reserved.
//

#import "BindViewController.h"

@interface BindViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bindName;
@property (weak, nonatomic) IBOutlet UITextField *bindAddressInput;
@property (weak, nonatomic) IBOutlet UILabel *verify1Name;
@property (weak, nonatomic) IBOutlet UITextField *verify1Input;
@property (weak, nonatomic) IBOutlet UILabel *verify2name;
@property (weak, nonatomic) IBOutlet UITextField *verify2Input;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if([self.title isEqualToString:@"绑定邮箱"]){
        _bindName.text = @"邮箱地址";
        _bindAddressInput.placeholder = @"请输入邮箱地址";
        _verify1Name.text = @"邮箱验证码";
        _verify1Input.placeholder = @"输入邮箱验证码";
        _verify2name.text = @"短信验证码";
        _verify2Input.placeholder = @"输入短信验证码";
    }else if ([self.title isEqualToString:@"绑定手机"]){
        _bindName.text = @"手机号码";
        _bindAddressInput.placeholder = @"请输入手机号码";
        _verify1Name.text = @"短信验证码";
        _verify1Input.placeholder = @"输入短信验证码";
        _verify2name.text = @"邮箱验证码";
        _verify2Input.placeholder = @"输入邮箱验证码";
    }
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
-(BOOL)chechInput{
    if(_bindAddressInput.text.length==0){
        
        [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"输入不正确,请重新输入"];
        
        return NO;
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
    
    if(![self chechInput]){
        return;
    }
    
    if([self.title isEqualToString:@"绑定手机"]){
        NSString* url = @"account/bind_phone";
        NSDictionary* params = @{@"phone":_bindName.text,
                                 @"phone_captcha":_verify1Input.text,
                                 @"email_captcha":_verify2Input.text,
                                 @"password":@"",
                                 @"district":@""
                                 };
        [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
            if(success){
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
        NSDictionary* params = @{@"email":_bindName.text,
                                 @"phone_captcha":_verify2Input.text,
                                 @"email_captcha":_verify1Input.text,
                                 @"password":@""
                                 };
        [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
            if(success){
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
