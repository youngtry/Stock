//
//  ExchangeTableViewCell.h
//  StockAnalysis
//
//  Created by try on 2018/8/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *frizeeMoney;

@end
