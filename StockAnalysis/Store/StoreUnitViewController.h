//
//  StoreUnitViewController.h
//  StockAnalysis
//
//  Created by try on 2018/8/24.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^returnUnit) (NSString *unit);

@interface StoreUnitViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *cnyName;
@property (weak, nonatomic) IBOutlet UILabel *usdName;
@property (weak, nonatomic) IBOutlet UIImageView *cnyIcon;
@property (weak, nonatomic) IBOutlet UIImageView *usdIcon;
//block声明属性
@property (nonatomic, copy) returnUnit returnUnit;
//block声明方法
-(void)toReturnUnit:(returnUnit)block;

@end
