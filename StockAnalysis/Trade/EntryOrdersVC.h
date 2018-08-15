//
//  EntryOrdersVC.h
//  StockAnalysis
//
//  Created by ymx on 2018/8/15.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    Trade_All,
    Trade_BuyIn,
    Trade_SoldOut,
}TradeState;
@interface EntryOrdersVC : UIViewController
@property(nonatomic,assign)TradeState state;
@end
