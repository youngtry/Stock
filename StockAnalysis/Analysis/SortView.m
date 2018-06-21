//
//  SortView.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SortView.h"
@implementation SortView{
    UILabel *_title;
    
    UIImageView* _up;
    UIImageView* _down;
    
    BOOL _isUp;
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)str{
    self = [super initWithFrame:frame];
    if(self){
        _isUp = YES;
        [self addLabel:str];
        [self addTriangle];
        self.width = _title.width + 10;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)addLabel:(NSString*)str{
    _title = [[UILabel alloc] init];
    _title.font = kTextFont(14);
    _title.text = str;
    _title.frame = CGRectMake(0, 0, 0, 0);
    [_title sizeToFit];
    [self addSubview:_title];
}

-(void)addTriangle{
    _up = [[UIImageView alloc] initWithImage:[SortView getTriangleImage:_isUp]];
    _up.left = _title.right + 2;
    _up.bottom = self.height/2-1;
    _up.transform = CGAffineTransformMakeRotation(M_PI);
    [self addSubview:_up];
    
    _down = [[UIImageView alloc] initWithImage:[SortView getTriangleImage:!_isUp]];
    _down.left = _title.right + 2;
    _down.top = self.height/2+1;
    [self addSubview:_down];
}

+ (UIImage *)triangleImageWithSize:(CGSize)size tintColor:(UIColor *)tintColor{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(size.width/2,size.height)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path closePath];
    CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
    [path fill];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+(UIImage*)getTriangleImage:(BOOL)isSelect{
    UIColor *col = isSelect?kThemeYellow:kColor(180, 180, 180);
    return [SortView triangleImageWithSize:CGSizeMake(6, 4) tintColor:col];
}

-(void)onStatusChanged{
    if(_isUp){
        [_up setImage:[SortView getTriangleImage:YES]];
        [_down setImage:[SortView getTriangleImage:NO]];
    }else{
        [_down setImage:[SortView getTriangleImage:YES]];
        [_up setImage:[SortView getTriangleImage:NO]];
    }
    
    if(self.block){
        self.block(_isUp);
    }
}

-(void)tap:(id)sender{
    _isUp = !_isUp;
    [self onStatusChanged];
}
@end
