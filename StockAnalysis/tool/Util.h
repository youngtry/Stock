//
//  Util.h
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+ (UIImage *)imageWithColor:(UIColor *)color;

//获取当前view最先触及到的vc
+(UIViewController *)getParentVC:(UIView*)v;
+(UIViewController *)getParentVC:(Class)c fromView:(UIView*)v;
@end
