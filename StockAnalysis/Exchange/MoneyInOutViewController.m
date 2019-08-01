//
//  MoneyInOutViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "MoneyInOutViewController.h"
#import "AppData.h"
#import "MoneyVerifyViewController.h"
#import "ExchangeViewController.h"
#import "Business ViewController.h"

@interface MoneyInOutViewController ()
@property (weak, nonatomic) IBOutlet UIButton *turnBtn;
@property (weak, nonatomic) IBOutlet UILabel *marketName;
@property (weak, nonatomic) IBOutlet UITextField *turnInput;

@property (nonatomic,assign) BOOL isBussiness;

@end

@implementation MoneyInOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.marketName.text = [[AppData getInstance] getAssetName];
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    self.turnInput.keyboardType = UIKeyboardTypeAlphabet;
    [self.turnBtn setEnabled:NO];
    
    self.isBussiness = NO;
    
    if([self.title isEqualToString:@"0"]){
        [self.turnBtn setTitle:Localize(@"Turn_In") forState:UIControlStateNormal];
        self.turnInput.placeholder = Localize(@"Turn_In_Num");
    }else{
        [self.turnBtn setTitle:Localize(@"Turn_Out") forState:UIControlStateNormal];
        self.turnInput.placeholder = Localize(@"Turn_Out_Num");
    }
}

-(void)test{
    [self.view endEditing:YES];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSDictionary *parameters = @{ @"type": @""};
    
    NSString* url = @"wallet/balance";
    
    //    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"GetExchangeBack"];
    
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    
    for (UIViewController*vc in temp.childViewControllers) {
        if([vc isKindOfClass:[ExchangeViewController class]]){
            self.isBussiness = NO;
        }
        
        if([vc isKindOfClass:[Business_ViewController class]]){
            self.isBussiness = YES;
        }
    }
    WeakSelf(weakSelf);
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            [weakSelf showLeftMoney:data];
        }
    }];
}

-(void)showLeftMoney:(NSDictionary*)data{
    if([[data objectForKey:@"ret"] intValue] == 1){
        NSString* title = self.title;
        
        NSDictionary* info = [data objectForKey:@"data"];
//        NSLog(@"当前页面title = %@",info);
        if([title isEqualToString:@"0"]){
            if(self.isBussiness){
               
                self.turnOutName.text = Localize(@"Trade_Acc");
                self.turnInName.text = Localize(@"Buss_Acc");
                
                NSDictionary* exchange =[info objectForKey:@"exchange"];
                if(exchange){
                    NSDictionary* left = [exchange objectForKey:self.marketName.text];
                    if(left){
                        NSString* available = [left objectForKey:@"available"];
                        self.leftMonetCount.text = [NSString stringWithFormat:@"%@%@",Localize(@"Can_Turn"),available];
                    }
                }
                
            }else{
                
                self.turnInName.text = Localize(@"Trade_Acc");
                self.turnOutName.text = Localize(@"Buss_Acc");
                
                NSDictionary* exchange =[info objectForKey:@"shop"];
                if(exchange){
                    NSDictionary* left = [exchange objectForKey:self.marketName.text];
                    if(left){
                        NSString* available = [left objectForKey:@"available"];
                        self.leftMonetCount.text = [NSString stringWithFormat:@"%@%@",Localize(@"Can_Turn"),available];
                    }
                }
            }
            
            
            
            
        }else{
            
            if(self.isBussiness){
                self.turnOutName.text = Localize(@"Buss_Acc");
                self.turnInName.text = Localize(@"Trade_Acc");
                
                NSDictionary* shop =[info objectForKey:@"shop"];
                if(shop){
                    NSDictionary* left = [shop objectForKey:self.marketName.text];
                    if(left){
                        NSString* available = [left objectForKey:@"available"];
                        self.leftMonetCount.text = [NSString stringWithFormat:@"%@%@",Localize(@"Can_Turn"),available];
                    }
                }
                
            }else{
                self.turnOutName.text = Localize(@"Trade_Acc");
                self.turnInName.text = Localize(@"Buss_Acc");
                
                NSDictionary* shop =[info objectForKey:@"exchange"];
                if(shop){
                    NSDictionary* left = [shop objectForKey:self.marketName.text];
                    if(left){
                        NSString* available = [left objectForKey:@"available"];
                        self.leftMonetCount.text = [NSString stringWithFormat:@"%@%@",Localize(@"Can_Turn"),available];
                    }
                }
            }
            
            
            
            
            
        }
    }else{
        
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editEnd:(id)sender {
    UITextField* input = sender;
    NSString* num = input.text;
    
    if(num.length>0){
        NSInteger index = [self.leftMonetCount.text rangeOfString:Localize(@"Can_Turn")].location+[Localize(@"Can_Turn") length];
        NSString* left = [self.leftMonetCount.text substringFromIndex:index];
        NSLog(@"left = %@",left);
        
        if([left floatValue]>=[num floatValue] && [num floatValue] > 0){
            [self.turnBtn setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0]];
            [self.turnBtn setEnabled:YES];
        }else{
            [self.turnBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0]];
            [self.turnBtn setEnabled:NO];
        }
    }else{
        [self.turnBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0]];
        [self.turnBtn setEnabled:NO];
    }

}
- (IBAction)clickTurnBtn:(id)sender {
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    MoneyVerifyViewController* vc = [[MoneyVerifyViewController alloc] initWithNibName:@"MoneyVerifyViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    temp.definesPresentationContext = YES;
    [temp presentViewController:vc animated:YES completion:nil];
    WeakSelf(weakSelf);
    vc.block = ^(NSString* token) {
        if(token.length>0){
            
            NSString* mode = @"toexchange";
            NSString* url = @"wallet/transfer";
            if([weakSelf.title isEqualToString:@"0"]){
                if(weakSelf.isBussiness){
                    mode = @"toshop";
                }else{
                    mode = @"toexchange";
                }
                
            }else{
                if(weakSelf.isBussiness){
                    mode = @"toexchange";
                }else{
                    mode = @"toshop";
                }
            }
            NSDictionary* parameters = @{@"asset":weakSelf.marketName.text,
                                         @"num":@([weakSelf.turnInput.text floatValue]),
                                         @"mode":mode,
                                         @"asset_token":token
                                         };
//            [HUDUtil showHudViewInSuperView:temp.view withMessage:@"请求中…"];
            [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
                if(success){
                    if([[data objectForKey:@"ret"] intValue] == 1){
                        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Turn_In_Succ")];
                        
                        if([weakSelf.title isEqualToString:@"0"]){
                            for (UIViewController*vc in temp.childViewControllers) {
                                if([vc isKindOfClass:[ExchangeViewController class]]){
                                    [temp popToViewController:vc animated:YES];
                                    break;
                                }
                                if([vc isKindOfClass:[Business_ViewController class]]){
                                    [temp popToViewController:vc animated:YES];
                                    break;
                                }
                            }
                        }else{
                            for (UIViewController*vc in temp.childViewControllers) {
                                if([vc isKindOfClass:[ExchangeViewController class]]){
                                    [temp popToViewController:vc animated:YES];
                                    break;
                                }
                                if([vc isKindOfClass:[Business_ViewController class]]){
                                    [temp popToViewController:vc animated:YES];
                                    break;
                                }
                            }
                        }
                        
                    }else{
                        [HUDUtil showHudViewTipInSuperView:temp.view withMessage:[data objectForKey:@"msg"]];
                    }
                }
            }];
        }else{
            [HUDUtil showHudViewTipInSuperView:temp.view withMessage:Localize(@"Money_Pwd_Error")];
        }
    };
    
    
    
    
//    id temp = self.parentViewController.view.selfViewController.navigationController;
//    [temp popViewControllerAnimated:YES];
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
