//
//  AuthApprove21ViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/7/6.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AuthApprove21ViewController.h"
#import "AuthApprove22VC.h"
@interface AuthApprove21ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *authImage;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation AuthApprove21ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"级别2";
    self.nextButton.layer.cornerRadius = 25;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.enabled = YES;
}
- (IBAction)clickNext:(id)sender {
    AuthApprove22VC *vc = [[AuthApprove22VC alloc] initWithNibName:@"AuthApprove22VC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
