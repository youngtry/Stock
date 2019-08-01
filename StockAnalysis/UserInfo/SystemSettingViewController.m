//
//  SystemSettingViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/28.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "StoreUnitViewController.h"

@interface SystemSettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *unitView;
@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (weak, nonatomic) IBOutlet UIView *feilvView;
@property (weak, nonatomic) IBOutlet UIView *aboutView;
@property (weak, nonatomic) IBOutlet UILabel *unitName;

@end

@implementation SystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"System_Setting");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUnitView)];
    [self.unitView addGestureRecognizer:tap];
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

-(void)clickUnitView{
    StoreUnitViewController* vc = [[StoreUnitViewController alloc] initWithNibName:@"StoreUnitViewController" bundle:nil];
    NSString* currUnit = self.unitName.text;
    if([currUnit isEqualToString:Localize(@"CNY")]){
        [vc setTitle:@"CNY"];
    }else if([currUnit isEqualToString:Localize(@"USD")]){
        [vc setTitle:@"USD"];
    }
    
    
    [vc toReturnUnit:^(NSString *unit) {
        if([unit isEqualToString:@"CNY"]){
            self.unitName.text = Localize(@"CNY");
        }else if([unit isEqualToString:@"USD"]){
            self.unitName.text = Localize(@"USD");
        }
    }];
    
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
