//
//  TradeStockInfoTableViewCell.m
//  StockAnalysis
//
//  Created by try on 2018/8/8.
//  Copyright © 2018年 try. All rights reserved.
//

#import "TradeStockInfoTableViewCell.h"

@implementation TradeStockInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected){
        [_name setTextColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:10.]];
    }else{
        [_name setTextColor:[UIColor colorWithRed:48.0/255.0 green:48.8/255.0 blue:48.0/255.0 alpha:10.]];
    }
    // Configure the view for the selected state
}

@end
