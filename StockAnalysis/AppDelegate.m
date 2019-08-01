//
//  AppDelegate.m
//  StockAnalysis
//
//  Created by try on 2018/5/18.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AppDelegate.h"
#import "TabViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self customeNavTabView];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    TabViewController *tab = [[TabViewController alloc] init];
    self.window.rootViewController = tab;
    return YES;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if(self.isEable) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    [userDefaults setObject:strDate forKey:@"ShowGuestureTime"];
    [userDefaults synchronize];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnlockGuesture" object:nil];
    
}




- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    [userDefaults setObject:strDate forKey:@"ShowGuestureTime"];
    [userDefaults synchronize];
    
}

-(void)customeNavTabView{
    [[UINavigationBar appearance] setTintColor:kTabGray];
    [[UINavigationBar appearance] setBarTintColor:kThemeColor];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [UINavigationBar appearance].translucent = NO;
    NSDictionary *titleAttribute = @{NSFontAttributeName:kTextFont(17),
                                     NSForegroundColorAttributeName:kTabGray};
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttribute];
    //去掉阴影线
    [UINavigationBar appearance].shadowImage = [UIImage new];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kTabYellow} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kTabGray} forState:UIControlStateNormal];
}
@end
