//
//  PriceTipViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/23.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PriceTipViewController.h"
#import "MyTipsViewController.h"

@interface PriceTipViewController ()
@property (weak, nonatomic) IBOutlet UIView *priceTipSettingView;
@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UITextField *topLimitInput;
@property (weak, nonatomic) IBOutlet UILabel *topLimitUnit;
@property (weak, nonatomic) IBOutlet UITextField *lowLimitInput;
@property (weak, nonatomic) IBOutlet UILabel *lowLimitUnit;
@property (weak, nonatomic) IBOutlet UISwitch *priceSwitchBtn;
@property (nonatomic)BOOL isTip;
@property (nonatomic)BOOL isUpdate;
@property (nonatomic)int accountID;
@property (nonatomic,strong)NSString* state;
@end

@implementation PriceTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.accountID = -1;
    self.isUpdate = NO;
    self.isTip = NO;
    NSString* title = self.title;
    
    if([title rangeOfString:@"_"].location != NSNotFound){
        BOOL istip = [[title substringFromIndex:[title rangeOfString:@"_"].location+1] boolValue];
        self.isTip = istip;
        
        self.stockName.text = [title substringToIndex:[title rangeOfString:@"_"].location];
    }
    
    self.isUpdate = self.isTip;
    
    self.title = @"价格提醒";
    UIBarButtonItem* mytip = [[UIBarButtonItem alloc] initWithTitle:@"我的提醒" style:UIBarButtonItemStyleDone target:self action:@selector(showMyTips)];
    self.navigationItem.rightBarButtonItem = mytip;
    [mytip setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.65]];
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    [self.priceSwitchBtn setOn:self.isTip];
    [self.priceTipSettingView setHidden:!self.isTip];
    if(self.isTip){
        
    }
    [self requetTipInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)requetTipInfo{
    NSString* url = @"market/notice";
    NSDictionary* params = @{@"page":@(1),
                             @"page_limit":@(10),
                             @"state":@""
                             };
    
    [[HttpRequest getInstance] getWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* items = [[data objectForKey:@"data"] objectForKey:@"items"];
                for (NSDictionary* item in items) {
                    if([[item objectForKey:@"market"] isEqualToString:self.stockName.text]){
                        self.topLimitInput.text = [NSString stringWithFormat:@"%.4f", [[item objectForKey:@"upper_limit"] floatValue]];
                        self.lowLimitInput.text =[NSString stringWithFormat:@"%.4f", [[item objectForKey:@"lower_limit"] floatValue]] ;
                        self.accountID = [[item objectForKey:@"id"] intValue];
                        self.state = [item objectForKey:@"state"];
                    }
                }
            }
        }
    }];
}

-(void)test{
    [self.view endEditing:YES];
}

-(void)showMyTips{
    MyTipsViewController* vc = [[MyTipsViewController alloc] initWithNibName:@"MyTipsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tipSwitchChanged:(id)sender {
    UISwitch* btn = sender;
    if(btn.isOn){
        [self.priceTipSettingView setHidden:NO];
    }else{
        [self.priceTipSettingView setHidden:YES];
        self.state = @"disable";
        NSString* url = @"market/notice/del";
        NSDictionary* params = @{@"notice_id":@(self.accountID)
//                                 @"state":self.state
                                 };
//        [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
        [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
            if(success){
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"价格提醒删除成功"];
                }else{
                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
                }
            }
        }];
        
    }
    
}
- (IBAction)clickSaveBtn:(id)sender {
    
    if(self.isUpdate){
        self.state = @"enable";
        NSString* url = @"market/notice/update";
        NSDictionary* params = @{@"notice_id":@(self.accountID),
                                 @"state":self.state,
                                 @"upper_limit":@([self.topLimitInput.text floatValue]),
                                 @"lower_limit":@([self.lowLimitInput.text floatValue])
                                 };
//        [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
        [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
            if(success){
                if([[data objectForKey:@"ret"] intValue] == 1){
                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"价格更新成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
                }
            }
        }];
    }else{
        NSString* url = @"market/notice/add";
        NSDictionary* params = @{@"upper_limit":self.topLimitInput.text,
                                 @"lower_limit":self.lowLimitInput.text,
                                 @"market":self.stockName.text
                                 };
//        [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
        [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
            if(success){
                if([[data objectForKey:@"ret"] intValue] == 1){
//                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"价格提醒添加成功"];
//                    [self.navigationController popViewControllerAnimated:YES];
                    self.isUpdate = YES;
                    self.accountID = [[[data objectForKey:@"data"] objectForKey:@"notice_id"] intValue];
                    [self clickSaveBtn:nil];
                }else{
                    [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
                }
            }
        }];
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
