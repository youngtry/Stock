//
//  AdContentViewController.h
//  StockAnalysis
//
//  Created by try on 2018/10/23.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^loadFinish)(void);

@interface AdContentViewController : BaseViewController

@property(nonatomic,strong)loadFinish block;

-(void)starRequest:(NSString*)url;

@end

NS_ASSUME_NONNULL_END
