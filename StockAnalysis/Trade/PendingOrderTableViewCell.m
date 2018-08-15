//
//  PendingOrderTableViewCell.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PendingOrderTableViewCell.h"
@interface PendingOrderTableViewCell()

@end
@implementation PendingOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isBuyIn = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsBuyIn:(BOOL)isBuyIn{
    _isBuyIn = isBuyIn;
    if(_isBuyIn){
        self.typeLabel.text = @"买入";
        self.typeLabel.textColor = kBuyInGreen;
    }else{
        self.typeLabel.text = @"卖出";
        self.typeLabel.textColor = kSoldOutRed;
    }
}
@end
