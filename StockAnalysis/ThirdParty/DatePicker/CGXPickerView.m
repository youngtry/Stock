//
//  CGXPickerView.m
//  CGXPickerView
//
//  Created by 曹贵鑫 on 2017/8/23.
//  Copyright © 2017年 曹贵鑫. All rights reserved.
//

#import "CGXPickerView.h"

#import "CGXDatePickerView.h"

@implementation CGXPickerView

+ (void)showDatePickerWithTitle:(NSString *)title
                       DateType:(UIDatePickerMode)type
                DefaultSelValue:(NSString *)defaultSelValue
                     MinDateStr:(NSString *)minDateStr
                     MaxDateStr:(NSString *)maxDateStr
                   IsAutoSelect:(BOOL)isAutoSelect
                        Manager:(CGXPickerViewManager *)manager
                    ResultBlock:(CGXDateResultBlock)resultBlock
{
    if (manager) {
        [CGXDatePickerView showDatePickerWithTitle:title
                                          DateType:type
                                   DefaultSelValue:defaultSelValue
                                        MinDateStr:minDateStr
                                        MaxDateStr:maxDateStr
                                      IsAutoSelect:isAutoSelect
                                       ResultBlock:^(NSString *selectValue) {
            if (resultBlock) {
                resultBlock(selectValue);
            }
        } Manager:manager];
    } else{
        [CGXDatePickerView showDatePickerWithTitle:title
                                          DateType:type
                                   DefaultSelValue:defaultSelValue
                                        MinDateStr:minDateStr
                                        MaxDateStr:maxDateStr
                                      IsAutoSelect:isAutoSelect
                                       ResultBlock:^(NSString *selectValue) {
            if (resultBlock) {
                resultBlock(selectValue);
            }
        }];
    }

}


@end
