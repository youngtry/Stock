//
//  ExchangeViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/6/20.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ChargeViewController.h"
#import "AppData.h"
#import "HttpRequest.h"
#import "ExchangeTableViewCell.h"


@interface ExchangeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *RMBLabel;
@property (weak, nonatomic) IBOutlet UILabel *USDLabel;
@property (weak, nonatomic) IBOutlet UITableView *moneyList;

@property (nonatomic,strong) NSMutableDictionary* exchangeInfo;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"交易账户";
    self.exchangeInfo = [NSMutableDictionary new];
    
    self.moneyList.delegate = self;
    self.moneyList.dataSource = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getExchangeBack) name:@"GetExchangeBack" object:nil];
    
    NSDictionary *parameters = @{ @"type": @"exchange"};
    
    NSString* url = @"wallet/balance";
    
//    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"GetExchangeBack"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [self getExchangeBack:data];
        }
    }];
    
}

-(void)getExchangeBack:(NSDictionary*)data{
//    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSNumber* ret = [data objectForKey:@"ret"];
    if([ret intValue] == 1){
        //获取成功
        NSDictionary* info = [data objectForKey:@"data"];
        NSLog(@"info = %@",info);
        
        NSString* cny = [info objectForKey:@"total_cny"];
        
        self.RMBLabel.text = [NSString stringWithFormat:@"¥%@",cny];;
        
        NSString* usd = [info objectForKey:@"total_usd"];
        
        self.USDLabel.text = [NSString stringWithFormat:@"$≈%@",usd];
        
        
        NSDictionary* exchange = [info objectForKey:@"exchange"];
        
        if(exchange.count>0){
            [self.exchangeInfo removeAllObjects];
            
            self.exchangeInfo = [[NSMutableDictionary alloc] initWithDictionary:exchange];
            
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //返回白色
    return UIStatusBarStyleLightContent;
    //返回黑色
    //return UIStatusBarStyleDefault;
}
- (IBAction)clickChargeButton:(id)sender {
//    [self.navigationController setNavigationBarHidden:NO];
    ChargeViewController *vc = [[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [[AppData getInstance] setExchangeButtonIndex:0];
}
- (IBAction)clickTixianButton:(id)sender {
    ChargeViewController *vc = [[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [[AppData getInstance] setExchangeButtonIndex:1];
}
- (IBAction)clickMoneyInOutButton:(id)sender {
}
- (IBAction)clickBillButton:(id)sender {
}
- (IBAction)hideZero:(id)sender {
}
#pragma mark -UITableVIewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.exchangeInfo.count;
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
    
    NSArray* keys = [self.exchangeInfo allKeys];
    NSString* key = [keys objectAtIndex:[indexPath row]];
    
    NSDictionary* info = [self.exchangeInfo objectForKey:key];
    
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
