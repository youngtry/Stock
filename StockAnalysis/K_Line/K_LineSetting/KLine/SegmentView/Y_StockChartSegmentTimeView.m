//
//  Y_StockChartSegmentTimeView.m
//  StockAnalysis
//
//  Created by try on 2018/8/3.
//  Copyright © 2018年 try. All rights reserved.
//

#import "Y_StockChartSegmentTimeView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"



static NSInteger const Y_StockChartSegmentStartTag = 2000;


@interface Y_StockChartSegmentTimeView(){
    
}


@end

@implementation Y_StockChartSegmentTimeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor assistBackgroundColor];
    }
    return self;
}

-(UIView*)timeView{
    if(!_timeView)
    {
        _timeView = [UIView new];
        _timeView.backgroundColor = [UIColor assistBackgroundColor];
        _timeView.userInteractionEnabled = YES;
        NSArray *titleArr = @[@"分时",@"1分",@"3分",@"5分",@"15分",@"30分",@"1小时",@"2小时",@"4小时",@"6小时",@"12小时",@"1天",@"1周"];
        __block UIButton *preBtn;
        [titleArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = Y_StockChartSegmentStartTag + 100 + idx;
            [btn addTarget:self action:@selector(timeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [_timeView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                float left = 50*(idx%5);
                //                float top = _timeView.height/3*(((float)(idx/5)));
                //                NSLog(@"左边为:%f",left);
                make.height.equalTo(_timeView).multipliedBy(1.0/3.0);
                make.width.equalTo(_timeView).multipliedBy(1.0/5.0);
                make.left.mas_equalTo(left);
                //                make.top.equalTo
                
                if(preBtn)
                {
                    float top = (((float)(idx/5)));
                    NSLog(@"上边为:%f,height = %f",top,preBtn.frame.size.height);
                    if(idx<5){
                        make.top.equalTo(_timeView);
                    }else{
                        make.top.equalTo(preBtn.mas_bottom);
                    }
                    
                } else {
                    make.top.equalTo(_timeView);
                }
                
            }];
            
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithRed:52.f/255.f green:56.f/255.f blue:67/255.f alpha:1];
            [_timeView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(btn);
                make.top.equalTo(btn.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            if(idx == 4 || idx == 9){
                preBtn = btn;
            }
            
        }];
        [self addSubview:_timeView];
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self);
            make.right.equalTo(self.mas_left);
        }];
    }
    return _timeView;
}

-(UIView*)MAView{
    if(!_MAView)
    {
        _MAView = [UIView new];
        _MAView.backgroundColor = [UIColor assistBackgroundColor];
        _MAView.userInteractionEnabled = YES;
        NSArray *titleArr = @[@"MA",@"EMA",@"BOLL",@"SAR",@"关闭"];
        __block UIButton *preBtn;
        [titleArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = Y_StockChartSegmentStartTag + 100 + idx;
            [btn addTarget:self action:@selector(maButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [_MAView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {

                make.height.equalTo(_MAView);
                make.width.equalTo(_MAView).multipliedBy(1.0/5.0);
                make.top.equalTo(_MAView);
                if(preBtn){
                    make.left.equalTo(preBtn.mas_right);
                }else{
                    make.left.equalTo(_MAView);
                }
                
            }];
            preBtn = btn;
            
        }];
        [self addSubview:_MAView];
        [_MAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self);
            make.right.equalTo(self.mas_left);
        }];
    }
    return _MAView;
}

-(UIView*)MACDView{
    if(!_MACDView)
    {
        _MACDView = [UIView new];
        _MACDView.backgroundColor = [UIColor assistBackgroundColor];
        _MACDView.userInteractionEnabled = YES;
        NSArray *titleArr = @[@"MACD",@"KDJ",@"BOLL",@"RSI",@"StochRSI",@"OBV",@"SAR",@"DMA",@"TRIX",@"VR",@"BRAR",@"EMV",@"WR",@"ROC",@"MTM",@"PSY",@"DMI",@"CCI",@"关闭"];
        __block UIButton *preBtn;
        [titleArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.tag = Y_StockChartSegmentStartTag + 100 + idx;
            [btn addTarget:self action:@selector(macdButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [_MACDView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                float left = 50*(idx%5);
                make.height.equalTo(_MACDView).multipliedBy(1.0/4.0);
                make.width.equalTo(_MACDView).multipliedBy(1.0/5.0);
                make.left.mas_equalTo(left);
                
                if(preBtn)
                {
                    float top = (((float)(idx/5)));
                    NSLog(@"上边为:%f,height = %f",top,preBtn.frame.size.height);
                    if(idx<5){
                        make.top.equalTo(_MACDView);
                    }else{
                        make.top.equalTo(preBtn.mas_bottom);
                    }
                    
                } else {
                    make.top.equalTo(_MACDView);
                }
                
            }];
            
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithRed:52.f/255.f green:56.f/255.f blue:67/255.f alpha:1];
            [_MACDView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(btn);
                make.top.equalTo(btn.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            if(idx == 4 || idx == 9 || idx == 14){
                preBtn = btn;
            }
            
        }];
        [self addSubview:_MACDView];
        [_MACDView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self);
            make.right.equalTo(self.mas_left);
        }];
    }
    return _MACDView;
}

-(UIView*)settingView{
    if(!_settingView)
    {
        _settingView = [UIView new];
        _settingView.backgroundColor = [UIColor assistBackgroundColor];
        _settingView.userInteractionEnabled = YES;
        NSArray *titleArr = @[@"MA",@"5",@"10",@"20",@"60",@"默认",@"MACD",@"12",@"26",@"9",@"默认",@"+",@"-",@"保存"];
        __block UIButton *preBtn;
        [titleArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
            if(idx == 0 || idx == 6){
                [btn setEnabled:NO];
            }
            
            if((idx>0 && idx < 5) ||(idx>6 && idx < 10)){
                [btn setBackgroundImage:[UIImage imageNamed:@"btnbg.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"btnselectbg.png"] forState:UIControlStateSelected];
            }
            
            if(idx == 11 || idx == 12 || idx == 13){
                [btn setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:57.0/255.0 blue:60.0/255.0 alpha:1.0]];
            }
            
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = Y_StockChartSegmentStartTag + 100 + idx;
            [btn addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [_settingView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                float left = 50*(idx%6);
                make.height.mas_equalTo(@25);
                make.width.equalTo(_settingView).multipliedBy(1.0/6.0);
                if(idx<11){
                    make.left.mas_equalTo(left);
                }else{
                    make.left.equalTo(_settingView).offset((idx-11)*10+50);
                }
                
                
                if(preBtn)
                {
                    if(idx<6){
                        make.top.equalTo(_settingView).offset(12.5);
                    }else{
                        make.top.equalTo(preBtn.mas_bottom).offset(25);
                    }
                    
                } else {
                    make.top.equalTo(_settingView).offset(12.5);
                }
                
            }];
            
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithRed:52.f/255.f green:56.f/255.f blue:67/255.f alpha:1];
            [_settingView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(btn);
                make.top.equalTo(btn.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            if(idx == 5 || idx == 10){
                preBtn = btn;
            }
            
        }];
        [self addSubview:_settingView];
        [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self);
            make.right.equalTo(self.mas_left);
        }];
    }
    return _settingView;
}

-(void)timeButtonClicked:(id)sender{
    NSLog(@"按钮点击");
    [self setHidden:YES];
    
    UIButton* btn = sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentTimeView:)])
    {
        [self.delegate y_StockChartSegmentTimeView:btn.tag-Y_StockChartSegmentStartTag];
    }
}

-(void)maButtonClicked:(id)sender{
    NSLog(@"按钮点击");
    [self setHidden:YES];
    
    UIButton* btn = sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentTimeView:)])
    {
        [self.delegate y_StockChartSegmentTimeView:btn.tag-Y_StockChartSegmentStartTag];
    }
}

-(void)macdButtonClicked:(id)sender{
    NSLog(@"按钮点击");
    [self setHidden:YES];
    
    UIButton* btn = sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentTimeView:)])
    {
        [self.delegate y_StockChartSegmentTimeView:btn.tag-Y_StockChartSegmentStartTag];
    }
}

-(void)settingButtonClicked:(id)sender{
    NSLog(@"按钮点击");
    [self setHidden:YES];
    
    UIButton* btn = sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentTimeView:)])
    {
        [self.delegate y_StockChartSegmentTimeView:btn.tag-Y_StockChartSegmentStartTag];
    }
}

@end
