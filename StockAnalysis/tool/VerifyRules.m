//
//  VerifyRules.m
//  StockAnalysis
//
//  Created by try on 2018/9/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "VerifyRules.h"

@implementation VerifyRules


+(BOOL)phoneNumberIsTure:(NSString *)text{
    NSString *phoneNumeberIsTureStr = @"^1[0-9]+\\d{9}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumeberIsTureStr];
    
    BOOL isTure = [pred evaluateWithObject:text];
    
    return isTure;
}

+(BOOL)passWordIsTure:(NSString *)text{
    
    NSString *passWordGex = @"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,20}$";
    
    NSPredicate *passWordPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordGex];
    
    BOOL isPassWord = [passWordPred evaluateWithObject:text];
    
    return isPassWord;
}

@end
