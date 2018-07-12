//
//  HttpRequest.h
//  StockAnalysis
//
//  Created by try on 2018/6/26.
//  Copyright © 2018年 try. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUDUtil.h"
#import "AFNetworking.h"

typedef void(^httpResult)(BOOL success,id data);

@interface HttpRequest : NSObject

+(instancetype)getInstance;
-(instancetype)init;


-(NSDictionary *)postWithUrl:(NSString *)url data:(NSArray *)requestData notification:(NSString*)notice;
-(NSDictionary *)getWithUrl:(NSString *)url notification:(NSString*)notice;

-(NSDictionary* )httpBack;
-(void)clearToken;

- (NSString *) md5:(NSString *) input;



-(void)postWithURL:(NSString*)url parma:(NSDictionary*)param block:(httpResult)block;
-(void)getWithURL:(NSString*)url parma:(NSDictionary*)param block:(httpResult)block;
@end
