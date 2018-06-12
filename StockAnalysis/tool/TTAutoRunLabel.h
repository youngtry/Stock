//
//  TTAutRunLabel.h
//  StockAnalysis
//
//  Created by try on 2018/6/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  TTAutoRunLabel;

typedef NS_ENUM(NSInteger, RunDirectionType){
    Leftype = 0,
    RightType = 1,
};


@protocol TTAutoRunLabelDelegate<NSObject>

@optional
-(void)operateLabel:(TTAutoRunLabel *)autoLabel animationDidStopFinished:(BOOL) finished;
@end

@interface TTAutoRunLabel : UIView

@property(nonatomic, weak)id<TTAutoRunLabelDelegate>delegate;
@property(nonatomic, assign)CGFloat speed;
@property(nonatomic, assign)RunDirectionType directionType;

-(void)addContentView:(UIView*)view;
-(void)startAnimation;
-(void)stopAnimation;
-(void)setRunViewColor:(UIColor*)color;
-(void)setCentviewColor:(UIColor*)color;

@end
