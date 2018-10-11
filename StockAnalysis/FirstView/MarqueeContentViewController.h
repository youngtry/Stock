//
//  MarqueeContentViewController.h
//  StockAnalysis
//
//  Created by try on 2018/10/11.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^showContent)(void);

@interface MarqueeContentViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property(nonatomic,copy) showContent block;

@end

NS_ASSUME_NONNULL_END
