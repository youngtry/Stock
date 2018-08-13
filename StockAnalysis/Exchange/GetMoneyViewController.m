//
//  GetMoneyViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "GetMoneyViewController.h"
#import "GetMoneyRecordViewController.h"
@interface GetMoneyViewController ()

@end

@implementation GetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现";
    
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(clickRecord:)];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)clickRecord:(id)sender{
    GetMoneyRecordViewController *vc = [[GetMoneyRecordViewController alloc] initWithNibName:@"GetMoneyRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
