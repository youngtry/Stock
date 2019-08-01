//
//  Util.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "Util.h"

@implementation Util
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIViewController *)getParentVC:(UIView*)v { 
    UIResponder *nextResponder = [v nextResponder];
    do {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)nextResponder;
            
        }
        nextResponder = [nextResponder nextResponder];
        
    } while (nextResponder != nil);
    return nil;
    
}

+(UIViewController *)getParentVC:(Class)c fromView:(UIView*)v{
    UIResponder *nextResponder = [v nextResponder];
    do {
        if ([nextResponder isKindOfClass:c]) {
            
            return (UIViewController *)nextResponder;
            
        }
        nextResponder = [nextResponder nextResponder];
        
    } while (nextResponder != nil);
    return nil;
}

+(NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
    
}

+(NSString*)getLocalString:(NSString*) key{
    return NSLocalizedStringFromTable(key, @"InfoPlist", nil);
}
@end
