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
-(instancetype)initWithFrame:(CGRect)frame target:(id)target titles:(NSMutableArray*)titles rowHeight:(CGFloat)rowHeight index:(int)index;
@property(nonatomic,strong)NSMutableArray* images;
@property(nonatomic,copy)DropMenuBlock block;

@end
