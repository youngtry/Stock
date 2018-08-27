//
//  OrderPayDetailViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "OrderPayDetailViewController.h"
#import "PayStyleView.h"

@interface OrderPayDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *payStyleSwitch;

@end

@implementation OrderPayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //两个view的颜色和其中的文字可根据具体页面来更换
    self.authView.layer.borderColor = kColor(240, 186, 81).CGColor;
    self.authView.layer.borderWidth = 0.5;
    
    self.depositView.layer.borderColor = kColor(75, 185, 112).CGColor;
    self.depositView.layer.borderWidth = 0.5;
    
    [self.cardInfoView setHidden:NO];
    [self.actionBtn setHidden:YES];
    
    [self.payStyleSwitch setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.payStyleSwitch addGestureRecognizer:tapGesturRecognizer];
    
    
}

-(void)tapAction:(id)sender{
    PayStyleView* pay = [[PayStyleView alloc] init];
    [pay showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
