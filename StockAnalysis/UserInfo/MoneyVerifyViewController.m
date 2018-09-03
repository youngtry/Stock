//
//  MoneyVerifyViewController.m
//  StockAnalysis
//
//  Created by try on 2018/9/3.
//  Copyright © 2018年 try. All rights reserved.
//

#import "MoneyVerifyViewController.h"

@interface MoneyVerifyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@end

@implementation MoneyVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
- (IBAction)clickCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickSure:(id)sender {
    if(self.block){
        self.block(YES);
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
