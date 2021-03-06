//
//  PayTYpeViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/8/14.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PayTYpeViewController.h"
#import "EnterBankInfoViewController.h"
#import "WechatViewController.h"
#import "ZhifubaoViewController.h"

@interface PayTYpeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bankCard;
@property (weak, nonatomic) IBOutlet UILabel *wechatPay;
@property (weak, nonatomic) IBOutlet UILabel *zhifubaoPay;

@end

@implementation PayTYpeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =  Localize(@"Set_Pay");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    NSString* url = @"wallet/payment";
    NSDictionary* params = @{};
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] getWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSDictionary* info = [data objectForKey:@"data"];
                if([info objectForKey:@"bank"]){
                    weakSelf.bankCard.text = Localize(@"Binded");
                }
                
                if([info objectForKey:@"wechat"]){
                    weakSelf.wechatPay.text = Localize(@"Binded");
                }
                
                if([info objectForKey:@"alipay"]){
                    weakSelf.zhifubaoPay.text = Localize(@"Binded");
                }
            }
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickAddBankCard:(id)sender {
    EnterBankInfoViewController* vc = [[EnterBankInfoViewController alloc] initWithNibName:@"EnterBankInfoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickAddWechatPay:(id)sender {
    WechatViewController* vc = [[WechatViewController alloc] initWithNibName:@"WechatViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickAddZhifubaoPay:(id)sender {
    ZhifubaoViewController* vc = [[ZhifubaoViewController alloc] initWithNibName:@"ZhifubaoViewController" bundle:nil];
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
