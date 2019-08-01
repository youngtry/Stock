//
//  Y-StockChartView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartView.h"
#import "Y_KLineView.h"
#import "Masonry.h"
#import "Y_StockChartSegmentView.h"
#import "Y_StockChartGlobalVariable.h"
#import "AppDelegate.h"
#import "Y_StockChartSegmentTimeView.h"
@interface Y_StockChartView() <Y_StockChartSegmentViewDelegate,Y_StockChartSegmentTimeViewDelegate>

/**
 *  K线图View
 */
@property (nonatomic, strong) Y_KLineView *kLineView;

/**
 *  底部选择View
 */
@property (nonatomic, strong) Y_StockChartSegmentView *segmentView;

/**
 *  底部选择详细View
 */
@property (nonatomic, strong) Y_StockChartSegmentTimeView *segmentTimeView;

/**
 *  图表类型
 */
@property(nonatomic,assign) Y_StockChartCenterViewType currentCenterViewType;

/**
 *  当前索引
 */
@property(nonatomic,assign,readwrite) NSInteger currentIndex;
@end


@implementation Y_StockChartView

- (Y_KLineView *)kLineView
{
    if(!_kLineView)
    {
        _kLineView = [Y_KLineView new];
        [self addSubview:_kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.top.equalTo(self);
            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
            if(appdelegate.isEable){
                //横屏
                make.left.equalTo(self.segmentTimeView.mas_right);
                
            }else{
                make.left.equalTo(self.segmentView.mas_right);
                
            }
//            make.left.equalTo(self.segmentView.mas_right);
        }];
    }
    return _kLineView;
}

- (Y_StockChartSegmentView *)segmentView
{
    if(!_segmentView)
    {
        _segmentView = [Y_StockChartSegmentView new];
        _segmentView.delegate = self;
        [self addSubview:_segmentView];
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.top.equalTo(self);
            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
            if(appdelegate.isEable){
                make.width.equalTo(@50);
            }else{
                make.width.equalTo(@5);
                
                
            }
//            make.width.equalTo(@5);
        }];
    }
    return _segmentView;
}

- (Y_StockChartSegmentTimeView *)segmentTimeView
{
    if(!_segmentTimeView)
    {
        _segmentTimeView = [Y_StockChartSegmentTimeView new];
        _segmentTimeView.delegate = self;
        [self addSubview:_segmentTimeView];
        [_segmentTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.top.equalTo(self);
            
            make.width.equalTo(@50);
        }];
    }
    return _segmentTimeView;
}

- (void)setItemModels:(NSArray *)itemModels
{
    _itemModels = itemModels;
    if(itemModels)
    {
        NSMutableArray *items = [NSMutableArray array];
        for(Y_StockChartViewItemModel *item in itemModels)
        {
            [items addObject:item.title];
        }
        AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
        if(appdelegate.isEable){
            //横屏
            self.segmentTimeView.items = items;
        }else{
            self.segmentView.items = items;
        }
        
        Y_StockChartViewItemModel *firstModel = itemModels.firstObject;
        self.currentCenterViewType = firstModel.centerViewType;
    }
    if(self.dataSource)
    {
        AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
        if(appdelegate.isEable){
            //横屏
            self.segmentTimeView.selectedIndex = 0;
            self.segmentTimeView.timeSelectedIndex = 4;
        }else{
            self.segmentView.selectedIndex = 2;
        }
        
        
        
    }
}

- (void)setDataSource:(id<Y_StockChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if(self.itemModels)
    {
        AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
        if(appdelegate.isEable){
            //横屏
            self.segmentTimeView.selectedIndex = 0;
            self.segmentTimeView.timeSelectedIndex = 4;
        }else{
            self.segmentView.selectedIndex = 4;
        }
//        self.segmentView.selectedIndex = 2;
    }
}
- (void)reloadData
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    if(appdelegate.isEable){
        //横屏
        self.segmentTimeView.timeSelectedIndex = self.segmentTimeView.timeSelectedIndex;
    }else{
        self.segmentView.selectedIndex = self.segmentView.selectedIndex;
    }
//    self.segmentView.selectedIndex = self.segmentView.selectedIndex;
}
-(void)showTimeline{
    [self y_StockChartSegmentView:_segmentView clickSegmentButtonIndex:1];
}

-(void)setSelect:(NSInteger)index{
    self.segmentView.selectedIndex = index;
}

-(void)setMACDViewHide:(BOOL)ishide{
    [_kLineView setMACDViewHide:ishide];
    
}
#pragma mark - 代理方法

- (void)y_StockChartSegmentView:(Y_StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index
{
    self.currentIndex = index;
    
    if (index == 105) {
        
        [Y_StockChartGlobalVariable setisBOLLLine:Y_StockChartTargetLineStatusBOLL];
        self.kLineView.targetLineStatus = index;
        [self.kLineView reDraw];
        [self bringSubviewToFront:self.segmentView];
        
    } else  if(index >= 100 && index != 105) {
        
        [Y_StockChartGlobalVariable setisEMALine:index];
//        if(index == Y_StockChartTargetLineStatusMA)
//        {
//            [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusMA];
//        } else {
//            [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusEMA];
//        }
        self.kLineView.targetLineStatus = index;
        [self.kLineView reDraw];
        [self bringSubviewToFront:self.segmentView];
    
    } else {
        if(self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)])
        {
            id stockData = [self.dataSource stockDatasWithIndex:index];
            
            if(!stockData)
            {
                return;
            }
            
//            NSLog(@"stockdata = %@",stockData);
            
            Y_StockChartViewItemModel *itemModel = self.itemModels[index];
 
            Y_StockChartCenterViewType type = itemModel.centerViewType;
            Y_StockChartCenterViewType type1 = type;

            if(type1 != self.currentCenterViewType)
            {
                //移除当前View，设置新的View
                self.currentCenterViewType = type1;
                switch (type1) {
                    case Y_StockChartcenterViewTypeKline:
                    {
                        self.kLineView.hidden = NO;
                        //                    [self bringSubviewToFront:self.kLineView];
                        [self bringSubviewToFront:self.segmentView];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            if(type1 == Y_StockChartcenterViewTypeOther)
            {
                
            } else {
                self.kLineView.kLineModels = (NSArray *)stockData;
                self.kLineView.MainViewType = type1;
                [self.kLineView reDraw];
            }
            [self bringSubviewToFront:self.segmentView];
            
        }
    }

}

-(void)clickMenu:(NSInteger)index{
    if(index == 0){
//        [self.segmentTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.left.mas_equalTo(@50);
//            make.height.equalTo(self).multipliedBy(2.0/5.0);
//            make.width.equalTo(@250);
//        }];
        [self.segmentTimeView.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.segmentTimeView).multipliedBy(2.0/5.0);
            make.left.equalTo(self.segmentTimeView.mas_right);
            make.top.equalTo(self.segmentTimeView);
            make.width.equalTo(@250);
        }];
        [self.segmentTimeView.timeView setHidden:NO];
        [self.segmentTimeView.MAView setHidden:YES];
        [self.segmentTimeView.MACDView setHidden:YES];
        [self.segmentTimeView.settingView setHidden:YES];
        [self.segmentTimeView setHidden:NO];
        [self bringSubviewToFront:self.segmentTimeView.timeView];
    }else if (index == 1){
//        [self.segmentTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(self.frame.size.height/8.0);
//            make.left.mas_equalTo(@50);
//            make.height.equalTo(self).multipliedBy(1.0/8.0);
//            make.width.equalTo(@250);
//        }];
        [self.segmentTimeView.MAView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.segmentTimeView).multipliedBy(1.0/8.0);
            make.left.equalTo(self.segmentTimeView.mas_right);
            make.top.equalTo(self.segmentTimeView).offset(self.frame.size.height/8.0);
            make.width.equalTo(@250);
        }];
        [self.segmentTimeView.timeView setHidden:YES];
        [self.segmentTimeView.MAView setHidden:NO];
        [self.segmentTimeView.MACDView setHidden:YES];
        [self.segmentTimeView.settingView setHidden:YES];
        [self.segmentTimeView setHidden:NO];
        [self bringSubviewToFront:self.segmentTimeView.MAView];
    }else if (index == 2){
//        [self.segmentTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(self.frame.size.height/4.0);
//            make.left.mas_equalTo(@50);
//            make.height.equalTo(self).multipliedBy(3.0/5.0);
//            make.width.equalTo(@250);
//        }];
        [self.segmentTimeView.MACDView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.segmentTimeView).multipliedBy(3.0/5.0);
            make.left.equalTo(self.segmentTimeView.mas_right);
            make.top.equalTo(self.segmentTimeView).offset(self.frame.size.height/4.0);
            make.width.equalTo(@250);
        }];
        [self.segmentTimeView.timeView setHidden:YES];
        [self.segmentTimeView.MAView setHidden:YES];
        [self.segmentTimeView.MACDView setHidden:NO];
        [self.segmentTimeView.settingView setHidden:YES];
        [self.segmentTimeView setHidden:NO];
        [self bringSubviewToFront:self.segmentTimeView.MACDView];
    }else if (index == 3){
//        [self.segmentTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(self.frame.size.height*3.0/8.0);
//            make.left.mas_equalTo(@50);
//            make.height.equalTo(self).multipliedBy(2.0/5.0);
//            make.width.equalTo(@360);
//        }];
        [self.segmentTimeView.settingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.segmentTimeView).multipliedBy(2.0/5.0);
            make.left.equalTo(self.segmentTimeView.mas_right);
            make.top.equalTo(self.segmentTimeView).offset(self.segmentTimeView.frame.size.height*3.0/8.0);
            make.width.equalTo(@360);
        }];
        [self.segmentTimeView.timeView setHidden:YES];
        [self.segmentTimeView.MAView setHidden:YES];
        [self.segmentTimeView.MACDView setHidden:YES];
        [self.segmentTimeView.settingView setHidden:NO];
        [self bringSubviewToFront:self.segmentTimeView.settingView];
        [self.segmentTimeView setHidden:NO];
    
    }
    [self bringSubviewToFront:self.segmentTimeView];
}

-(void)noticeSwitch{
    if(self.switchPhone){
        self.switchPhone();
    }
}

-(void)y_StockChartSegmentTimeView:(NSInteger)index{
    NSLog(@"**********index = %ld",index);
    self.currentIndex = index;
    
    if(index < 200){
        if(self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)])
        {
            id stockData = [self.dataSource stockDatasWithIndex:index-100];
            
            if(!stockData)
            {
                return;
            }
            
            //            NSLog(@"stockdata = %@",stockData);
            
//            Y_StockChartViewItemModel *itemModel = self.itemModels[index];
            
//            Y_StockChartCenterViewType type = itemModel.centerViewType;
            
            Y_StockChartCenterViewType type1 = Y_StockChartcenterViewTypeKline;
            
//            Y_StockChartViewItemModel* itemModel = [Y_StockChartViewItemModel itemModelWithTitle:[NSString stringWithFormat:@"5%@",Localize(@"Min")] type:Y_StockChartcenterViewTypeTimeLine];
            if(index == 100){
                type1 = Y_StockChartcenterViewTypeTimeLine;
            }
            
            if(type1 != self.currentCenterViewType)
            {
                //移除当前View，设置新的View
                self.currentCenterViewType = type1;
                switch (type1) {
                    case Y_StockChartcenterViewTypeKline:
                    {
                        self.kLineView.hidden = NO;
                        //                    [self bringSubviewToFront:self.kLineView];
                        [self bringSubviewToFront:self.segmentTimeView];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            if(type1 == Y_StockChartcenterViewTypeOther)
            {
                
            } else {
                self.kLineView.kLineModels = (NSArray *)stockData;
                self.kLineView.MainViewType = type1;
                [self.kLineView reDraw];
            }
            [self bringSubviewToFront:self.segmentTimeView];

    }
    
    if (index == 105) {
        
//        [Y_StockChartGlobalVariable setisBOLLLine:Y_StockChartTargetLineStatusBOLL];
//        self.kLineView.targetLineStatus = index;
//        [self.kLineView reDraw];
//        [self bringSubviewToFront:self.segmentTimeView];
        
    } else  if(index >= 100 && index != 105) {
        
//        [Y_StockChartGlobalVariable setisEMALine:index];
        //        if(index == Y_StockChartTargetLineStatusMA)
        //        {
        //            [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusMA];
        //        } else {
        //            [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusEMA];
        //        }
//        self.kLineView.targetLineStatus = index;
//        [self.kLineView reDraw];
//        [self bringSubviewToFront:self.segmentTimeView];
        
    } else {
//        if(self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)])
//        {
//            id stockData = [self.dataSource stockDatasWithIndex:index];
//
//            if(!stockData)
//            {
//                return;
//            }
//
//            //            NSLog(@"stockdata = %@",stockData);
//
//            Y_StockChartViewItemModel *itemModel = self.itemModels[index];
//
//            Y_StockChartCenterViewType type = itemModel.centerViewType;
//            Y_StockChartCenterViewType type1 = type;
//            if(type == Y_StockChartcenterViewTypeMenu){
//                //                self.currentIndex = 0;
//                type1 = Y_StockChartcenterViewTypeKline;
//                itemModel = [Y_StockChartViewItemModel itemModelWithTitle:Localize(@"Immediate") type:Y_StockChartcenterViewTypeTimeLine];
//            }
//
//            if(type1 != self.currentCenterViewType)
//            {
//                //移除当前View，设置新的View
//                self.currentCenterViewType = type1;
//                switch (type1) {
//                    case Y_StockChartcenterViewTypeKline:
//                    {
//                        self.kLineView.hidden = NO;
//                        //                    [self bringSubviewToFront:self.kLineView];
//                        [self bringSubviewToFront:self.segmentTimeView];
//
//                    }
//                        break;
//
//                    default:
//                        break;
//                }
//            }
//
//            if(type1 == Y_StockChartcenterViewTypeOther)
//            {
//
//            } else {
//                self.kLineView.kLineModels = (NSArray *)stockData;
//                self.kLineView.MainViewType = type1;
//                [self.kLineView reDraw];
//            }
//            [self bringSubviewToFront:self.segmentTimeView];
//
//            if(type == Y_StockChartcenterViewTypeMenu){
//                //进入菜单
//                //                [self clickMenu:_currentIndex];
//
//            }
        }
    }
}

@end


/************************ItemModel类************************/
@implementation Y_StockChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title type:(Y_StockChartCenterViewType)type
{
    Y_StockChartViewItemModel *itemModel = [Y_StockChartViewItemModel new];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}

@end
