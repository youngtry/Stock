//
//  TradeViewController.h
//  StockAnalysis
//
//  Created by Macbook on 2018/6/24.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeViewController : BaseViewController
@property(nonatomic,assign)int pageIndex;
-(void)changeToPage:(NSInteger)index withName:(NSString*)tradename;
@end
