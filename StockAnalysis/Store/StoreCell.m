//
//  StoreCell.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "StoreCell.h"

@implementation StoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.purchaseBtn.layer.cornerRadius = 12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
