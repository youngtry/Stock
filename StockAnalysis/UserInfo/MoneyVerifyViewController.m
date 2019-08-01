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
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickSure:(id)sender {
    
    NSString* url = @"account/check_assetpwd";
    NSDictionary* params = @{@"asset_password":self.passwordInput.text};
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSString* token = [[data objectForKey:@"data"] objectForKey:@"asset_token"];
                if(weakSelf.block){
                    weakSelf.block(token);
                }
                
                
            }else{
                if(weakSelf.block){
                    weakSelf.block(@"");
                }
            }
        }
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
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
