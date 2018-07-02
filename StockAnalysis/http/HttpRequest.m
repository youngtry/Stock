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

-(NSDictionary *)postWithUrl:(NSString *)url data:(NSArray *)requestData{
    
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                               //                               @"Content-Type": @"application/x-www-form-urlencoded",
                               @"authorization": @"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyLCJhY2NvdW50X2lkIjoiOTBiMTYwYzEyNTliNDgzMTg1NjgxNGZmM2YyNDE2MTkiLCJjaWFjY291bnRfdG9rZW4iOiJqMG1GWTFOUDhRNUpvRVpwLlBMY01CZEE4RkkxUlp4dUsuMWVjMTcxNWU1OThkYTYzNmViNjFhNTdkMDM3ZjNhOGMiLCJleHAiOjE1MzAzNDY2MzF9.xCpz2bzjQAUUv62UeW4GKFCbnjw1OF8nNvZTbzNm5Q0",
                               @"Cache-Control": @"no-cache",
                               @"Postman-Token": @"57bb5e1b-7c27-4f1d-a5c2-fd56b5604d38" };
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
    NSError *error;
    NSMutableString *body = [NSMutableString string];
    for (NSDictionary *param in requestData) {
        [body appendFormat:@"--%@\r\n", boundary];
        if (param[@"fileName"]) {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
            if (error) {
                NSLog(@"%@", error);
            }
        } else {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
            [body appendFormat:@"%@\r\n", param[@"value"]];
        }
    }
    [body appendFormat:@"--%@--\r\n", boundary];
    NSLog(@"body = %@",body);
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    request.HTTPMethod = @"POST";
    request.allHTTPHeaderFields = headers;
    
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:NULL];
    request.HTTPBody = postData;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        //                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        //                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSDictionary* _dataDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil ];
                                                        NSLog(@"post返回数据为：%@",_dataDictionary);
                                                        NSString* msg = [_dataDictionary objectForKey:@"msg"];
                                                        NSLog(@"mesg = %@",msg);
                                                    }
                                                }];

    [dataTask resume];
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
