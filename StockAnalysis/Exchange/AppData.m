//
//  AppData.m
//  StockAnalysis
//
//  Created by try on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AppData.h"

@interface AppData()
@property(nonatomic)int buttnIndex;
@property(nonatomic,strong)NSString* asset;
@property(nonatomic,strong)NSString* tempVerifyToken;
@property(nonatomic,strong)NSString* originTime;
@property(nonatomic,strong)NSMutableDictionary* trade;
@end

@implementation AppData

+(instancetype)getInstance{
    static AppData* Instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (Instance == nil){
            Instance = [[AppData alloc] init];
        }
    });
    
    return Instance;
}

-(instancetype)init{
    self = [super init];
    if(self){
        self.buttnIndex = 0;
        self.asset = @"";
        self.tempVerify = @"";
        self.originTime = @"";
        self.trade = [NSMutableDictionary new];
    }
    return self;
}

-(void)setExchangeButtonIndex:(int)index{
    self.buttnIndex = index;
}

-(int)getExchangeButtonIndex{
    return self.buttnIndex;
}

-(void)setAssetName:(NSString *)name{
    self.asset = name;
}

-(NSString*)getAssetName{
    return self.asset;
}

-(void)setTempVerify:(NSString *)verify{
    self.tempVerifyToken = verify;
}

-(NSString*)getTempVerify{
    return self.tempVerifyToken;
}
-(void)setOriginTime:(NSString *)originTime{
    _originTime = originTime;
}

-(NSString*)getOriginTime{
    return _originTime;
}

-(void)setTradeInfo:(NSDictionary *)info{
    [_trade removeAllObjects];
    _trade = info.mutableCopy;
}

-(NSDictionary*)getTradeInfo{
    return _trade;
}

@end
