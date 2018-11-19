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
#import "ModifyMoneyPasswordViewController.h"

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
@property (nonatomic, assign) NSInteger verifyType;
@property (weak, nonatomic) IBOutlet UISwitch *guestureSwitchbBtn;

@property (weak, nonatomic) IBOutlet UIView *guestureTimeView;
@property (weak, nonatomic) IBOutlet UIView *changeGuestureView;
@property (weak, nonatomic) IBOutlet UIView *bindPhoneView;
@property (weak, nonatomic) IBOutlet UIView *bindMailView;
@property (weak, nonatomic) IBOutlet UIView *mneyPasswordView;
@property (weak, nonatomic) IBOutlet UIView *twiceVerifyView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"安全中心";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setGuestureTimeLabel:) name:@"GuestureTimeSetting" object:nil];
    
    if([GameData getGuestureTime]){
        self.guestureTime.text = [GameData getGuestureTime];
    }else{
        self.guestureTime.text = @"2分钟";
    }
    
    _verifyType = 0;
    
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
            }else{
                
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
    
    NSString* url2 = @"account/has_gesture";
    NSDictionary* params2 = @{};
    [[HttpRequest getInstance] getWithURL:url2 parma:params2 block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                if([[[data objectForKey:@"data"] objectForKey:@"has_gesture"] boolValue]){
                    
                    [_guestureSwitchbBtn setOn:YES];
                    
                    if(_guestureTimeView.isHidden){
                        [_guestureTimeView setHidden:NO];
                        [_changeGuestureView setHidden:NO];
                        
                        [_bindPhoneView setCenterY:_bindPhoneView.centerY+90.0f];
                        [_bindMailView setCenterY:_bindMailView.centerY+90.0f];
                        [_mneyPasswordView setCenterY:_mneyPasswordView.centerY+90.0f];
                        [_twiceVerifyView setCenterY:_twiceVerifyView.centerY+90.0f];
                        [_tipLabel setCenterY:_tipLabel.centerY+90.0f];
                    }
                }else{
                    [_guestureSwitchbBtn setOn:NO];
                    [_guestureTimeView setHidden:YES];
                    [_changeGuestureView setHidden:YES];
                    
                    [_bindPhoneView setCenterY:_bindPhoneView.centerY-90.0f];
                    [_bindMailView setCenterY:_bindMailView.centerY-90.0f];
                    [_mneyPasswordView setCenterY:_mneyPasswordView.centerY-90.0f];
                    [_twiceVerifyView setCenterY:_twiceVerifyView.centerY-90.0f];
                    [_tipLabel setCenterY:_tipLabel.centerY-90.0f];
                }
            }else{
                
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    if(_guestureTimeView.isHidden){
        [_guestureTimeView setHidden:NO];
        [_changeGuestureView setHidden:NO];
        
        [_bindPhoneView setCenterY:_bindPhoneView.centerY+90.0f];
        [_bindMailView setCenterY:_bindMailView.centerY+90.0f];
        [_mneyPasswordView setCenterY:_mneyPasswordView.centerY+90.0f];
        [_twiceVerifyView setCenterY:_twiceVerifyView.centerY+90.0f];
        [_tipLabel setCenterY:_tipLabel.centerY+90.0f];
    }
}

-(void)test{
    [self.view endEditing:YES];
}

-(void)setGuestureTimeLabel:(NSNotification *)notification{
//     NSLog(@"收到消息啦!!!");
    if([[notification.userInfo objectForKey:@"text"] isEqualToString:@""]){
        
    }else{
        self.guestureTime.text=[notification.userInfo objectForKey:@"text"];
    }
    
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
    }else{
        
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
        
    }
    
}
- (IBAction)clickGestureVerify:(id)sender {
    UISwitch* btn = (UISwitch*)sender;
    BOOL ison = [btn isOn];
    
    _verifyType = 4;
    [self.verifyView setHidden:NO];
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
//    [HUDUtil showHudViewInSuperView:self.navigationController.view withMessage:@"请求中…"];
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
    [self.verifyView setHidden:NO];
    _verifyType = 1;
    
//    [self.navigationController ]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickMoneyPassword:(id)sender {
    
    _verifyType = 3;
    [self.verifyView setHidden:NO];
    
    
    
    
}
- (IBAction)clickPassword:(id)sender {
    _verifyType = 2;
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
    [self.view endEditing:YES];
    self.passwordInput.text = @"";
    [self.verifyView setHidden:YES];
    
    if(_verifyType == 1){
        
    }else if (_verifyType == 2){
        
    }else if (_verifyType == 3){
        
    }else if (_verifyType == 4){
        BOOL ison = [_guestureSwitchbBtn isOn];
        [_guestureSwitchbBtn setOn:!ison];
    }
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
                
                [self.view endEditing:YES];
                self.passwordInput.text = @"";
                [self.verifyView setHidden:YES];
                
                if(_verifyType == 1){
                    GuestrureTimeSetView* timeset = [[GuestrureTimeSetView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    [self.view addSubview:timeset];
                }else if (_verifyType == 2){
                    SetPasswordViewController *vc = [[SetPasswordViewController alloc] init];
                    [vc setTitle:@"设置手势密码"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if (_verifyType == 3){
                    NSString* url1 = @"account/has_assetpwd";
                    NSDictionary* params1 = @{};
                    
                    [[HttpRequest getInstance] getWithURL:url1 parma:params1 block:^(BOOL success, id data) {
                        if(success){
                            if([[data objectForKey:@"ret"] intValue] == 1){
                                BOOL isSet = [[[data objectForKey:@"data"] objectForKey:@"has_assetpwd"] boolValue];
                                if(!isSet){
                                    SetMoneyPasswordViewController* vc = [[SetMoneyPasswordViewController alloc] initWithNibName:@"SetMoneyPasswordViewController" bundle:nil];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }else{
                                    ModifyMoneyPasswordViewController* vc = [[ModifyMoneyPasswordViewController alloc] initWithNibName:@"ModifyMoneyPasswordViewController" bundle:nil];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }else{
                                
                                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                                
                            }
                        }
                    }];
                }else if (_verifyType == 4){
                    BOOL ison = [_guestureSwitchbBtn isOn];
                    if(!ison){
                        NSDictionary *parameters = @{  @"gesture": @"" ,
                                                       @"verity_token":[[AppData getInstance] getTempVerify]
                                                       };
                        
                        NSString* url = @"account/set_gesture";
                        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
                            if(success){
                                if([[data objectForKey:@"ret"] intValue] == 1){
                                    [_guestureSwitchbBtn setOn:NO];
                                    
                                    [_guestureTimeView setHidden:YES];
                                    [_changeGuestureView setHidden:YES];
                                    
                                    [_bindPhoneView setCenterY:_bindPhoneView.centerY-90.0f];
                                    [_bindMailView setCenterY:_bindMailView.centerY-90.0f];
                                    [_mneyPasswordView setCenterY:_mneyPasswordView.centerY-90.0f];
                                    [_twiceVerifyView setCenterY:_twiceVerifyView.centerY-90.0f];
                                    [_tipLabel setCenterY:_tipLabel.centerY-90.0f];
                                    
                                }else{
                                    
                                    [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                                    
                                }
                            }
                        }];
                    }else{
                        SetPasswordViewController *vc = [[SetPasswordViewController alloc] init];
                        [vc setTitle:@"设置手势密码"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }
                
                
                
            }else{
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
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
