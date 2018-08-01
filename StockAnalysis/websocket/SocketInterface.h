//
//  SocketInterface.h
//  StockAnalysis
//
//  Created by try on 2018/7/31.
//  Copyright © 2018年 try. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocketDelegate
@required
-(void)getWebData:(id)message withName:(NSString*)name;
@end

@interface SocketInterface : NSObject

@property(retain,nonatomic)id delegate;
@property(strong,nonatomic)NSString* requestMethod;
+(instancetype)sharedManager;
-(void)closeWebSocket;
-(void)openWebSocket;
-(void)sendRequest:(NSString*)request withName:(NSString*)name;
@end
