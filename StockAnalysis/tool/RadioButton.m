//
//  RadioButton.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "RadioButton.h"
#import "Util.h"
@interface RadioButton()
@property(nonatomic,strong)NSMutableArray* btns;
@property(nonatomic,assign)CGFloat width;

@property(nonatomic,assign)NSInteger selectIndex;
@end
@implementation RadioButton

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles selectIndex:(NSInteger)index{
    self = [super initWithFrame:frame];
    if(self){
        _btns = [NSMutableArray new];
        _width = (frame.size.width-0.0f)/ (CGFloat)titles.count;
        _selectIndex = index;
        [self createTitleButtons:titles];
        [self selectButton:index];
        
        self.backgroundColor = kColor(200,200,200);
        self.layer.cornerRadius = self.height/2.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}



-(void)createTitleButtons:(NSArray*)titles{
    CGFloat x = 0;
    int i=0;
    for (NSString *title in titles) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setBackgroundImage:[Util imageWithColor:kColor(200,200,200)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[Util imageWithColor:kThemeYellow] forState:UIControlStateSelected];
        btn.frame = CGRectMake(x, 0, _width, self.height);
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        btn.centerY = self.centerY;
        btn.tag = i;
        [self addSubview:btn];
        [_btns addObject:btn];
        
        [btn addTarget:self action:@selector(clickOne:) forControlEvents:UIControlEventTouchUpInside];
        
        x += _width;
        i++;
    }
}

-(void)reloadFrame:(CGRect)frame{
    self.frame = frame;
    _width = (self.frame.size.width-0.0f)/ (CGFloat)_btns.count;
    
    CGFloat x = 0;
    for (UIButton *btn in _btns) {
        btn.frame = CGRectMake(x, 0, _width, self.height);
        btn.centerY = self.centerY;
        x+=_width;
    }
}

-(void)clickOne:(UIButton*)sender{
    NSInteger index = sender.tag;
    
    if(_selectIndex!=index){
        _selectIndex = index;
        
        [self selectButton:index];
        [self onSelectChanged];
    }
}

-(void)setSelectIndex:(NSInteger)select{
    _selectIndex = select;
    
    [self selectButton:select];
    [self onSelectChanged];
}

-(NSInteger)getSelectIndex{
    return _selectIndex;
}

-(void)selectButton:(NSInteger)index{
    for (UIButton *btn in _btns) {
        btn.selected = NO;
    }
    
    if(index<0||index>=_btns.count){

    }else{
        UIButton *btn = _btns[index];
        btn.selected = YES;
    }
}

-(void)onSelectChanged{
    if(self.indexChangeBlock){
        self.indexChangeBlock(_selectIndex);
    }
}
@end
