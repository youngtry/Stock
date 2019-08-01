//
//  StoreUnitViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/24.
//  Copyright © 2018年 try. All rights reserved.
//

#import "StoreUnitViewController.h"

@interface StoreUnitViewController ()

@property (nonatomic, strong)NSString* currentUnit;

@end

@implementation StoreUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUnit = self.title;
    
    self.title = Localize(@"Store_Trade_Setting");
    // Do any additional setup after loading the view from its nib.
    
    [self setUnit:self.currentUnit];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickCNY:(id)sender {
    if(self.returnUnit){
        self.returnUnit(@"CNY");
        self.currentUnit = @"CNY";
        [self setUnit:self.currentUnit];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickUSD:(id)sender {
    if(self.returnUnit){
        self.returnUnit(@"USD");
        self.currentUnit = @"USD";
        [self setUnit:self.currentUnit];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)setUnit:(NSString* )unit{
    if([unit isEqualToString:@"CNY"]){
        [self.cnyIcon setHidden:NO];
        [self.cnyName setTextColor:kColor(243, 186, 46)];
        [self.usdIcon setHidden:YES];
        [self.usdName setTextColor:kColor(0, 0, 0)];
    }else if ([unit isEqualToString:@"USD"]){
        [self.usdIcon setHidden:NO];
        [self.usdName setTextColor:kColor(243, 186, 46)];
        [self.cnyIcon setHidden:YES];
        [self.cnyName setTextColor:kColor(0, 0, 0)];
    }
}

-(void)toReturnUnit:(returnUnit)block{
    self.returnUnit = block;
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
