//
//  EnterBankInfoViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/8/14.
//  Copyright © 2018年 try. All rights reserved.
//

#import "EnterBankInfoViewController.h"
#import "BankCodeViewController.h"

@interface EnterBankInfoViewController ()<BankCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UITextField *bankDetailNname;
@property (weak, nonatomic) IBOutlet UITextField *cardNum;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyBtn;

@end

@implementation EnterBankInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"绑定实名银行卡";
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    [self.bindBtn setEnabled:NO];
}

-(void)test{
    [self.view endEditing:YES];
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
    self.sendVerifyBtn.titleLabel.text = @"已发送";
}
- (IBAction)clickBindBtn:(id)sender {
    NSString* url = @"wallet/set_bank_card";
    NSDictionary* params = @{@"name":self.nameInput.text,
                             @"bank":self.bankName.text,
                             @"subbank":self.bankDetailNname.text,
                             @"card":self.cardNum.text,
                             @"phone_captcha":self.verifyInput.text
                             };
    
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"设置成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
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
    if([self.bankName.text isEqualToString:@"请选择"]){
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
