//
//  PriceTipViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/23.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PriceTipViewController.h"

@interface PriceTipViewController ()
@property (weak, nonatomic) IBOutlet UIView *priceTipSettingView;
@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UITextField *topLimitInput;
@property (weak, nonatomic) IBOutlet UILabel *topLimitUnit;
@property (weak, nonatomic) IBOutlet UITextField *lowLimitInput;
@property (weak, nonatomic) IBOutlet UILabel *lowLimitUnit;

@end

@implementation PriceTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"价格提醒";
    UIBarButtonItem* mytip = [[UIBarButtonItem alloc] initWithTitle:@"我的提醒" style:UIBarButtonItemStyleDone target:self action:@selector(showMyTips)];
    self.navigationItem.rightBarButtonItem = mytip;
    [mytip setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.65]];
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
}

-(void)test{
    [self.view endEditing:YES];
}

-(void)showMyTips{
    
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
    }
    
}
- (IBAction)clickSaveBtn:(id)sender {
    
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
