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

@interface PayStyleView()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>


@property(strong,nonatomic)UIView* contentView;
@property(strong,nonatomic)UITableView* detailTableView;

@property(strong,nonatomic)UIView* parentView;
@end


@implementation PayStyleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame withView:(UIView *)view{
    self = [super initWithFrame:frame];
    if(self){
        [self showInView:view];
    }
    return self;
}


- (void)setupContent {
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate  = self;
    [self addGestureRecognizer:tap];
    
    if (_contentView == nil) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - ZLBounceViewHight, kScreenWidth, ZLBounceViewHight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        // 右上角关闭按钮
//        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        closeBtn.frame = CGRectMake(_contentView.width - 20 - 15, 15, 20, 20);
//        [closeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
//        [_contentView addSubview:closeBtn];
    }
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    _parentView = view;
    [view addSubview:self];
    [self setupContent];
//    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, ZLBounceViewHight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, view.height - ZLBounceViewHight, kScreenWidth, ZLBounceViewHight)];
        
    } completion:nil];
    
    self.detailTableView = [[UITableView alloc] init];
    self.detailTableView.backgroundColor = [UIColor clearColor];
    self.detailTableView.frame = CGRectMake(0, 0, kScreenWidth, ZLBounceViewHight);
    [_contentView addSubview:self.detailTableView];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
//    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.detailTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.detailTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.detailTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.detailTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
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
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    }
    if(indexPath.row == 0){
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        [title setTextAlignment:NSTextAlignmentCenter];
        title.text = @"选择付款方式";
        [title setFont:[UIFont systemFontOfSize:14]];
        [cell.contentView addSubview:title];
        UIImage* icon = [UIImage imageNamed:@"closeChose.png"];
        cell.imageView.image = icon;
    }else{
        NSArray* titles = @[@"银行卡支付",@"微信支付",@"支付宝支付"];
        NSArray* pics = @[@"card.png",@"weixin.png",@"zhifubao.png"];
        cell.textLabel.text = titles[indexPath.row-1];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        UIImage* icon = [UIImage imageNamed:pics[indexPath.row-1]];
        cell.imageView.image = icon;
    }
    
    
    CGSize itemSize = CGSizeMake(16, 16);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row>0){
        if(self.block){
            self.block((int)indexPath.row);
        }
    }
    
    [self disMissView];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

@end
