//
//  AppData.h
//  StockAnalysis
//
//  Created by try on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject

+(instancetype)getInstance;

-(instancetype)init;
-(void)setExchangeButtonIndex:(int)index;
-(int)getExchangeButtonIndex;

-(void)setAssetName:(NSString*)name;
-(NSString*)getAssetName;

-(void)setTempVerify:(NSString* )verify;
-(NSString* )getTempVerify;
@end
