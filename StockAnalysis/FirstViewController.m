//
//  FirstViewController.m
//  StockAnalysis
//
//  Created by try on 2018/5/18.
//  Copyright © 2018年 try. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstView.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
@interface FirstViewController ()
@property (strong, nonatomic) IBOutlet FirstView *firstview;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    _firstview = [[FirstView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [self.view addSubview:_firstview];
//    [_firstview addUI];
    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Login") style:UIBarButtonItemStylePlain target:self action:@selector(clickLogin:)];
//    self.navigationItem.rightBarButtonItem = right;
//
//    self.title = @"ZEDA";
    
    HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickLogin:(id)sender{
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    //返回白色
    return UIStatusBarStyleLightContent;
    //返回黑色
    //return UIStatusBarStyleDefault;
}

@end
