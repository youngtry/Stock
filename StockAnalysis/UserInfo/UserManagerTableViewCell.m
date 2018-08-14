//
//  UserManagerTableViewCell.m
//  StockAnalysis
//
//  Created by Macbook on 2018/8/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import "UserManagerTableViewCell.h"
#import "AddAccountViewController.h"

@implementation UserManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if(selected && ![self.switchBtn isHidden]){
        AddAccountViewController* vc = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil];
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                UIViewController* supervc = (UIViewController*)nextResponder;
                [supervc.navigationController pushViewController:vc animated:YES];
                break;
            }
        }
    }

    // Configure the view for the selected state
}
- (IBAction)clickSwitchButton:(id)sender {
    AddAccountViewController* vc = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil];
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController* supervc = (UIViewController*)nextResponder;
            [supervc.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

@end
