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

@property (nonatomic,assign) int selectIndex;
@end
@implementation SADropMenu

-(instancetype)initWithFrame:(CGRect)frame target:(id)target titles:(NSMutableArray*)titles rowHeight:(CGFloat)rowHeight index:(int)index{
    self = [super initWithFrame:frame];
    if(self){
        self.titles = titles;
        self.rowHeight = rowHeight;
        self.selectIndex = index;
        self.images = [NSMutableArray new];
        [target addSubview:self.cover];//蒙版添加到主窗口
        [target addSubview:self];
        [self addSubview:self.tableView];
    }
    return self;
}
#pragma mrak - 蒙版
-(UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:kWindow.bounds];
        _cover.backgroundColor = [UIColor clearColor];
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
        CGFloat h = 0;
//        if (_directionType == PST_MenuViewDirectionUp) {
//            h = 0;
//        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, h, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.layer.cornerRadius = 6;
//        _tableView.layer.masksToBounds = YES;//设置圆角
        _tableView.tableFooterView = [UIView new];//不显示多余分割线
        _tableView.separatorStyle = UITableViewCellSelectionStyleGray;//显示分割线
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = _rowHeight;
        _tableView.layer.borderWidth = 0.5;
        _tableView.layer.borderColor = kColor(221, 221, 221).CGColor;
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
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(self.width*0.45, 0, self.width*0.45, self.rowHeight)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lab];
        lab.tag = 100;
        
        
        
    }
    UILabel *lab = [cell.contentView viewWithTag:100];
    
    if(self.titles.count>indexPath.row){
         lab.text = self.titles[indexPath.row];
    }
    
   

    if(indexPath.row == self.selectIndex){
        lab.textColor = kColor(243, 186, 46);
        [lab setAlpha:1.0];
    }else{
        lab.textColor = kColor(0, 0, 0);
        [lab setAlpha:0.64];
    }
    
    if(self.images.count == self.titles.count){
        NSString* imagename = self.images[indexPath.row];
        if(indexPath.row == self.selectIndex){
            imagename = [NSString stringWithFormat:@"%@.png",imagename];
        }else{
            imagename = [NSString stringWithFormat:@"%@_d.png",imagename];
        }
        UIImage* image = [UIImage imageNamed:imagename];
        
        UIImageView* imageview = [[UIImageView alloc] initWithImage:image] ;
        [imageview setFrame:CGRectMake(self.width*0.45-26, self.rowHeight/2-8, 16, 16)];
        [cell.contentView addSubview:imageview];
        
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PST_MenuViewModel *model = self.titleImgArr[indexPath.row];
//    if ([_delegate respondsToSelector:@selector(didSelectRowAtIndex:title:img:)]) {
//        [_delegate didSelectRowAtIndex:indexPath.row title:model.title img:model.img];
//    }
    
    if(self.block){
        self.block((int)indexPath.row);
    }
    
    [self removeMenuList];
}
@end
