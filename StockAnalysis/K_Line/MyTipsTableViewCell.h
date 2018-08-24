//
//  MyTipsTableViewCell.h
//  StockAnalysis
//
//  Created by try on 2018/8/24.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTipsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *topLimit;
@property (weak, nonatomic) IBOutlet UILabel *lowLimit;

@end
