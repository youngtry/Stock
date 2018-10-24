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
#import "TurnMoneyViewController.h"
#import "ExchangeBillViewController.h"
#import "SetMoneyPasswordViewController.h"


@interface ExchangeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *RMBLabel;
@property (weak, nonatomic) IBOutlet UILabel *USDLabel;
@property (weak, nonatomic) IBOutlet UITableView *moneyList;
@property (weak, nonatomic) IBOutlet UIImageView *lookMoney;

@property (nonatomic,strong) NSMutableDictionary* exchangeInfo;
@property (nonatomic,assign) BOOL isCanLook;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"交易账户";
    self.exchangeInfo = [NSMutableDictionary new];
    self.isCanLook = YES;
    
    self.moneyList.delegate = self;
    self.moneyList.dataSource = self;
    
    [self.lookMoney setUserInteractionEnabled:YES];
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLook)];
    [self.lookMoney addGestureRecognizer:f];

}
-(void)clickLook{
    if(_isCanLook){
        _isCanLook = NO;
        [self.lookMoney setImage:[UIImage imageNamed:@"eye-c"]];
        self.RMBLabel.text = [NSString stringWithFormat:@"¥%@",@"***"];
        self.USDLabel.text = [NSString stringWithFormat:@"$≈%@",@"***"];;
    }else{
        _isCanLook = YES;
        [self.lookMoney setImage:[UIImage imageNamed:@"eye-o"]];
        [self requestExchangeList];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* url1 = @"account/has_assetpwd";
    NSDictionary* params = @{};
    
    [[HttpRequest getInstance] getWithURL:url1 parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                if(![[[data objectForKey:@"data"] objectForKey:@"has_assetpwd"] boolValue]){
                    //未设置资金密码,强制引导
                    
                    SCAlertController *alert = [SCAlertController alertControllerWithTitle:@"提示" message:@"您还为设置资金密码,请先设置资金密码" preferredStyle:  UIAlertControllerStyleAlert];
                    alert.messageColor = kColor(136, 136, 136);
                    
                    
                    //退出
                    SCAlertAction *exitAction = [SCAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        SetMoneyPasswordViewController* vc = [[SetMoneyPasswordViewController alloc] initWithNibName:@"SetMoneyPasswordViewController" bundle:nil];
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    //单独修改一个按钮的颜色
                    exitAction.textColor = kColor(243, 186, 46);
                    [alert addAction:exitAction];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                }
            }else{
                
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
    
    [self requestExchangeList];
}

-(void)requestExchangeList{
    NSDictionary *parameters = @{ @"type": @"exchange"};
    
    NSString* url = @"wallet/balance";
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
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
//        NSLog(@"info = %@",info);
        
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
    
    ChargeViewController *vc = [[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [[AppData getInstance] setExchangeButtonIndex:2];
    
    
}
- (IBAction)clickBillButton:(id)sender {
    ExchangeBillViewController *vc = [[ExchangeBillViewController alloc] initWithNibName:@"ExchangeBillViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)hideZero:(id)sender {
    UISwitch* btn = sender;
    if(btn.isOn){
        [self hideZeroMoney];
    }else{
        [self requestExchangeList];
    }
}

-(void)hideZeroMoney{
    NSArray* keys = [self.exchangeInfo allKeys];
    NSMutableArray* hideKey = [NSMutableArray new];
    for (NSString* key in keys) {
        NSDictionary* info = [self.exchangeInfo objectForKey:key];
        float left = [[info objectForKey:@"available"] floatValue];
        if(left <= 0){
            [hideKey addObject:key];
        }
    }
    
    for (NSString* key in hideKey) {
        [self.exchangeInfo removeObjectForKey:key];
    }
    
    
    [_moneyList reloadData];
    
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
    if(keys.count>indexPath.row){
        NSString* key = [keys objectAtIndex:[indexPath row]];
        
        NSDictionary* info = [self.exchangeInfo objectForKey:key];
        
        cell.name.text = key;
        cell.money.text = [NSString stringWithFormat:@"%.8f",[[info objectForKey:@"available"] floatValue]] ;
        
        cell.frizeeMoney.text = [NSString stringWithFormat:@"冻结%.8f",[[info objectForKey:@"freeze"] floatValue]] ;
    }
    
    
    
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
