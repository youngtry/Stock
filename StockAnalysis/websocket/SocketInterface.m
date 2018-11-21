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
        [self reconnect:nil];
        response = nil;
        requestArray = [NSMutableArray new];
        self.requestMethod = @"";
    }
    return self;
}

- (void)reconnect:(id)sender
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"ws://exchange-test.oneitfarm.com/ws"]];
    _webSocket.delegate = self;
    
//        self.title = @"Opening Connection...";
    [_webSocket open];
    
    
}

-(void)closeWebSocket{
    [_webSocket close];
    _webSocket = nil;
}

-(void)openWebSocket{
    if(!_webSocket){
        _webSocket.delegate = nil;
        [_webSocket close];
        
        _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"ws://exchange-test.oneitfarm.com/ws"]];
        _webSocket.delegate = self;
        
        //    self.title = @"Opening Connection...";
        [_webSocket open];
        NSLog(@"websocket connecting……");
    }
    
}

-(void)sendRequest:(NSString *)request withName:(NSString*)name{
    NSLog(@"sendResuet : %@ ,%@",name,request);
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
    NSLog(@":( Websocket open %ld",(long)webSocket.readyState);
    for (NSString* request in requestArray) {
        [self sendRequest:request withName:@""];
    }
    
    [requestArray removeAllObjects];
    
    _tryTime = 0;
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
    }
    
    [_delegate getWebData:message withName:self.requestMethod];
}


@end
