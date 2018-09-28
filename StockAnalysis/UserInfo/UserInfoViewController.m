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
#import "GameData.h"
#import "UserManagerViewController.h"
#import "SCAlertController.h"
#import "SystemSettingViewController.h"
@interface UserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的";
    
    NSString* username = [GameData getUserAccount];
    _usernameLabel.text = username;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
    
    SCAlertController *alert = [SCAlertController alertControllerWithTitle:@"提示" message:@"是否退出账户" preferredStyle:  UIAlertControllerStyleAlert];
    alert.messageColor = kColor(136, 136, 136);
    //取消
    SCAlertAction *cancelAction = [SCAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:cancelAction];
    
    //退出
    SCAlertAction *exitAction = [SCAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HttpRequest getInstance] clearToken];
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setBool:NO forKey:@"IsLogin"];
        self.tabBarController.tabBar.hidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
    }];
    //单独修改一个按钮的颜色
    exitAction.textColor = kColor(243, 186, 46);
    [alert addAction:exitAction];
    
    [self presentViewController:alert animated:YES completion:nil];
 
}
- (IBAction)clickSwitchAccount:(id)sender {
    UserManagerViewController* vc = [[UserManagerViewController alloc] initWithNibName:@"UserManagerViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickSystemBtn:(id)sender {
    SystemSettingViewController* vc = [[SystemSettingViewController alloc] initWithNibName:@"SystemSettingViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
