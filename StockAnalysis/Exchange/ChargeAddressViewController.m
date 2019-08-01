//
//  ChargeAddressViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ChargeAddressViewController.h"
#import "ChargeRecordViewController.h"
#import "AppData.h"
@interface ChargeAddressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *assetName;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;

@end

@implementation ChargeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Charge_Record") style:UIBarButtonItemStylePlain target:self action:@selector(clickRecord:)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.title = Localize(@"Trade_Acc_Charge");
    
    self.assetName.text = [[AppData getInstance] getAssetName];
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    
}

-(void)test{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickRecord:(id)sender{
    ChargeRecordViewController *vc = [[ChargeRecordViewController alloc] initWithNibName:@"ChargeRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickSelectAsset:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickCopy:(id)sender {
    [HUDUtil showHudViewTipInSuperView:self.view withMessage:Localize(@"Copy")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.addressLabel.text;
    

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
