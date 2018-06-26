//
//  ChargeAddressViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ChargeAddressViewController.h"
#import "ChargeRecordViewController.h"

@interface ChargeAddressViewController ()

@end

@implementation ChargeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"充值记录" style:UIBarButtonItemStylePlain target:self action:@selector(clickRecord:)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.title = @"交易账户充值";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickRecord:(id)sender{
    ChargeRecordViewController *vc = [[ChargeRecordViewController alloc] initWithNibName:@"ChargeRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
