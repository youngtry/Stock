//
//  PendingOrderTableViewCell.h
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property(nonatomic,assign)BOOL isBuyIn;//买入/卖出
@end
