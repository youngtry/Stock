//
//  UnpayTableViewCell.m
//  StockAnalysis
//
//  Created by try on 2018/8/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "UnpayTableViewCell.h"

@implementation UnpayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goPayBtn.layer.borderWidth = 0.5;
    self.goPayBtn.layer.borderColor = kColor(240, 186, 81).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
