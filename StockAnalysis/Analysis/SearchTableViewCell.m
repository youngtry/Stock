//
//  SearchTableViewCell.m
//  StockAnalysis
//
//  Created by try on 2018/7/16.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "HttpRequest.h"
#import "SearchData.h"

@interface SearchTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic)BOOL isLike;

@end

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isLike = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    [[SearchData getInstance] addhistory:]
    // Configure the view for the selected state
}
- (IBAction)clickLike:(id)sender {
    NSLog(@"我要关注或取消这个交易");
    if(_isLike){
        NSDictionary* parameters = @{@"market":_nameLabel.text};
        NSString* url = @"/market/unfollow";
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [self setIfLike:NO];
                    for (NSDictionary* info in [SearchData getInstance].specialList) {
                        if([[info objectForKey:@"market"] isEqualToString:_nameLabel.text]){
                            [[SearchData getInstance].specialList removeObject:info];
                            break;
                        }
                    }
                }
            }
        }];
    }else{
        NSDictionary* parameters = @{@"market":_nameLabel.text};
        NSString* url = @"/market/follow";
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            if(success){
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [self setIfLike:YES];
                    for (NSDictionary* info in [SearchData getInstance].searchList) {
                        if([[info objectForKey:@"market"] isEqualToString:_nameLabel.text]){
                            [[SearchData getInstance].specialList addObject:info];
                            break;
                        }
                    }
                    
                }
            }
        }];
    }
    
}

-(void)setName:(NSString*)name{
    _nameLabel.text = name;
}
-(NSString*)getName{
    return _nameLabel.text;
}

-(void)setIfLike:(BOOL)like{
    if(like){
        //如果是关注
        [_likeButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        _isLike = YES;
    }else{
       [_likeButton setImage:[UIImage imageNamed:@"addstar.png"] forState:UIControlStateNormal];
        _isLike = NO;
    }
}

-(void)setIfShop:(BOOL)shop{
    if(shop){
        [_likeButton setEnabled:NO];
        [_likeButton setHidden:YES];
    }else{
        [_likeButton setEnabled:YES];
        [_likeButton setHidden:NO];
    }
}

@end

