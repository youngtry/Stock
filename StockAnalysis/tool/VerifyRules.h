//
//  VerifyRules.h
//  StockAnalysis
//
//  Created by try on 2018/9/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerifyRules : NSObject


+ (BOOL)phoneNumberIsTure:(NSString* )text;
+ (BOOL)passWordIsTure:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
