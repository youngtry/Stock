//
//  SetMoneyPasswordViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/2.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SetMoneyPasswordViewController.h"

@interface SetMoneyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *moneyPassword;
@property (weak, nonatomic) IBOutlet UITextField *moneyAgainPassword;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;

@end

@implementation SetMoneyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickLookPassword:(id)sender {
}
- (IBAction)clickAgainPassword:(id)sender {
}
- (IBAction)clickVerify:(id)sender {
}
- (IBAction)clickResetPassword:(id)sender {
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
