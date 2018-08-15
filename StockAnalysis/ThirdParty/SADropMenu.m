//
//  SADropMenu.m
//  StockAnalysis
//
//  Created by ymx on 2018/8/15.
//  Copyright © 2018年 try. All rights reserved.
//
#define kWindow [UIApplication sharedApplication].keyWindow
#import "SADropMenu.h"
@interface SADropMenu()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** rowHeight */
@property (nonatomic, assign) CGFloat rowHeight;
/** 蒙版 */
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) NSMutableArray* titles;
@end
@implementation SADropMenu

-(instancetype)initWithFrame:(CGRect)frame titles:(NSMutableArray*)titles rowHeight:(CGFloat)rowHeight{
    self = [super initWithFrame:frame];
    if(self){
        self.titles = titles;
        self.rowHeight = rowHeight;
        [kWindow addSubview:self.cover];//蒙版添加到主窗口
        [kWindow addSubview:self];
        [self addSubview:self.tableView];
    }
    return self;
}
#pragma mrak - 蒙版
-(UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:kWindow.bounds];
        _cover.backgroundColor = [UIColor blackColor];
        _cover.alpha = 0.2;
        
        //蒙版添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMenuList)];
        [_cover addGestureRecognizer:tap];
    }
    return _cover;
}
-(void)removeMenuList{
    [self.tableView removeFromSuperview];
    [self removeFromSuperview];
    [self.cover removeFromSuperview];
}

#pragma mark - tableView
-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat h = 8;
//        if (_directionType == PST_MenuViewDirectionUp) {
//            h = 0;
//        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, h, self.frame.size.width, self.frame.size.height - 8) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 6;
        _tableView.layer.masksToBounds = YES;//设置圆角
        _tableView.tableFooterView = [UIView new];//不显示多余分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = _rowHeight;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(nil==cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.rowHeight)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lab];
        lab.tag = 100;
    }
    UILabel *lab = [cell.contentView viewWithTag:100];
    lab.text = self.titles[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PST_MenuViewModel *model = self.titleImgArr[indexPath.row];
//    if ([_delegate respondsToSelector:@selector(didSelectRowAtIndex:title:img:)]) {
//        [_delegate didSelectRowAtIndex:indexPath.row title:model.title img:model.img];
//    }
    [self removeMenuList];
}
@end
