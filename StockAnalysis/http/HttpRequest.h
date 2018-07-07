//
//  HttpRequest.h
//  StockAnalysis
//
//  Created by try on 2018/6/26.
//  Copyright © 2018年 try. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUDUtil.h"

@interface HttpRequest : NSObject

+(instancetype)getInstance;
-(instancetype)init;


-(NSDictionary *)postWithUrl:(NSString *)url data:(NSArray *)requestData notification:(NSString*)notice;
-(NSDictionary *)getWithUrl:(NSString *)url data:(NSDictionary *)requestData;

-(NSDictionary* )httpBack;

- (NSString *) md5:(NSString *) input;
@end
