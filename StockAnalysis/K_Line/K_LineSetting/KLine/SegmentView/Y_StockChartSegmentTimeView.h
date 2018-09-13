//
//  Y_StockChartSegmentTimeView.h
//  StockAnalysis
//
//  Created by try on 2018/8/3.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Y_StockChartSegmentTimeViewDelegate <NSObject>

- (void)y_StockChartSegmentTimeView:(NSInteger)index;

- (void)clickMenu:(NSInteger)index;

@end

@interface Y_StockChartSegmentTimeView : UIView
- (instancetype)initWithItems:(NSArray *)items;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id <Y_StockChartSegmentTimeViewDelegate> delegate;
@property (nonatomic, strong) UIView *timeView;

@property (nonatomic, strong) UIView *MAView;

@property (nonatomic, strong) UIView *MACDView;

@property (nonatomic, strong) UIView *settingView;

@property (nonatomic, assign) NSUInteger selectedIndex;
@end
