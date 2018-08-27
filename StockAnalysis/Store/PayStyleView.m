//
//  PayStyleView.m
//  StockAnalysis
//
//  Created by try on 2018/8/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PayStyleView.h"

#define ZLBounceViewHight 180
#define ZLTuanNumViewHight 135

@interface PayStyleView()<UITableViewDelegate, UITableViewDataSource>


@property(strong,nonatomic)UIView* contentView;
@property(strong,nonatomic)UITableView* detailTableView;
@end


@implementation PayStyleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if(self){
        
    }
    return self;
}


- (void)setupContent {
    
    self.frame = CGRectMake(0, 0, kScreenWidth, ZLBounceViewHight);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (_contentView == nil) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - ZLTuanNumViewHight, kScreenWidth, ZLBounceViewHight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(_contentView.width - 20 - 15, 15, 20, 20);
        [closeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeBtn];
    }
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, ZLBounceViewHight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, kScreenHeight - ZLBounceViewHight, kScreenWidth, ZLBounceViewHight)];
        
    } completion:nil];
    
    UITableView *detailTableView = [[UITableView alloc] init];
    detailTableView.backgroundColor = [UIColor clearColor];
    detailTableView.frame = CGRectMake(0, 0, kScreenWidth, ZLBounceViewHight - 20 - 20 - 50 - 20);
    [_contentView addSubview:detailTableView];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    self.detailTableView = detailTableView;
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)disMissView {
    
    [_contentView setFrame:CGRectMake(0, kScreenHeight - ZLBounceViewHight, kScreenWidth, ZLBounceViewHight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, ZLBounceViewHight)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}




@end
