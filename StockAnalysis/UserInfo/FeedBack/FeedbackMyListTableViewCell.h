//
//  FeedbackMyListTableViewCell.h
//  StockAnalysis
//
//  Created by try on 2018/10/18.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackMyListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

NS_ASSUME_NONNULL_END
