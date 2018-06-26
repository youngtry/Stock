//
//  HttpRequest.m
//  StockAnalysis
//
//  Created by try on 2018/6/26.
//  Copyright © 2018年 try. All rights reserved.
//

#import "HttpRequest.h"
#import<CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <net/if.h>

@interface HttpRequest()
@property(nonatomic,strong)NSDictionary* dataDictionary;
@end

@implementation HttpRequest


+(instancetype)getInstance{
    static HttpRequest* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil){
            instance = [[HttpRequest alloc] init];
        }
    });
    
    return instance;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(NSDictionary *)postWithUrl:(NSString *)url data:(NSDictionary *)requestData{
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:NULL];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil){
            /*
             请求完成,成功或者失败的处理
             */
            
            _dataDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil ];
            NSLog(@"post返回数据为：%@",_dataDictionary);

        }else{
            /*
             请求失败
             */
        }
    }];
    [sessionDataTask resume];
    return _dataDictionary;
}

-(NSDictionary *)getWithUrl:(NSString *)url data:(NSDictionary *)requestData{
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
//    request.HTTPMethod = @"POST";
//
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:NULL];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil){
            /*
             请求完成,成功或者失败的处理
             */
            
            _dataDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil ];
            NSLog(@"get返回数据为：%@",_dataDictionary);
            
        }else{
            /*
             请求失败
             */
        }
    }];
    [sessionDataTask resume];
    return _dataDictionary;
}

- (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    //    NSLog(@"output = %@",output);
    
    return  output;
}

@end
