//
//  BankCodeViewController.h
//  StockAnalysis
//
//  Created by try on 2018/8/14.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BankCodeViewControllerDelegate <NSObject>

@optional
-(void)returnBankCode:(NSString *)bankCode;

@end

//2.block传值  typedef void(^returnBlock)(NSString *showText);
typedef void(^returnBankCodeBlock) (NSString *bankCodeStr);

@interface BankCodeViewController : UIViewController

@property (nonatomic, assign) id<BankCodeViewControllerDelegate> deleagete;

@property (nonatomic, copy) returnBankCodeBlock returnbankCodeBlock;

-(void)toReturnCountryCode:(returnBankCodeBlock)block;


@end
