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
@property(nonatomic,strong)NSString* token;
@end

@implementation HttpRequest


+(instancetype)getInstance{
    static HttpRequest* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil){
            instance = [[HttpRequest alloc] init];
//            [instance initAFNetwork];
        }
    });
    
    return instance;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(NSDictionary* )httpBack{
    return _dataDictionary;
}

-(NSDictionary *)postWithUrl:(NSString *)url data:(NSArray *)requestData notification:(NSString *)notice{
    
    NSLog(@"token = %@",_token);
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                               //                               @"Content-Type": @"application/x-www-form-urlencoded",
                               @"authorization": [NSString stringWithFormat:@"Bearer %@",_token],
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
                                                        
                                                        _dataDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil ];
                                                        NSLog(@"post返回数据为：%@",_dataDictionary);
                                                        
                                                        if([url isEqualToString:@"http://exchange-test.oneitfarm.com/server/account/login/phone"] || [url isEqualToString:@"http://exchange-test.oneitfarm.com/server/account/login/email"]){
                                                            //登陆请求应答，保存新的account_token
                                                            NSNumber* number = [_dataDictionary objectForKey:@"ret"];
                                                            if([number intValue] == 1){
                                                                _token = [[_dataDictionary objectForKey:@"data"] objectForKey:@"account_token"];
                                                                NSLog(@"获取到的token = %@",_token);
                                                            }
                                                            
                                                        }
                                                        
                                                        dispatch_sync(dispatch_get_main_queue(), ^{
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:notice object:nil];
                                                        });
                                                        
                                                        
                                                    }
                                                }];

    [dataTask resume];
    return _dataDictionary;
}

-(void)clearToken{
    _token = @"";
}

-(NSDictionary *)getWithUrl:(NSString *)url notification:(NSString*)notice{
    
    
    NSDictionary *headers = @{ @"Authorization":[NSString stringWithFormat:@"Bearer %@",_token],
                               @"Cache-Control": @"no-cache",
                               @"Postman-Token": @"3fbc6071-4774-429b-a7f9-2b8456756b67" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        _dataDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil ];
                                                        NSLog(@"get返回数据为：%@",_dataDictionary);
                                                        
                                                        dispatch_sync(dispatch_get_main_queue(), ^{
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:notice object:nil];
                                                        });
                                                    }
                                                }];
    [dataTask resume];
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

-(void)postWithURL:(NSString*)url parma:(NSDictionary*)param block:(httpResult)block{
    // post请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self formatAFNetwork:manager];
    [manager POST:url parameters:param constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        // 成功
        DLog(@"xxxxsuccess!");
        NSData *data = responseObject;
        NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        block(1,s);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败
        DLog(@"xxxxxfailed!");
        block(0,nil);
    }];
}

-(void)getWithURL:(NSString*)url parma:(NSDictionary*)param block:(httpResult)block{
    // post请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self formatAFNetwork:manager];
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"xxxxsuccess!");
        NSData *data = responseObject;
        NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        block(1,s);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"xxxxxfailed!");
        block(0,nil);
    }];
}

-(void)formatAFNetwork:(AFHTTPSessionManager*)manager{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 请求参数类型
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/xml",@"text/html",@"text/plain", nil ];
    // 设置请求头参数
    [manager.requestSerializer setValue:@"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" forHTTPHeaderField:@"content-type"];
    [manager.requestSerializer setValue:@"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyOCwiYWNjb3VudF9pZCI6IjQwOTMzMjMxMzE0MTQ5ZWQ4OGFmOGEzYWRjNTM5YWQxIiwiY2lhY2NvdW50X3Rva2VuIjoiUVBkNmxoZmkwYUdCNDdURS5ydThPeHdLTWN2STRzbjBBLjVkNDFmYTE2N2RiNTQ4ZTNjN2U3MWJiZTdkMGQyZDRmIiwiZXhwIjoxNTMxMDM1MjY4fQ.8lLP9ztuKl4-la4Uxsh8nFzwBXG0RyVQvCkA7qXGWtw" forHTTPHeaderField:@"authorization"];
    [manager.requestSerializer setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    [manager.requestSerializer setValue:@"57bb5e1b-7c27-4f1d-a5c2-fd56b5604d38" forHTTPHeaderField:@"Postman-Token"];
}
@end
