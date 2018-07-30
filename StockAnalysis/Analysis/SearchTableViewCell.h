//
//  SearchTableViewCell.h
//  StockAnalysis
//
//  Created by try on 2018/7/16.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

-(void)setName:(NSString*)name;
-(void)setIfLike:(BOOL)like;
-(void)setIfShop:(BOOL)shop;
@end
