//
//  HUDUtil.h
//
//
//  Created by ymx
//  Copyright (c) 2018年 ymx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#define kTipDelay           1
@interface HUDUtil : NSObject

/**
 @author ymx
 
 @brief  显示文字进度提示
 @param view    进度提示显示的容器
 @param message 进度提示消息
 */
+(void) showHudViewInSuperView:(UIView *) view withMessage:(NSString *)message;

/**
 @author ymx
 
 @brief  显示文字提示，并定时隐藏
 @param view    提示显示的容器
 @param message 提示消息
 */
+(void) showHudViewTipInSuperView:(UIView *) view withMessage:(NSString*) message;

/**
 @author ymx
 
 @brief  隐藏提示
 */
+(void) hideHudView;

/**
 @author ymx
 
 @brief  显示成功提示，并定时隐藏
 @param message 提示消息
 */
+(void) hideHudViewWithSuccessMessage:(NSString*) message;

/**
 @author ymx
 
 @brief  显示失败提示，并定时隐藏
 @param message 提示消息
 */
+(void) hideHudViewWithFailureMessage:(NSString *)message;

/**
 @author ymx
 
 @brief  显示自定义界面提示
 @param cursomView 自定义界面
 @param deltaY     y方向上的偏移量
 @param message    提示
 */
//+(void) showCustomView:(UIView*) cursomView byReduceDeltaY:(CGFloat) deltaY message:(NSString*) message;

/**
 @author ymx
 
 @brief  更新提示
 @param labelText 提示
 */
+(void) updateLabelText:(NSString*) labelText;


+(void)showSystemTipView:(UIViewController*)vc  title:(NSString *)title withContent:(NSString *)content;
@end
