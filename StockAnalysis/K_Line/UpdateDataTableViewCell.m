//
//  UpdateDataTableViewCell.m
//  StockAnalysis
//
//  Created by try on 2018/8/2.
//  Copyright © 2018年 try. All rights reserved.
//

#import "UpdateDataTableViewCell.h"

@implementation UpdateDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bothBuyAndSell = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
