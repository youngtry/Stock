//
//  AddAccountViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/8/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AddAccountViewController.h"
#import "BankCodeViewController.h"

@interface AddAccountViewController ()<BankCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectBankBtn;
@property (weak, nonatomic) IBOutlet UITextField *cardnumberInput;
@property (weak, nonatomic) IBOutlet UITextField *extraInput;
@property (weak, nonatomic) IBOutlet UITextField *contactInput;

@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (weak, nonatomic) IBOutlet UIButton *addbtn;

@end

@implementation AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加账户";
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
}

-(void)test{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickSelectBank:(id)sender {
    
    BankCodeViewController* vc = [[BankCodeViewController alloc] initWithNibName:@"BankCodeViewController" bundle:nil];
    vc.deleagete = self;
    [vc toReturnCountryCode:^(NSString *bankCodeStr) {
        [self.selectBankBtn setTitle:bankCodeStr forState:UIControlStateNormal];
        if([bankCodeStr isEqualToString:@"点击选择银行"]){
            [self.selectBankBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            [self.selectBankBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)clickSetDefaultAccount:(id)sender {
}
- (IBAction)editEnd:(id)sender {
    BOOL finish = [self checkAllInput];
    if(finish){
        [self.addbtn setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0]];
        [self.addbtn setEnabled:YES];
    }else{
        [self.addbtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0]];
        [self.addbtn setEnabled:YES];
    }
}
- (IBAction)clickAddBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)checkAllInput{
    BOOL isfinish = YES;
    
    if([self.selectBankBtn.titleLabel.text isEqualToString:@"点击选择银行"]){
        return NO;
    }
    
    if(self.cardnumberInput.text.length == 0){
        return NO;
    }
    
    if(self.extraInput.text.length == 0){
        return NO;
    }
    
    if(self.contactInput.text.length == 0){
        return NO;
    }
    
    if(self.verifyInput.text.length == 0){
        return NO;
    }
    
    return isfinish;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark BankCodeViewControllerDelegate

-(void)returnBankCode:(NSString *)bankCode{
    [self.selectBankBtn setTitle:bankCode forState:UIControlStateNormal];
    if([self.selectBankBtn.titleLabel.text isEqualToString:@"点击选择银行"]){
        [self.selectBankBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        [self.selectBankBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

@end
