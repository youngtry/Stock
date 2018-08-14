//
//  UserManagerTableViewCell.h
//  StockAnalysis
//
//  Created by Macbook on 2018/8/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UIImageView *currentIcon;

@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@end
