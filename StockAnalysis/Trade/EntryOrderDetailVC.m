//
//  EntryOrderDetailVC.m
//  StockAnalysis
//
//  Created by ymx on 2018/8/15.
//  Copyright © 2018年 try. All rights reserved.
//

#import "EntryOrderDetailVC.h"

@interface EntryOrderDetailVC ()

@property(nonatomic,strong)NSString* stockId;
@property(nonatomic,strong)NSMutableDictionary* stockInfo;

@end

@implementation EntryOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.stockId = self.title;
    self.title = Localize(@"Deal_Detail");
    
    self.stockInfo = [NSMutableDictionary new];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.stockInfo removeAllObjects];
    [self getDetail];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)getDetail{
    NSString* url = @"exchange/trade/detail";
    NSDictionary* params = @{@"trade_id":self.stockId};
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"加载数据中"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] getWithURL:url parma:params block:^(BOOL success, id data) {
        
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSDictionary* info = [[data objectForKey:@"data"] objectForKey:@"trade"];
                [weakSelf.stockInfo setDictionary:info];
                [weakSelf setDetailInfo];
            }else{
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

-(void)setDetailInfo{
    if([[self.stockInfo objectForKey:@"mode"] isEqualToString:@"buy"]){
        self.typeLabel.text = Localize(@"Buy");
        [self.typeLabel setTextColor:kBuyInGreen];
    }else if ([[self.stockInfo objectForKey:@"mode"] isEqualToString:@"sell"]){
        self.typeLabel.text = Localize(@"Sell");
        [self.typeLabel setTextColor:kSoldOutRed];
    }
    double deal_money = [[self.stockInfo objectForKey:@"deal_money"] doubleValue];
    double deal_stock = [[self.stockInfo objectForKey:@"deal_stock"] doubleValue];
    double price = (double)deal_money/(double)deal_stock;
    if(deal_stock == 0){
        price = 0;
    }
    double fee = [[self.stockInfo objectForKey:@"fee"] doubleValue];
    self.timeLabel.text =  [self.stockInfo objectForKey:@"created_at"];
    self.time2Label.text = [self.stockInfo objectForKey:@"updated_at"];
    self.time3Label.text = [self.stockInfo objectForKey:@"updated_at"];
    
    self.nameLabel.text = [self.stockInfo objectForKey:@"market"];
    self.dealMoney.text = [NSString stringWithFormat:@"%.8lf",deal_money];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.8lf",price];
    self.price2Label.text = [NSString stringWithFormat:@"%.8lf",price];
    self.price3Label.text = [NSString stringWithFormat:@"%.8lf",price];
    
    self.dealAmount.text = [NSString stringWithFormat:@"%.8lf",deal_stock];
    self.dealAmount2Label.text = [NSString stringWithFormat:@"%.8lf",deal_stock];
    self.dealAmount3Label.text = [NSString stringWithFormat:@"%.8lf",deal_stock];
    
    self.feeLabel.text = [NSString stringWithFormat:@"%.8lf",fee];
    self.fee2Label.text = [NSString stringWithFormat:@"%.8lf",fee];
    self.fee3Label.text = [NSString stringWithFormat:@"%.8lf",fee];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
