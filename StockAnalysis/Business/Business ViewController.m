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
#import "BindViewController.h"
#import "SetMoneyPasswordViewController.h"


@interface Business_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *cnyMoney;
@property (weak, nonatomic) IBOutlet UILabel *usdMoney;
@property (weak, nonatomic) IBOutlet UITableView *moneyList;

@property (weak, nonatomic) IBOutlet UIImageView *lookMoney;
@property (nonatomic,strong) NSMutableDictionary* businessInfo;
@property (nonatomic,assign) BOOL isCanLook;
@end

@implementation Business_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = Localize(@"Buss_Acc");
    self.businessInfo = [NSMutableDictionary new];
    
    self.moneyList.delegate = self;
    self.moneyList.dataSource = self;
    self.isCanLook = YES;
    
    
    
    [self.lookMoney setUserInteractionEnabled:YES];
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLook)];
    [self.lookMoney addGestureRecognizer:f];
    
}
-(void)clickLook{
    if(_isCanLook){
        _isCanLook = NO;
        [self.lookMoney setImage:[UIImage imageNamed:@"eye-c"]];
        self.cnyMoney.text = [NSString stringWithFormat:@"¥%@",@"***"];
        self.usdMoney.text = [NSString stringWithFormat:@"$≈%@",@"***"];;
    }else{
        _isCanLook = YES;
        [self.lookMoney setImage:[UIImage imageNamed:@"eye-o"]];
        [self requestMoney];
    }
}

-(void)requestMoney{
    NSDictionary *parameters = @{ @"type": @"shop"};
    
    NSString* url = @"wallet/balance";
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            [weakSelf getBusinessBack:data];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    NSString* url = @"account/bindInfo";
    NSDictionary* params1 = @{};
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:params1 block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSDictionary* bindinfo = [data objectForKey:@"data"];
                //邮箱判断
                NSString* email = [bindinfo objectForKey:@"email"];
                
                if(email.length == 0){
                    //强制引导绑定邮箱
                    SCAlertController *alert = [SCAlertController alertControllerWithTitle:Localize(@"Menu_Title") message:Localize(@"Bind_Mail_Tip") preferredStyle:  UIAlertControllerStyleAlert];
                    alert.messageColor = kColor(136, 136, 136);
                    
                    
                    //退出
                    SCAlertAction *exitAction = [SCAlertAction actionWithTitle:Localize(@"Menu_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {;
                        BindViewController* vc = [[BindViewController alloc] initWithNibName:@"BindViewController" bundle:nil];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        vc.title = Localize(@"Bind_Mail");
                    }];
                    //单独修改一个按钮的颜色
                    exitAction.textColor = kColor(243, 186, 46);
                    [alert addAction:exitAction];
                    
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                    
                }
                
                NSString* phone = [bindinfo objectForKey:@"phone"];
                
                if(phone.length == 0){
                    //强制引导绑定手机
                    SCAlertController *alert = [SCAlertController alertControllerWithTitle:Localize(@"Menu_Title") message:Localize(@"Bind_Phone_Tip") preferredStyle:  UIAlertControllerStyleAlert];
                    alert.messageColor = kColor(136, 136, 136);
                    
                    
                    //退出
                    SCAlertAction *exitAction = [SCAlertAction actionWithTitle:Localize(@"Menu_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        BindViewController* vc = [[BindViewController alloc] initWithNibName:@"BindViewController" bundle:nil];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        vc.title = Localize(@"Bind_Phone");
                    }];
                    //单独修改一个按钮的颜色
                    exitAction.textColor = kColor(243, 186, 46);
                    [alert addAction:exitAction];
                    
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
                
                if(email.length>0 && phone.length>0){
                    //查看资金密码是否设置
                    NSString* url1 = @"account/has_assetpwd";
                    NSDictionary* params = @{};
                    
                    
                    [[HttpRequest getInstance] getWithURL:url1 parma:params block:^(BOOL success, id data) {
                        if(success){
                            if([[data objectForKey:@"ret"] intValue] == 1){
                                if(![[[data objectForKey:@"data"] objectForKey:@"has_assetpwd"] boolValue]){
                                    //未设置资金密码,强制引导
                                    
                                    SCAlertController *alert = [SCAlertController alertControllerWithTitle:Localize(@"Menu_Title") message:Localize(@"Set_Moeny_Pwd_Tip") preferredStyle:  UIAlertControllerStyleAlert];
                                    alert.messageColor = kColor(136, 136, 136);
                                    
                                    
                                    //退出
                                    SCAlertAction *exitAction = [SCAlertAction actionWithTitle:Localize(@"Menu_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        SetMoneyPasswordViewController* vc = [[SetMoneyPasswordViewController alloc] initWithNibName:@"SetMoneyPasswordViewController" bundle:nil];
                                        [weakSelf.navigationController pushViewController:vc animated:YES];
                                    }];
                                    //单独修改一个按钮的颜色
                                    exitAction.textColor = kColor(243, 186, 46);
                                    [alert addAction:exitAction];
                                    
                                    [weakSelf presentViewController:alert animated:YES completion:nil];
                                    
                                    
                                }
                            }else{
                                
                                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
                                
                            }
                        }
                    }];
                }
                
            }else{
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
    
    [self requestMoney];
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
    if(keys.count>indexPath.row){
        NSString* key = [keys objectAtIndex:[indexPath row]];
        
        NSDictionary* info = [self.businessInfo objectForKey:key];
        
        cell.name.text = key;
        cell.money.text = [NSString stringWithFormat:@"%.8lf",[[info objectForKey:@"available"] doubleValue]] ;
        
        cell.frizeeMoney.text = [NSString stringWithFormat:@"%@%.8lf",Localize(@"Freeze"),[[info objectForKey:@"freeze"] doubleValue]] ;
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
