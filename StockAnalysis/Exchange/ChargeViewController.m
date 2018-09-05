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
#import "HttpRequest.h"
#import "TurnMoneyViewController.h"

@interface ChargeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *selectTable;
@property (nonatomic)int index;

@property (nonatomic,strong) NSMutableDictionary* exchangeInfo;

@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择";
    self.exchangeInfo = [NSMutableDictionary new];
    _selectTable.delegate = self;
    _selectTable.dataSource = self;
    
    
    self.index = 0;//默认是点击的充值界面,1代表提现，2代表资金划转,3代表资金划转
    NSString* type = @"exchange";
    NSDictionary *parameters = @{ @"type": type};
    
    NSString* url = @"wallet/balance";
    
    //    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"GetExchangeBack"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [self getExchangeBack:data];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)getExchangeBack:(NSDictionary*)data{
    //    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1){
        //获取成功
        NSDictionary* info = [data objectForKey:@"data"];
        NSLog(@"info = %@",info);
        
        NSDictionary* exchange = [info objectForKey:@"exchange"];
        
        if(exchange.count>0){
            [self.exchangeInfo removeAllObjects];
            
            self.exchangeInfo = [[NSMutableDictionary alloc] initWithDictionary:exchange];
            
            [self.selectTable reloadData];
            
        }
        
        
    }else{
        NSString* msg = [data objectForKey:@"msg"];
        
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:msg];
    }
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
    return self.exchangeInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    
    NSArray* keys = [self.exchangeInfo allKeys];
    NSString* key = [keys objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = key;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.navigationController get]
//    NSArray* vcs = [self.navigationController viewControllers];
//    UIViewController* lastvc = vcs[vcs.count-2];
//    if([lastvc isKindOfClass:[ChargeAddressViewController class]]){
//
//    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [[AppData getInstance] setAssetName:cell.textLabel.text];
    self.index = [[AppData getInstance] getExchangeButtonIndex];
    if(self.index == 0){
        ChargeAddressViewController *vc = [[ChargeAddressViewController alloc] initWithNibName:@"ChargeAddressViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(self.index == 1){
        GetMoneyViewController *vc = [[GetMoneyViewController alloc] initWithNibName:@"GetMoneyViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.index == 2){TurnMoneyViewController* vc = [[TurnMoneyViewController alloc] initWithNibName:@"TurnMoneyViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];}
    
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
