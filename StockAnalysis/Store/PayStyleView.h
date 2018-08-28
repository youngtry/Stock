//
//  PayStyleView.h
//  StockAnalysis
//
//  Created by try on 2018/8/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DropMenuBlock)(int);


@interface PayStyleView : UIView
@property(nonatomic,copy)DropMenuBlock block;


-(instancetype)initWithFrame:(CGRect)frame withView:(UIView*) view;
- (void)showInView:(UIView *)view;


@end
