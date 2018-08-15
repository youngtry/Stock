//
//  SADropMenu.h
//  StockAnalysis
//
//  Created by ymx on 2018/8/15.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DropMenuBlock)(int);
@interface SADropMenu : UIView
-(instancetype)initWithFrame:(CGRect)frame titles:(NSMutableArray*)titles rowHeight:(CGFloat)rowHeight;
@property(nonatomic,copy)DropMenuBlock block;
@end
