//
//  GameData.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/9.
//  Copyright © 2018年 try. All rights reserved.
//

#import "GameData.h"

@implementation GameData


+(void)setUserAccount:(NSString *)username{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:username forKey:@"Username"];
    
    [defaults synchronize];
}

+(NSString* )getUserAccount{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* username = [defaults stringForKey:@"Username"];
    return username;
}

+(void)setUserPassword:(NSString *)username{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:username forKey:@"LoginPassword"];
    
    [defaults synchronize];
}

+(NSString* )getUserPassword{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* username = [defaults stringForKey:@"LoginPassword"];
    return username;
}

@end
