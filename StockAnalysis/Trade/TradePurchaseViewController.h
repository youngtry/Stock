//
//  TradePurchaseViewController.h
//  StockAnalysis
//
//  Created by Macbook on 2018/6/24.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loadFinish)(void);

@interface TradePurchaseViewController : BaseViewController

@property(nonatomic,strong)NSString* tradeName;

@property (nonatomic,strong)loadFinish block;

@end
