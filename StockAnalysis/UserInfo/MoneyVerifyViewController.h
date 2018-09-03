//
//  MoneyVerifyViewController.h
//  StockAnalysis
//
//  Created by try on 2018/9/3.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputMoneyPassword)(BOOL);

@interface MoneyVerifyViewController : UIViewController
@property(nonatomic,copy)InputMoneyPassword block;
@end
