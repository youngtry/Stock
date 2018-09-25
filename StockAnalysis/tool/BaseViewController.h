//
//  BaseViewController.h
//  StockAnalysis
//
//  Created by try on 2018/9/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property(nonatomic,strong) UIButton * backButton;


-(void)navBackClick;

@end

NS_ASSUME_NONNULL_END
