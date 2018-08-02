//
//  UpdateDataTableViewCell.h
//  StockAnalysis
//
//  Created by try on 2018/8/2.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateDataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyprice;
@property (weak, nonatomic) IBOutlet UILabel *buyamount;
@property (weak, nonatomic) IBOutlet UILabel *sellprice;
@property (weak, nonatomic) IBOutlet UILabel *sellamount;
@property(nonatomic)BOOL bothBuyAndSell;

@end
