//
//  MoneyInOutViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "MoneyInOutViewController.h"
#import "AppData.h"
@interface MoneyInOutViewController ()
@property (weak, nonatomic) IBOutlet UIButton *turnBtn;
@property (weak, nonatomic) IBOutlet UILabel *marketName;

@end

@implementation MoneyInOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.marketName.text = [[AppData getInstance] getAssetName];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSDictionary *parameters = @{ @"type": @""};
    
    NSString* url = @"wallet/balance";
    
    //    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"GetExchangeBack"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [self showLeftMoney:data];
        }
    }];
}

-(void)showLeftMoney:(NSDictionary*)data{
    if([[data objectForKey:@"ret"] intValue] == 1){
        NSString* title = self.title;
        
        NSDictionary* info = [data objectForKey:@"data"];
        NSLog(@"当前页面title = %@",info);
        if([title isEqualToString:@"0"]){
            self.turnOutName.text = @"交易账户";
            self.turnInName.text = @"商户账户";
            NSDictionary* exchange =[info objectForKey:@"exchange"];
            if(exchange){
                NSDictionary* left = [exchange objectForKey:self.marketName.text];
                if(left){
                    NSString* available = [left objectForKey:@"available"];
                    self.leftMonetCount.text = [NSString stringWithFormat:@"可转%@",available];
                }
            }
            
            
        }else{
            self.turnOutName.text = @"商户账户";
            self.turnInName.text = @"交易账户";
            
            NSDictionary* shop =[info objectForKey:@"shop"];
            if(shop){
                NSDictionary* left = [info objectForKey:self.marketName.text];
                if(left){
                    NSString* available = [left objectForKey:@"available"];
                    self.leftMonetCount.text = [NSString stringWithFormat:@"可转%@",available];
                }
            }
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickTurnBtn:(id)sender {
}
- (IBAction)clickSelectBtn:(id)sender {
    id temp = self.parentViewController.view.selfViewController.navigationController;
    [temp popViewControllerAnimated:YES];
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
