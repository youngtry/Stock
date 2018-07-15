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

@interface MailRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mailInput;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@end

@implementation MailRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailRegisteBack) name:@"MailRegisteBack" object:nil];
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
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入邮箱"];
        return;
    }
    
    if(self.verifyInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入验证码"];
        return;
    }
    
    if(self.passwordInput.text.length == 0){
        [HUDUtil showSystemTipView:self title:@"提示" withContent:@"请输入密码"];
        return;
    }
    
    NSDictionary *parameters = @{ @"email": self.mailInput.text,
                                  @"captcha": self.verifyInput.text,
                                  @"password": self.passwordInput.text};
    
    
    NSString* url = @"register/email";
    
//    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"MailRegisteBack"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [self mailRegisteBack:data];
        }
    }];
}

-(void)mailRegisteBack:(NSDictionary*)data{
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSLog(@"data = %@",data);
    NSNumber* number = [data objectForKey:@"ret"];
    if([number intValue] == -1){
        //注册失败
        [HUDUtil showSystemTipView:self title:@"提示" withContent:[data objectForKey:@"msg"]];
    }else if([number intValue] == 1){
        //注册成功
        [self.navigationController popViewControllerAnimated:YES];
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
