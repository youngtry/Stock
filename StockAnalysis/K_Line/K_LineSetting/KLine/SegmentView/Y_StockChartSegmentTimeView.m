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

@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation Y_StockChartSegmentTimeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        self.items = items;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor assistBackgroundColor];
        
        [self.timeView setHidden:YES];
        [self.MAView setHidden:YES];
        [self.MACDView setHidden:YES];
        [self.settingView setHidden:YES];
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            for (UIView *btnView in subView.subviews) {
                CGPoint btnPoint = [btnView convertPoint:point fromView:self];
                if (CGRectContainsPoint(btnView.bounds, btnPoint) && ![subView isHidden]){
                    return btnView;
                }
                
            }
        }
    }
    return view;
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
            [btn setTitleColor:kThemeYellow forState:UIControlStateSelected];
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
//                    NSLog(@"上边为:%f,height = %f",top,preBtn.frame.size.height);
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
            [btn setTitleColor:kThemeYellow forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = Y_StockChartSegmentStartTag + 200 + idx;
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
            [btn setTitleColor:kThemeYellow forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.tag = Y_StockChartSegmentStartTag + 300 + idx;
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
//                    NSLog(@"上边为:%f,height = %f",top,preBtn.frame.size.height);
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
            
            if((idx>0 && idx < 5) || (idx>6 && idx < 10)){
                [btn setBackgroundImage:[UIImage imageNamed:@"btnbg.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"btnselectbg.png"] forState:UIControlStateSelected];
            }
            
            if(idx == 11 || idx == 12 || idx == 13){
                [btn setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:57.0/255.0 blue:60.0/255.0 alpha:1.0]];
            }
            float widthrate = kScreenWidth/667.0;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = Y_StockChartSegmentStartTag + 400 + idx;
            [btn addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [_settingView addSubview:btn];
//            NSLog(@"idx = %lu ,title = %@",idx,title);
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
//                NSLog(@"屏幕宽度：%f",kScreenWidth/667.0);
                float left = (idx%6)+1;
//                NSLog(@"left = %f",left);
                make.height.mas_equalTo(@(25*widthrate));
                make.width.mas_equalTo(@(50));
                if(idx<11){
                    make.left.mas_equalTo(@(60*(left-1)));
                }else{
                    float left1 = ((idx-10)*20+50*(idx-11));
                    if(idx == 11){
                        make.left.equalTo(_settingView).offset(left1);
                    }else{
                        make.left.equalTo(_settingView).offset(left1);
                    }
                    
                }
                
                
                if(preBtn)
                {
                    if(idx<6){
                        make.top.equalTo(_settingView).offset(12.5*widthrate);
                    }else{
                        make.top.equalTo(preBtn.mas_bottom).offset(25*widthrate);
                    }
                    
                } else {
                    make.top.equalTo(_settingView).offset(12.5*widthrate);
                }
                
            }];
            if(idx>5){
                UIView *view = [UIView new];
                view.backgroundColor = [UIColor colorWithRed:52.f/255.f green:56.f/255.f blue:67/255.f alpha:1];
                [_settingView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(btn);
                    make.top.equalTo(btn.mas_bottom).offset(12.5*widthrate);
                    make.height.equalTo(@0.5);
                }];
            }
            
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

-(void)setAllbtnUnSelect:(UIView*) view{
    for (UIView* subview in view.subviews) {
        if([subview isKindOfClass:[UIButton class]]){
            UIButton* btn = (UIButton*)subview;
            [btn setSelected:NO];
        }
    }
}


-(void)timeButtonClicked:(id)sender{
    NSLog(@"按钮点击");

    [self setAllbtnUnSelect:_timeView];
    [self.timeView setHidden:YES];
    UIButton* btn = sender;
    [btn setSelected:YES];
    
    [self setTimeSelectedIndex:btn.tag-Y_StockChartSegmentStartTag-100];
    
    
    UIButton* upbtn = (UIButton*)[self viewWithTag:Y_StockChartSegmentStartTag+0];
    [upbtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentTimeView:)])
    {
        [self.delegate y_StockChartSegmentTimeView:btn.tag-Y_StockChartSegmentStartTag];
    }
}

-(void)maButtonClicked:(id)sender{
    NSLog(@"按钮点击");

    [self setAllbtnUnSelect:_MAView];
    [self.MAView setHidden:YES];
    UIButton* btn = sender;
    [btn setSelected:YES];
    
    UIButton* upbtn = (UIButton*)[self viewWithTag:Y_StockChartSegmentStartTag+1];
    [upbtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    
//    UIButton* btn = sender;
//    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentTimeView:)])
//    {
//        [self.delegate y_StockChartSegmentTimeView:btn.tag-Y_StockChartSegmentStartTag];
//    }
}

-(void)macdButtonClicked:(id)sender{
    NSLog(@"按钮点击");

    [self setAllbtnUnSelect:_MACDView];
    [self.MACDView setHidden:YES];
    UIButton* btn = sender;
    [btn setSelected:YES];
    
    UIButton* upbtn = (UIButton*)[self viewWithTag:Y_StockChartSegmentStartTag+2];
    [upbtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
//    UIButton* btn = sender;
//    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentTimeView:)])
//    {
//        [self.delegate y_StockChartSegmentTimeView:btn.tag-Y_StockChartSegmentStartTag];
//    }
}

-(void)settingButtonClicked:(id)sender{
    NSLog(@"按钮点击");

    [self setAllbtnUnSelect:_settingView];
    [self.settingView setHidden:YES];
    UIButton* btn = sender;
    [btn setSelected:YES];
    
//    UIButton* upbtn = (UIButton*)[self viewWithTag:Y_StockChartSegmentStartTag+3];
//    [upbtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    //    UIButton* btn = sender;
    //    btn.selected = YES;
    //    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentTimeView:)])
    //    {
    //        [self.delegate y_StockChartSegmentTimeView:btn.tag-Y_StockChartSegmentStartTag];
    //    }
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    if(items.count == 0 || !items)
    {
        return;
    }
    NSInteger index = 0;
    NSInteger count = items.count;
    UIButton *preBtn = nil;
    
    for (NSString *title in items)
    {
        UIButton *btn = [self private_createButtonWithTitle:title tag:Y_StockChartSegmentStartTag+index];
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0/255.f alpha:1];
        [self addSubview:btn];
        [self addSubview:view];
        if([title isEqualToString:@""]){
            [view setHidden:YES];
        }
        NSLog(@"title = %@,index = %ld",title,index);
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.height.equalTo(self).multipliedBy(1.0f/count);
            make.width.equalTo(self);
            if(preBtn)
            {
                make.top.equalTo(preBtn.mas_bottom).offset(0.5);
            } else {
                make.top.equalTo(self);
            }
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(btn);
            make.top.equalTo(btn.mas_bottom);
            make.height.equalTo(@0.5);
        }];
        preBtn = btn;
        index++;
    }
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)[self viewWithTag:Y_StockChartSegmentStartTag + selectedIndex];
    [btn setSelected:YES];
//    NSAssert(btn, @"按钮初始化出错");
//    [self event_segmentButtonClicked:btn];
}

-(void)setTimeSelectedIndex:(NSUInteger)timeSelectedIndex{
    _timeSelectedIndex = timeSelectedIndex;
    UIButton *btn = (UIButton *)[self.timeView viewWithTag:Y_StockChartSegmentStartTag + 100 + timeSelectedIndex];
    NSAssert(btn, @"按钮初始化出错");
    [self event_segmentSpecicalButtonClicked:btn];
}

- (void)setSelectedBtn:(UIButton *)selectedBtn
{
    NSLog(@"btn.tag = %ld",selectedBtn.tag);
    _selectedIndex = selectedBtn.tag - Y_StockChartSegmentStartTag;
    if(_selectedIndex < 4){
        [_delegate clickMenu:_selectedIndex];
    }
    
    [UIView animateWithDuration:0.02f animations:^{
        [self layoutIfNeeded];
    }];
    
    [self layoutIfNeeded];
}
- (void)event_segmentSpecicalButtonClicked:(UIButton *)btn
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentTimeView:)])
    {
        [self.delegate y_StockChartSegmentTimeView:btn.tag - Y_StockChartSegmentStartTag];
    }
}
- (void)event_segmentButtonClicked:(UIButton *)btn
{
    [self setAllbtnUnSelect:self];
    self.selectedBtn = btn;
    [btn setSelected:YES];
}

- (UIButton *)private_createButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:kThemeYellow forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.tag = tag;
    [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}
@end
