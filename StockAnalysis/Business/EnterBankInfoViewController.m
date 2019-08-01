//
//  EnterBankInfoViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/8/14.
//  Copyright © 2018年 try. All rights reserved.
//

#import "EnterBankInfoViewController.h"
#import "BankCodeViewController.h"
#import "MoneyVerifyViewController.h"

@interface EnterBankInfoViewController ()<BankCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UITextField *bankDetailNname;
@property (weak, nonatomic) IBOutlet UITextField *cardNum;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyBtn;

@property(nonatomic,strong)NSTimer* update1;

@end

@implementation EnterBankInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"Bind_Card");
    self.update1 = nil;
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    [self.bindBtn setEnabled:NO];
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
    [_sendVerifyBtn setTitle:Localize(@"Send_Verify") forState:UIControlStateNormal];
    [_sendVerifyBtn setEnabled:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickSelectBanBtn:(id)sender {
    BankCodeViewController* vc = [[BankCodeViewController alloc] initWithNibName:@"BankCodeViewController" bundle:nil];
    vc.deleagete = self;
    [vc toReturnCountryCode:^(NSString *bankCodeStr) {
        self.bankName.text  = bankCodeStr;
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickSendVerifyBtn:(id)sender {
    [_sendVerifyBtn setTitle:@"60s" forState:UIControlStateNormal];
    [_sendVerifyBtn setEnabled:NO];
    if(_update1){
        [_update1 invalidate];
        _update1 = nil;
    }
    
    _update1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeBtn1) userInfo:nil repeats:YES];
    //    [_update1 fire];
    
    [[NSRunLoop mainRunLoop] addTimer:_update1 forMode:NSDefaultRunLoopMode];
}
-(void)changeBtn1{
    NSString* title = _sendVerifyBtn.titleLabel.text;
    if([title isEqualToString:Localize(@"Send_Verify")]){
        return;
    }
    NSInteger sec = [[title substringToIndex:[title rangeOfString:@"s"].location] intValue];
    sec--;
    if(sec < 0){
        [_sendVerifyBtn setTitle:Localize(@"Send_Verify") forState:UIControlStateNormal];
        //        [NSTimer ]
        [_update1 invalidate];
        _update1 = nil;
        [_sendVerifyBtn setEnabled:YES];
    }else{
        [_sendVerifyBtn setTitle:[NSString stringWithFormat:@"%lds",(long)sec] forState:UIControlStateNormal];
    }
    
}

- (IBAction)clickBindBtn:(id)sender {
    
    MoneyVerifyViewController* vc = [[MoneyVerifyViewController alloc] initWithNibName:@"MoneyVerifyViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.definesPresentationContext = YES;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    WeakSelf(weakSelf);
    vc.block = ^(NSString* token) {
        if(token.length>0){
            NSString* url = @"wallet/set_bank_card";
            NSDictionary* params = @{@"name":weakSelf.nameInput.text,
                                     @"bank":weakSelf.bankName.text,
                                     @"subbank":weakSelf.bankDetailNname.text,
                                     @"card":weakSelf.cardNum.text,
                                     @"phone_captcha":weakSelf.verifyInput.text,
                                     @"asset_token":token
                                     };
            
            [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
                if(success){
                    if([[data objectForKey:@"ret"] intValue] == 1){
                        [HUDUtil showHudViewTipInSuperView:weakSelf.navigationController.view withMessage:Localize(@"Set_Success")];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }else{
                        [HUDUtil showHudViewTipInSuperView:weakSelf.navigationController.view withMessage:[data objectForKey:@"msg"]];
                    }
                }
            }];
        }else{
            [HUDUtil showHudViewTipInSuperView:weakSelf.navigationController.view withMessage:Localize(@"Money_Pwd_Verify_Tip")];
        }
    };
    
}
- (IBAction)editEnd:(id)sender {
    if([self getEnterAll]){
        [self.bindBtn setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0]];
        [self.bindBtn setEnabled:YES];
    }else{
        [self.bindBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0]];
        [self.bindBtn setEnabled:NO];
    }
}

-(BOOL)getEnterAll{
    if(self.nameInput.text.length==0){
        return NO;
    }
    if([self.bankName.text isEqualToString:Localize(@"Please_Select")]){
        return NO;
    }
    if(self.bankDetailNname.text.length==0){
        return NO;
    }
    if(self.cardNum.text.length==0){
        return NO;
    }
    if(self.verifyInput.text.length==0){
        return NO;
    }
    return YES;
}

#pragma mark BankCode

-(void)returnBankCode:(NSString *)bankCode{
    self.bankName.text  = bankCode;
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
