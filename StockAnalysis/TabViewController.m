//
//  TabViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/12.
//  Copyright © 2018年 try. All rights reserved.
//

#import "TabViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "ForthViewController.h"
#import "HomeViewController.h"
#import "AllInfoViewController.h"
#import "UserFirstViewController.h"
#import "StoreViewController.h"
#import "TradeViewController.h"
#import "SocketInterface.h"
@interface TabViewController ()<UINavigationControllerDelegate>

@property(nonatomic,strong)UINavigationController* nav1;
@property(nonatomic,strong)UINavigationController* nav2;
@property(nonatomic,strong)UINavigationController* nav3;
@property(nonatomic,strong)UINavigationController* nav4;

@end

@implementation TabViewController

-(instancetype)init{
    
    self = [super init];
    if(self){
        self.viewControllers = [self getControllers];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAfterLogin) name:@"ChangeAfterLogin" object:nil];
//        self.tabBarController;
        self.tabBar.barStyle = UIBarStyleBlack;
        self.tabBar.barTintColor = [UIColor colorWithRed:38.0/225.0 green:45.0/255.0 blue:53.0/255.0 alpha:1.0];
        
//        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//        
//        backBtn.title = @"";//设置系统自带返回按键的标题
        self.navigationItem.leftBarButtonItem.title = @"";
    }
    return self;
}

-(NSArray*)getControllers{
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
//    islogin = NO;
    if(islogin){
        UserFirstViewController *c1 = [[UserFirstViewController alloc] initWithNibName:@"UserFirstViewController" bundle:nil];
        self.nav1 = [[UINavigationController alloc] initWithRootViewController:c1];
    }else{
        HomeViewController *c1 = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        self.nav1 = [[UINavigationController alloc] initWithRootViewController:c1];
    }

    [self.nav1 setNavigationBarHidden:YES];
    self.nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ZEDA" image:[UIImage imageNamed:@"tabbar_1_n"] selectedImage:[UIImage imageNamed:@"tabbar_1_s"]];
    
    AllInfoViewController *c2 = [[AllInfoViewController alloc] init];
    self.nav2 = [[UINavigationController alloc] initWithRootViewController:c2];
    self.nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"行情" image:[UIImage imageNamed:@"tabbar_2_n"] selectedImage:[UIImage imageNamed:@"tabbar_2_s"]];
    
    TradeViewController *c3 = [TradeViewController new];
    self.nav3 = [[UINavigationController alloc] initWithRootViewController:c3];
    self.nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"交易" image:[UIImage imageNamed:@"tabbar_3_n"] selectedImage:[UIImage imageNamed:@"tabbar_3_s"]];
    
    StoreViewController *c4 = [StoreViewController new];
    self.nav4 = [[UINavigationController alloc] initWithRootViewController:c4];
    self.nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"商城" image:[UIImage imageNamed:@"tabbar_4_n"] selectedImage:[UIImage imageNamed:@"tabbar_4_s"]];
    
//    self.nav1.navigationBar.backgroundColor = [UIColor colorWithRed:37.0/225.0 green:44.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    self.nav1.navigationBar.barStyle = UIBarStyleBlack;
    self.nav1.navigationBar.barTintColor =[UIColor colorWithRed:37.0/225.0 green:44.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    self.nav2.navigationBar.barStyle = UIBarStyleBlack;
    self.nav2.navigationBar.barTintColor =[UIColor colorWithRed:37.0/225.0 green:44.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    self.nav3.navigationBar.barStyle = UIBarStyleBlack;
    self.nav3.navigationBar.barTintColor =[UIColor colorWithRed:37.0/225.0 green:44.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    self.nav4.navigationBar.barStyle = UIBarStyleBlack;
    self.nav4.navigationBar.barTintColor =[UIColor colorWithRed:37.0/225.0 green:44.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    return @[self.nav1,self.nav2,self.nav3,self.nav4];
}

-(void)changeAfterLogin{
    self.viewControllers = [self getControllers];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tabBar.backgroundColor = kThemeColor;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *root = navigationController.viewControllers[0];
    
    if (root != viewController) {
        UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popAction:)];
        viewController.navigationItem.leftBarButtonItem = itemleft;
    }
}


- (void)popAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
