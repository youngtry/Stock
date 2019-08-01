//
//  PendingOrderTableViewCell.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PendingOrderTableViewCell.h"
@interface PendingOrderTableViewCell()

@end
@implementation PendingOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isBuyIn = YES;
    self.tradeID = @"0";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsBuyIn:(BOOL)isBuyIn{
    _isBuyIn = isBuyIn;
    if(_isBuyIn){
        self.typeLabel.text = Localize(@"Buy");
        self.typeLabel.textColor = kBuyInGreen;
    }else{
        self.typeLabel.text = Localize(@"Sell");
        self.typeLabel.textColor = kSoldOutRed;
    }
}
- (IBAction)clickCancel:(id)sender {
    WeakSelf(weakSelf);
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController* vc = (UIViewController*)nextResponder;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localize(@"Menu_Title") message:Localize(@"Cancel_Pending_Tip") preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:Localize(@"Menu_Sure") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                NSString* url = @"exchange/trade/cancel";
                NSDictionary* params = @{@"trade_id":self.tradeID};
                [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
                    if(success){
                        if([[data objectForKey:@"ret"] intValue] == 1){
                            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendCancelNotice:withReason:)]){
                                [weakSelf.delegate sendCancelNotice:YES withReason:@""];
                            }
                        }else{
                            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendCancelNotice:withReason:)]){
                                [weakSelf.delegate sendCancelNotice:NO withReason:[data objectForKey:@"msg"]];
                            }
                        }
                    }
                }];
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:Localize(@"Menu_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            //弹出提示框；
            [vc.navigationController presentViewController:alert animated:true completion:nil];
            NSLog(@"找到了");
        }
   }
    
    
    
    
}
@end
