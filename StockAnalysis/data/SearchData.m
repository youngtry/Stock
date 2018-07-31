//
//  SearchData.m
//  StockAnalysis
//
//  Created by try on 2018/7/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SearchData.h"

@interface SearchData(){
    
}
@end


@implementation SearchData

+(instancetype) getInstance{
    
    static SearchData* Instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (Instance == nil){
            Instance = [[SearchData alloc] init];
        }
    });
    
    return Instance;
}

-(instancetype)init{
    self = [super init];
    if(self){
        self.searchHistoryList = [[NSMutableArray alloc] init];
        self.specialList = [[NSMutableArray alloc] init];
        self.searchList = [[NSMutableArray alloc] init];
        [self addData];
    }
    return self;
}

-(void)addData{
    NSMutableArray* list = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HistoryList"] mutableCopy];
    NSLog(@"list.count = %ld",list.count);
    if(list.count>0){
        self.searchHistoryList = list;
    }
}

-(void)addhistory:(NSDictionary*)history{
    
    for (NSDictionary* info in self.searchHistoryList) {
        if([history objectForKey:@"asset"]){
            //商户搜索
            if([info objectForKey:@"asset"]){
                if([[info objectForKey:@"asset"] isEqualToString:[history objectForKey:@"asset"]]){
                    return;
                }
            }
        }else if([history objectForKey:@"market"]){
            if([info objectForKey:@"market"]){
                if([[info objectForKey:@"market"] isEqualToString:[history objectForKey:@"market"]]){
                    return;
                }
            }
        }
    }
    
    
    [self.searchHistoryList addObject:history];

    [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryList forKey:@"HistoryList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)addSpecail:(NSDictionary*)specail{
    
    [self.specialList addObject:specail];
    
//    [[NSUserDefaults standardUserDefaults] setObject:specialList forKey:@"SpecialList"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)clearHistory{
    [self.searchHistoryList removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryList forKey:@"HistoryList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray*)getHistory{
    return self.searchHistoryList;
}

-(NSMutableArray*)getSpecail{
    return self.specialList;
}


@end
