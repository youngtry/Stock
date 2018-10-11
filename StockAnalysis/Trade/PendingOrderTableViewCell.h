//
//  PendingOrderTableViewCell.h
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CancelDelegate <NSObject>
- (void)sendCancelNotice:(BOOL)success withReason:(NSString*)msg; //声明协议方法
@end

@interface PendingOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *realLabel;
@property (nonatomic,strong) NSString* tradeID;
@property(nonatomic,assign)BOOL isBuyIn;//买入/卖出
@property (weak, nonatomic) id<CancelDelegate> delegate;
@end
