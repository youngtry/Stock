//
//  SearchData.h
//  StockAnalysis
//
//  Created by try on 2018/7/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchData : NSObject

@property(nonatomic,strong)NSMutableArray* searchList;
@property(nonatomic,strong)NSMutableArray* searchHistoryList;
@property(nonatomic,strong)NSMutableArray* specialList;

+(instancetype) getInstance;
-(instancetype) init;

-(void)addData;

-(void)addhistory:(NSDictionary*)history;
-(void)addSpecail:(NSDictionary*)specail;

-(void)clearHistory;


-(NSMutableArray*)getHistory;

-(NSMutableArray*)getSpecail;

@end
