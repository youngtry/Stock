//
//  ChargeViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ChargeViewController.h"
#import "ChargeAddressViewController.h"
#import "AppData.h"
#import "GetMoneyViewController.h"

@interface ChargeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *selectTable;
@property (nonatomic)int index;

@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择";
    
    _selectTable.delegate = self;
    _selectTable.dataSource = self;
    
    
    self.index = 0;//默认是点击的充值界面,1代表提现，2代表资金划转
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UITableVIewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if(0 == indexPath.row){
        cell.textLabel.text = @"期货1";
    }else if(1 == indexPath.row){
        cell.textLabel.text = @"期货2";
    }
    else if(2 == indexPath.row){
        cell.textLabel.text = @"期货3";
    }
    else if(3 == indexPath.row){
        cell.textLabel.text = @"期货4";
    }
    else if(4 == indexPath.row){
        cell.textLabel.text = @"期货5";
    }
    else if(5 == indexPath.row){
        cell.textLabel.text = @"期货6";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.navigationController get]
//    NSArray* vcs = [self.navigationController viewControllers];
//    UIViewController* lastvc = vcs[vcs.count-2];
//    if([lastvc isKindOfClass:[ChargeAddressViewController class]]){
//
//    }
    self.index = [[AppData getInstance] getExchangeButtonIndex];
    if(self.index == 0){
        ChargeAddressViewController *vc = [[ChargeAddressViewController alloc] initWithNibName:@"ChargeAddressViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(self.index == 1){
        GetMoneyViewController *vc = [[GetMoneyViewController alloc] initWithNibName:@"GetMoneyViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
