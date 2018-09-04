//
//  Business ViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "Business ViewController.h"
#import "HttpRequest.h"
#import "ExchangeTableViewCell.h"
#import "PayTYpeViewController.h"
#import "ChargeViewController.h"
#import "AppData.h"


@interface Business_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *cnyMoney;
@property (weak, nonatomic) IBOutlet UILabel *usdMoney;
@property (weak, nonatomic) IBOutlet UITableView *moneyList;

@property (nonatomic,strong) NSMutableDictionary* businessInfo;

@end

@implementation Business_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"商户账户";
    self.businessInfo = [NSMutableDictionary new];
    
    self.moneyList.delegate = self;
    self.moneyList.dataSource = self;
    
    NSDictionary *parameters = @{ @"type": @"shop"};
    
    NSString* url = @"wallet/balance";

    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [self getBusinessBack:data];
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
-(void)getBusinessBack:(NSDictionary*)data{
    //    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1){
        //获取成功
        NSDictionary* info = [data objectForKey:@"data"];
        NSLog(@"info = %@",info);
        
        NSString* cny = [info objectForKey:@"total_cny"];
        
        self.cnyMoney.text = [NSString stringWithFormat:@"¥%@",cny];;
        
        NSString* usd = [info objectForKey:@"total_usd"];
        
        self.usdMoney.text = [NSString stringWithFormat:@"$≈%@",usd];
        
        
        NSDictionary* exchange = [info objectForKey:@"shop"];
        
        if(exchange.count>0){
            [self.businessInfo removeAllObjects];
            
            self.businessInfo = [[NSMutableDictionary alloc] initWithDictionary:exchange];
            
            [self.moneyList reloadData];
            
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
- (IBAction)clickPayStyle:(id)sender {
    PayTYpeViewController* vc = [[PayTYpeViewController alloc] initWithNibName:@"PayTYpeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickMoney:(id)sender {
    ChargeViewController *vc = [[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [[AppData getInstance] setExchangeButtonIndex:2];
}

#pragma mark -UITableVIewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.businessInfo.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    indexPath.section
    //    indexPath.row
    //    if (indexPath.section == 0) {
    //        return 50;
    //    }
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExchangeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSArray* keys = [self.businessInfo allKeys];
    NSString* key = [keys objectAtIndex:[indexPath row]];
    
    NSDictionary* info = [self.businessInfo objectForKey:key];
    
    cell.name.text = key;
    cell.money.text = [NSString stringWithFormat:@"%.8f",[[info objectForKey:@"available"] floatValue]] ;
    
    cell.frizeeMoney.text = [NSString stringWithFormat:@"冻结%.8f",[[info objectForKey:@"freeze"] floatValue]] ;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    FirstListTableViewCell *vc = [[ChargeDetailViewController alloc] initWithNibName:@"FirstListTableViewCell" bundle:nil];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    //    ExchangeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
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
