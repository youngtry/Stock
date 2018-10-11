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

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
        NSDictionary* params = @{@"email":_mailAddressInput.text,
                                 @"phone_captcha":_verify2Input.text,
                                 @"email_captcha":_verify1Input.text
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
