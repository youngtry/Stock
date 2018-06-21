//
//  SortView.h
//  StockAnalysis
//
//  Created by ymx on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortView : UIView
-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)str;

@property(nonatomic,copy) void(^block)(BOOL);
@end
