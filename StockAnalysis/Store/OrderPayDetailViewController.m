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
@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UIView *showConfirmVIew;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)tapAction:(id)sender{
    PayStyleView* pay = [[PayStyleView alloc] initWithFrame:CGRectZero withView:self.view];
    pay.block = ^(int index) {
        NSArray* titles = @[@"银行卡支付",@"微信支付",@"支付宝支付"];
        NSArray* pics = @[@"card.png",@"weixin.png",@"zhifubao.png"];
        self.payIcon.image = [UIImage imageNamed:pics[index-1]];
        self.payName.text = titles[index-1];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickCancel:(id)sender {
}
- (IBAction)clickPay:(id)sender {
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
