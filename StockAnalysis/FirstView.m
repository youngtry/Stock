//
//  FirstView.m
//  StockAnalysis
//
//  Created by try on 2018/5/28.
//  Copyright © 2018年 try. All rights reserved.
//

#import "FirstView.h"
#import "TTAutoRunLabel.h"

@interface FirstView()
@property(nonatomic)CGSize viewsize; //当前view的大小

@property(nonatomic,strong)UIView* topview;
@property(nonatomic,strong)UIButton* loginButton;
@property(nonatomic,strong)UILabel* username;
@property(nonatomic,strong)UIButton* purchaseButton;
@property(nonatomic,strong)UIButton* guideButton;

@end

@implementation FirstView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _viewsize = self.bounds.size;
        [self addSubview:self.topview];
        [self addSubview:self.loginButton];
        [self addSubview:self.purchaseButton];
        [self addSubview:self.guideButton];
//                [self addSubview:self.username];
    }
    
    return self;
}

-(void)addUI{
    _viewsize = self.bounds.size;
    [self addSubview:self.topview];
    [self addSubview:self.loginButton];
    [self addSubview:self.purchaseButton];
    [self addSubview:self.guideButton];
    [self createAutoRunLabel];
}

-(UIView*)topview{
    if(nil == _topview){
        _topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewsize.width, _viewsize.height*0.15)];
        [_topview setBackgroundColor:[UIColor blackColor]];
        [self setViewResizeMask:_topview];
        
        UIImageView* logoview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        [logoview setFrame:CGRectMake(_topview.frame.size.width*0.05, _topview.frame.size.height*0.3, _topview.frame.size.height*0.5, _topview.frame.size.height*0.5)];
        [_topview addSubview:logoview];
        
        UILabel* logotext = [[UILabel alloc] initWithFrame:CGRectMake(_topview.frame.size.width*0.23, _topview.frame.size.height*.3, _topview.frame.size.width*0.3, _topview.frame.size.height*0.5)];
        [logotext setText:@"ZEDA"];
        [logotext setTextColor:[UIColor whiteColor]];
        [logotext setTextAlignment:NSTextAlignmentLeft];
        [logotext setFont:[UIFont systemFontOfSize:30]];
        [_topview addSubview:logotext];
        
    }
    
    return _topview;
}

-(UIButton*)loginButton{
    if(nil == _loginButton){
        _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_loginButton setFrame:CGRectMake(_topview.frame.size.width*0.7, _topview.frame.size.height*0.3, _topview.frame.size.width*0.3, _topview.frame.size.height*0.5)];
        [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    return _loginButton;
}

-(UIButton*)purchaseButton{
    if(nil == _purchaseButton){
        _purchaseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_purchaseButton setFrame:CGRectMake(_viewsize.width*0.04, _viewsize.height*0.18, _viewsize.width*0.43, _viewsize.height*0.13)];
        [_purchaseButton setTitle:@"股票购买" forState:UIControlStateNormal];
        [_purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_purchaseButton setBackgroundColor:[UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:191.0/255.0 alpha:1.0]];
        [_purchaseButton.layer setCornerRadius:10.0];
        
    }
    
    return _purchaseButton;
}

-(UIButton*)guideButton{
    if(nil == _guideButton){
        _guideButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_guideButton setFrame:CGRectMake(_viewsize.width*0.51, _viewsize.height*0.18, _viewsize.width*0.43, _viewsize.height*0.13)];
        [_guideButton setTitle:@"新手指导" forState:UIControlStateNormal];
        [_guideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_guideButton setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:129.0/255.0 blue:199.0/255.0 alpha:1.0]];
        [_guideButton.layer setCornerRadius:10.0];
        
    }
    
    return _guideButton;
}

-(UILabel*)username{
    if(nil == _username){
        _username = [[UILabel alloc] initWithFrame:CGRectMake(_topview.frame.size.width*0.7, _topview.frame.size.height*0.3, _topview.frame.size.width*0.3, _topview.frame.size.height*0.5)];
        [_username setText:@"username"];
        [_username setTextColor:[UIColor whiteColor]];
        [_username setTextAlignment:NSTextAlignmentLeft];
        [_username setFont:[UIFont systemFontOfSize:20]];
        
    }
    
    return _username;
}


-(void)createAutoRunLabel{
    TTAutoRunLabel* runLabel = [[TTAutoRunLabel alloc] initWithFrame:CGRectMake(_viewsize.width*0.05, _viewsize.height*0.33, _viewsize.width*0.9, 32)];
    runLabel.delegate = self;
    runLabel.directionType = Leftype;
    [runLabel setRunViewColor:[UIColor colorWithRed:16./255.0 green:142.0/255.0 blue:233.0/255.0 alpha:0.1]];
    [self addSubview:runLabel];
//    [runLabel addContentView:[self createLabelWithText:@"繁华声 遁入空门 折煞了梦偏冷 辗转一生 情债又几 如你默认 生死枯等 枯等一圈 又一圈的 浮图塔 断了几层 断了谁的痛直奔 一盏残灯 倾塌的山门 容我再等 历史转身 等酒香醇 等你弹 一曲古筝" textColor:[self randomColor] labelFont:[UIFont systemFontOfSize:14]]];
    [runLabel startAnimation];
}

-(UILabel*)createLabelWithText:(NSString* )text textColor:(UIColor* )textColor labelFont:(UIFont *)font{
    NSString* string = [NSString stringWithFormat:@"%@",text];
    CGFloat width = string.length*14;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width, 32)];
    label.font = font;
    label.text = string;
    label.textColor = textColor;
    return label;
}

-(UIColor *)randomColor {
    return [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
}

-(CGFloat)randomValue{
    return arc4random()%255/255.0f;
}


-(void)setViewResizeMask:(UIView*) subview{
    //设置子视图适应方式
    subview.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin   |
    UIViewAutoresizingFlexibleWidth        |
    UIViewAutoresizingFlexibleRightMargin  |
    UIViewAutoresizingFlexibleTopMargin    |
    UIViewAutoresizingFlexibleHeight       |
    UIViewAutoresizingFlexibleBottomMargin ;
}

@end
