//
//  TTAutRunLabel.m
//  StockAnalysis
//
//  Created by try on 2018/6/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "TTAutoRunLabel.h"

@interface TTAutoRunLabel()<CAAnimationDelegate,UIScrollViewDelegate>{
    CGFloat _width;
    CGFloat _height;
    CGFloat _animationViewWidth;
    CGFloat _animationViewHeight;
    BOOL _stoped;
    UIView* _contentView;
}

@property (nonatomic, strong) UIView* animationView;
@property (strong, nonatomic) UIScrollView * verticalScroll;
@property (strong, nonatomic) NSMutableArray * titleArrays;
@property (strong, nonatomic) NSTimer * myTimer;

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
        
        self.backgroundColor = [UIColor colorWithRed:16./255.0 green:142.0/255.0 blue:233.0/255.0 alpha:0.0];
        self.speed = 4.0f;
        self.directionType = Leftype;
        self.layer.masksToBounds = YES;
        self.animationView = [[UIView alloc] initWithFrame:CGRectMake(_width, 0, _width, _height)];
        [self addSubview:self.animationView];
        _contentTag = -1;
    }
    
    return self;
}

-(void)changeScrollContentOffSetY{
    //启动定时器
    CGPoint point = self.verticalScroll.contentOffset;
    [self.verticalScroll setContentOffset:CGPointMake(0, point.y+CGRectGetHeight(self.verticalScroll.frame)) animated:YES];
}


-(UIScrollView *)verticalScroll{
    if (!_verticalScroll) {
        _verticalScroll = [[UIScrollView alloc]init];
        _verticalScroll.center = CGPointMake(self.centerX, self.centerY);
        _verticalScroll.bounds = CGRectMake(0, 0, self.width, self.height);
        //_verticalScroll.pagingEnabled = YES;
        _verticalScroll.showsVerticalScrollIndicator = NO;
        _verticalScroll.scrollEnabled = NO;
        _verticalScroll.bounces = NO;
        _verticalScroll.delegate = self;
        
        [self addSubview:_verticalScroll];
        
    }
    return _verticalScroll;
}

-(void)addContent{
    CGFloat scaleH = 20;
    CGFloat Height = 20;
    CGFloat H = 0;
    for (int i =0; i<self.titleArrays.count; i++) {
        UIView* childview = self.titleArrays[i];
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(10, H+scaleH, CGRectGetWidth(_verticalScroll.frame)-20, Height);
//        [button setTitle:self.titleArrays[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        button.tag = i+10;
        [_verticalScroll addSubview:childview];
        
        
        H = childview.frame.origin.y+childview.frame.size.height+scaleH;
    }
    _verticalScroll.contentSize = CGSizeMake(0, H);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y==scrollView.contentSize.height-CGRectGetHeight(self.verticalScroll.frame)){
        [scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.verticalScroll.frame))];
    }
}


-(void)setRunViewColor:(UIColor *)color{
//    self.backgroundColor = [UIColor colorWithRed:16./255.0 green:142.0/255.0 blue:233.0/255.0 alpha:0.1];
    self.backgroundColor = color;
}



-(void)addContentView:(UIView *)view{
    _contentTag = view.tag;
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
    NSLog(@"_animationViewWidth = %f",_animationViewWidth);
//    moveAnimation.duration = _animationViewWidth;
    moveAnimation.duration = 4.0;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    moveAnimation.speed = 0.08;
    moveAnimation.delegate = self;
    moveAnimation.calculationMode = kCAAnimationLinear;
    [self.animationView.layer addAnimation:moveAnimation forKey:@"animationViewPosition"];
    
}

-(void)stopAnimation{
    _stoped = YES;
    [self.animationView.layer removeAnimationForKey:@"animationViewPosition"];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(flag && self.delegate && [self.delegate respondsToSelector:@selector( operateLabel: animationDidStopFinished: )]){
        [self.delegate operateLabel:self animationDidStopFinished:flag];
    }
    if(flag && !_stoped){
        [self startAnimation];
    }
}

@end

















