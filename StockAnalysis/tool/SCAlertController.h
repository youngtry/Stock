//
//  SCAlertController.h
//  StockAnalysis
//
//  Created by try on 2018/8/28.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCAlertAction : UIAlertAction

@property (nonatomic,strong) UIColor *textColor; /**< 按钮title字体颜色 */

@end

@interface SCAlertController : UIAlertController

@property (nonatomic,strong) UIColor *tintColor; /**< 统一按钮样式 不写系统默认的蓝色 */
@property (nonatomic,strong) UIColor *titleColor; /**< 标题的颜色 */
@property (nonatomic,strong) UIColor *messageColor; /**< 信息的颜色 */

@end
