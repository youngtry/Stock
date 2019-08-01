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

+(void)setDistrict:(NSString* )district;
+(NSString* )getDistrict;

+(void)setAccountList:(NSString*)account withPassword:(NSString*)pwd  withDistrict:(NSString*)district;
+(NSArray*)getAccountList;

+(void)setGuestureTime:(NSString*)time;
+(NSString*)getGuestureTime;

+(void)setNeedNoticeGuesture:(BOOL)isneed;
+(BOOL)getNeedNoticeGuesture;



@end
