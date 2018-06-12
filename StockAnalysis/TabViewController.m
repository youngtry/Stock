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
@interface TabViewController ()

@end

@implementation TabViewController

-(instancetype)init{
    self = [super init];
    if(self){
        self.viewControllers = [self getControllers];
    }
    return self;
}

-(NSArray*)getControllers{
    FirstViewController *c1 = [FirstViewController new];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:c1];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ZEDA" image:[UIImage imageNamed:@"tabbar_1_n"] selectedImage:[UIImage imageNamed:@"tabbar_1_s"]];
    
    SecondViewController *c2 = [SecondViewController new];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:c2];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"行情" image:[UIImage imageNamed:@"tabbar_2_n"] selectedImage:[UIImage imageNamed:@"tabbar_2_s"]];
    
    ThirdViewController *c3 = [ThirdViewController new];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:c3];
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"交易" image:[UIImage imageNamed:@"tabbar_3_n"] selectedImage:[UIImage imageNamed:@"tabbar_3_s"]];
    
    ForthViewController *c4 = [ForthViewController new];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:c4];
    nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"商城" image:[UIImage imageNamed:@"tabbar_4_n"] selectedImage:[UIImage imageNamed:@"tabbar_4_s"]];
    
    return @[nav1,nav2,nav3,nav4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tabBar.backgroundColor = kThemeColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
