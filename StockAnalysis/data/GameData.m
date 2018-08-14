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

+(void)setAccountList:(NSString *)account withPassword:(NSString *)pwd{
    
    NSMutableDictionary* acc = [NSMutableDictionary new];
    [acc setObject:pwd forKey:@"password"];
    [acc setObject:account forKey:@"account"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* acclist = [defaults objectForKey:@"AccountList"] ;
    
    if(!acclist){
        acclist = [NSArray new];
    }
    
    for (NSDictionary* info in acclist) {
        NSLog(@"所存储的账号:%@",info);
        if([[info objectForKey:@"account"] isEqualToString:account]){
            NSLog(@"所存账号已存在");
            return;
        }
    }
    
    NSMutableArray* temp = [[NSMutableArray alloc] initWithArray:acclist];
    
    [temp addObject:acc];
    
    [defaults setObject:temp forKey:@"AccountList"];
    
    [defaults synchronize];
}

+(NSArray*)getAccountList{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* acclist = [defaults objectForKey:@"AccountList"];
    
    return acclist;
}

@end
