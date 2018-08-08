//
//  TradeStockInfoTableViewCell.h
//  StockAnalysis
//
//  Created by try on 2018/8/8.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeStockInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *upRate;
@property (weak, nonatomic) IBOutlet UILabel *volume;

@end
