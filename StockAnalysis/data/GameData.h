//
//  GameData.h
//  StockAnalysis
//
//  Created by Macbook on 2018/7/9.
//  Copyright © 2018年 try. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject

+(void)setUserAccount:(NSString* )username;
+(NSString* )getUserAccount;

+(void)setUserPassword:(NSString* )password;
+(NSString* )getUserPassword;

+(void)setAccountList:(NSString*)account withPassword:(NSString*)pwd;
+(NSArray*)getAccountList;

+(void)setGuestureTime:(NSString*)time;
+(NSString*)getGuestureTime;



@end
