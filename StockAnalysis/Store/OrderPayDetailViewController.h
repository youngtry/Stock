//
//  OrderPayDetailViewController.h
//  StockAnalysis
//
//  Created by try on 2018/8/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPayDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *authView;
@property (weak, nonatomic) IBOutlet UIView *depositView;
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIView *cardInfoView;

@property (nonatomic,assign)int selectIndex;

@end
