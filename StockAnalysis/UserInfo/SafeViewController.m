//
//  SafeViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SafeViewController.h"
#import "SetPasswordViewController.h"
#import "SetMoneyPasswordViewController.h"
#import "HttpRequest.h"
#import "GuestrureTimeSetView.h"
#import "AppData.h"
#import "BindViewController.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface SafeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneBindLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailBindLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phoneBindImage;
@property (weak, nonatomic) IBOutlet UIImageView *mailBindImage;
@property (weak, nonatomic) IBOutlet UILabel *guestureTime;

@property (weak, nonatomic) IBOutlet UIView *verifyView;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"安全中心";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setGuestureTimeLabel:) name:@"GuestureTimeSetting" object:nil];
    
    
    
//    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"GetUserBindInfo"];
    
    [self.verifyView setHidden:YES];
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.verifyView addGestureRecognizer:f];
    self.verifyView.userInteractionEnabled = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    NSDictionary *parameters = @{} ;
    //    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithDictionary:para];
    
    
    NSString* url = @"account/bindInfo";
    
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [self getBindBack:data];
        }
    }];
    
    NSString* url1 = @"account/getConfirmState";
    NSDictionary* params = @{};
    [[HttpRequest getInstance] getWithURL:url1 parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSString* state = [[data objectForKey:@"data"] objectForKey:@"state"];
                if([state isEqualToString:@"on"]){
                    [self.switchBtn setOn:YES];
                }else{
                    [self.switchBtn setOn:NO];
                }
            }
        }
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)test{
    [self.view endEditing:YES];
}

-(void)setGuestureTimeLabel:(NSNotification *)notification{
//     NSLog(@"收到消息啦!!!");
    
    self.guestureTime.text=[notification.userInfo objectForKey:@"text"];
}

-(void)getBindBack:(NSDictionary* )data{
    
    NSLog(@"data = %@",data);
    
    NSNumber* number = [data objectForKey:@"ret"];
    if([number intValue] == 1){
        NSDictionary* info = [data objectForKey:@"data"];
        NSLog(@"info = %@",info);
        NSString* email = [info objectForKey:@"email"];
        if([email containsString:@"@"]){
            self.mailBindImage.hidden = YES;
            self.mailBindLabel.hidden = NO;
        }else{
            self.mailBindLabel.hidden = YES;
            self.mailBindImage.hidden = NO;
        }
         NSString* phone = [info objectForKey:@"phone"];
        if(phone.length>0){
            self.phoneBindImage.hidden = YES;
            self.phoneBindLabel.hidden = NO;
        }else{
            self.phoneBindLabel.hidden = YES;
            self.phoneBindImage.hidden = NO;
        }
    }
    
}
- (IBAction)clickGestureVerify:(id)sender {
    UISwitch* btn = (UISwitch*)sender;
    BOOL ison = [btn isOn];
    NSLog(@"clickGestureVerify ison = %d",ison);
}
- (IBAction)clickTwiceVerify:(id)sender {
    UISwitch* btn = (UISwitch*)sender;
    BOOL ison = [btn isOn];
    NSLog(@"clickTwiceVerify ison = %d",ison);
    NSString* state = @"off";
    if(ison){
        state = @"on";
    }else{
        state = @"off";
    }
    
    NSString* url = @"account/setConfirmCheck";
    NSDictionary* params = @{@"state":state};
    
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"设置成功"];
               
            }else{
                
                if([state isEqualToString:@"on"]){
                    [btn setOn:NO];
                }else{
                    [btn setOn:YES];
                }
                
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
    
}
- (IBAction)clickTimeSelect:(id)sender {
    GuestrureTimeSetView* timeset = [[GuestrureTimeSetView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:timeset];
//    [self.navigationController ]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickMoneyPassword:(id)sender {
    SetMoneyPasswordViewController* vc = [[SetMoneyPasswordViewController alloc] initWithNibName:@"SetMoneyPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickPassword:(id)sender {
    
    [self.verifyView setHidden:NO];
    
    
}
- (IBAction)clickBindMail:(id)sender {
    BindViewController* vc = [[BindViewController alloc] initWithNibName:@"BindViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"绑定邮箱";
    
}
- (IBAction)clickBindPhone:(id)sender {
    BindViewController* vc = [[BindViewController alloc] initWithNibName:@"BindViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"绑定手机";
    
}
- (IBAction)clickCancelVerifyBtn:(id)sender {
    self.passwordInput.text = @"";
    [self.verifyView setHidden:YES];
}
- (IBAction)clickSureVerifybtn:(id)sender {
    [self test];
    NSString* url = @"account/veritypwd";
    NSDictionary* params = @{@"password":self.passwordInput.text};
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSString* temp = [[data objectForKey:@"data"] objectForKey:@"verity_token"];
                
                [[AppData getInstance] setTempVerify:temp];
                
                [self clickCancelVerifyBtn:nil];
                
                SetPasswordViewController *vc = [[SetPasswordViewController alloc] init];
                [vc setTitle:@"设置手势密码"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
    
}

-(void)showVerifyView{
    [self test];
    [self.verifyView setHidden:NO];
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
