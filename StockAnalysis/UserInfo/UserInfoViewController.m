//
//  UserInfoViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SafeViewController.h"
#import "AuthViewController.h"
#import "FeedbackVC.h"
#import "HttpRequest.h"
@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickSafeInfo:(id)sender {
    SafeViewController* vc = [[SafeViewController alloc] initWithNibName:@"SafeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];}
- (IBAction)clickAuth:(id)sender {
    AuthViewController*vc = [AuthViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickFeedback:(id)sender {
    FeedbackVC *vc = [FeedbackVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickExitAccount:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出账户" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[HttpRequest getInstance] clearToken];
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setBool:NO forKey:@"IsLogin"];
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
    
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
