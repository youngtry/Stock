//
//  GetMoneyViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "GetMoneyViewController.h"
#import "GetMoneyRecordViewController.h"
#import "AppData.h"
@interface GetMoneyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *assetName;

@end

@implementation GetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"Cash");

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Cash_Record") style:UIBarButtonItemStylePlain target:self action:@selector(clickRecord:)];
    self.navigationItem.rightBarButtonItem = right;
    
    
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

-(void)clickRecord:(id)sender{
    GetMoneyRecordViewController *vc = [[GetMoneyRecordViewController alloc] initWithNibName:@"GetMoneyRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickAssetSelect:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
