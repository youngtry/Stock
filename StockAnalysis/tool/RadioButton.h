//
//  RadioButton.h
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : UIView
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles selectIndex:(NSInteger)index;
@property(nonatomic,copy) void(^indexChangeBlock)(NSInteger);

-(void)reloadFrame:(CGRect)frame;

-(void)setSelectIndex:(NSInteger) select;
@end
