//
//  SocketInterface.m
//  StockAnalysis
//
//  Created by try on 2018/7/31.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SocketInterface.h"
#import <SocketRocket/SRWebSocket.h>
#import "JSONKit.h"

static SocketInterface* _instance = nil;
static int _tryTime = 0;
@interface SocketInterface()<SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
    id response;
    NSMutableArray* requestArray;
    NSTimer* _update1;
    BOOL isReconnect;
    NSMutableArray* reRequest;
    AFNetworkReachabilityManager *manager;
    BOOL isHasNetwork;
}
@end

@implementation SocketInterface

+(instancetype)sharedManager{
    if(!_instance){
        _instance = [[SocketInterface alloc] init];
    }
    return _instance;
}

-(instancetype)init{
    self = [super init];
    if(self){
//        [self reconnect:nil];
        response = nil;
        requestArray = [NSMutableArray new];
        self.requestMethod = @"";
        
        reRequest = [NSMutableArray new];
        isReconnect = NO;
        isHasNetwork = YES;
        
        manager = [AFNetworkReachabilityManager sharedManager];
        
        [self getCurrentNetworkState];
    }
    return self;
}

-(void)sendPing{
    if(nil == _webSocket){
        if(isHasNetwork){
            [self reconnect:nil];
        }
    }
    
    NSArray *dicParma = @[];
    
    //    NSLog(@"Websocket Connected");
    
    NSDictionary *dicAll = @{@"method":@"server.ping",@"params":dicParma,@"id":@(PN_ServerPing)};
    
    NSString *strAll = [dicAll JSONString];
    [self sendRequest:strAll withName:@"server.ping"];
}

- (void)reconnect:(id)sender
{

    [_delegate getWebData:nil withName:@"closed"];
    
    if(_update1){
        [_update1 invalidate];
        _update1 = nil;
    }
    
    
}

-(void)closeWebSocket{
    [_webSocket close];
    _webSocket = nil;
}

-(void)openWebSocket{
    
    if(!_webSocket){
        if (!isReconnect) {
             _webSocket.delegate = nil;
        }
       
        [_webSocket close];
        
        _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"wss://exchange-test2.oneitfarm.com/app/viabtctest/ws"]];
        _webSocket.delegate = self;
        
        //    self.title = @"Opening Connection...";
        [_webSocket open];
        NSLog(@"websocket connecting……");

    }
    
}

-(void)sendRequest:(NSString *)request withName:(NSString*)name{
//    NSLog(@"sendResuet : %@ ,%@",name,request);
    self.requestMethod = name;
//    request = @"{\"method\":\"kline.query\",\"params\":[\"LDGFRMB\",1533571200,1533600000,600],\"id\":1}";
    if(_webSocket && _webSocket.readyState == SR_OPEN ){
        [_webSocket send:request];
    }else{
        [requestArray addObject:request];
        
    }
}

///--------------------------------------
#pragma mark - SRWebSocketDelegate
///--------------------------------------


- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    [reRequest removeAllObjects];
    
    NSLog(@":( Websocket open %ld",(long)webSocket.readyState);
    for (NSString* request in requestArray) {
        [self sendRequest:request withName:@""];
    }
    
    [requestArray removeAllObjects];
    
    _tryTime = 0;
    
    if(_update1){
        [_update1 invalidate];
        _update1 = nil;
    }
    
    _update1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
    //    [_update1 fire];
    
    [[NSRunLoop mainRunLoop] addTimer:_update1 forMode:NSDefaultRunLoopMode];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@ ", error);
    
    _webSocket = nil;
    
    
    
    if(_tryTime<= 1){
        _tryTime ++;
        [self openWebSocket];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(nonnull NSString *)string
{
    NSLog(@"Received \"%@\"", string);

}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    [requestArray removeAllObjects];
    _webSocket = nil;

    
    [_delegate getWebData:nil withName:@"closed"];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"WebSocket received pong");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
//    NSLog(@"didReceiveMessage = %@", message);
    NSString* str = message;
    NSData* strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
    if([data objectForKey:@"method"]){
        self.requestMethod = [data objectForKey:@"method"];
        if([[data objectForKey:@"method"] isEqualToString:@"server.ping"]){
            NSLog(@"ping");
        }
    }
 
    NSObject* err =[data objectForKey:@"error"];
    
    if(![err isKindOfClass:[NSNull class]]){
        
        [HUDUtil showHudViewTipInSuperView:[UIApplication sharedApplication].keyWindow.rootViewController.view withMessage:Localize(@"Server_Error")];
        return;
    }
    
    [_delegate getWebData:message withName:self.requestMethod];
}


#pragma mark - 获取当前网络状态

/**
 
 *  获取当前网络状态
 
 *
 
 *  0:无网络 & 1:2G & 2:3G & 3:4G & 5:WIFI
 
 */

- (void)getCurrentNetworkState {
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未知");
                isHasNetwork = NO;
            }
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无网络");
                isHasNetwork = NO;
            }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                isHasNetwork = YES;
                NSLog(@"手机自带网络");
            }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                isHasNetwork = YES;
                NSLog(@"WIFI");
            }
                break;
        }
    }];
    
    [manager startMonitoring];
}




@end
