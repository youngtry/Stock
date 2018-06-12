//
//  TTAutRunLabel.m
//  StockAnalysis
//
//  Created by try on 2018/6/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "TTAutoRunLabel.h"

@interface TTAutoRunLabel()<CAAnimationDelegate>{
    CGFloat _width;
    CGFloat _height;
    CGFloat _animationViewWidth;
    CGFloat _animationViewHeight;
    BOOL _stoped;
    UIView* _contentView;
}

@property (nonatomic, strong)UIView* animationView;

@end


@implementation TTAutoRunLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame: frame]){
        _width = frame.size.width;
        _height = frame.size.height;
        
        self.backgroundColor = [UIColor colorWithRed:16./255.0 green:142.0/255.0 blue:233.0/255.0 alpha:0.1];
        self.speed = 1.0f;
        self.directionType = Leftype;
        self.layer.masksToBounds = YES;
        self.animationView = [[UIView alloc] initWithFrame:CGRectMake(_width, 0, _width, _height)];
        [self addSubview:self.animationView];
    }
    
    return self;
}

-(void)setRunViewColor:(UIColor *)color{
//    self.backgroundColor = [UIColor colorWithRed:16./255.0 green:142.0/255.0 blue:233.0/255.0 alpha:0.1];
    self.backgroundColor = color;
}



-(void)addContentView:(UIView *)view{
    [_contentView removeFromSuperview];
    view.frame = view.bounds;
    _contentView = view;
    self.animationView.frame = view.bounds;


    [self.animationView addSubview:_contentView];
    
    _animationViewWidth = self.animationView.frame.size.width;
    _animationViewHeight = self.animationView.frame.size.height;
    
}

-(void)setCentviewColor:(UIColor *)color{
    
}

-(void)startAnimation{
    [self.animationView.layer removeAnimationForKey:@"animationViewPosition"];
    _stoped = NO;
    
    CGPoint pointRightCenter = CGPointMake(_width+_animationViewWidth/2.f, _animationViewHeight/2.f);
    CGPoint pointLeftCenter = CGPointMake(-_animationViewWidth/2, _animationViewHeight/2);
    CGPoint fromPoint = self.directionType == Leftype?pointRightCenter:pointLeftCenter;
    CGPoint toPoint = self.directionType == Leftype?pointLeftCenter:pointRightCenter;
    
    self.animationView.center = fromPoint;
    UIBezierPath* movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    [movePath addLineToPoint:toPoint];
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path = movePath.CGPath;
    moveAnimation.removedOnCompletion = YES;
    moveAnimation.duration = _animationViewWidth/30.f*(1/self.speed);
    moveAnimation.delegate = self;
    [self.animationView.layer addAnimation:moveAnimation forKey:@"animationViewPosition"];
    
}

-(void)stopAnimation{
    _stoped = YES;
    [self.animationView.layer removeAnimationForKey:@"animationViewPosition"];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(self.delegate && [self.delegate respondsToSelector:@selector( operateLabel: animationDidStopFinished: )]){
        [self.delegate operateLabel:self animationDidStopFinished:flag];
    }
    if(flag && !_stoped){
        [self startAnimation];
    }
}

@end

















