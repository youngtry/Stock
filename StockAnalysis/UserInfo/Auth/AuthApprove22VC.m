//
//  AuthApprove22VC.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AuthApprove22VC.h"
#import "AuthApprove23VC.h"
@interface AuthApprove22VC ()
@property (weak, nonatomic) IBOutlet UIImageView *authImage;

@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation AuthApprove22VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"级别2";
    self.nextBtn.layer.cornerRadius = 25;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.enabled = YES;
    
    self.preBtn.layer.cornerRadius = 25;
    self.preBtn.layer.masksToBounds = YES;
    self.preBtn.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickPreBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickNextBtn:(id)sender {
    AuthApprove23VC *vc = [[AuthApprove23VC alloc] initWithNibName:@"AuthApprove23VC" bundle:nil];
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
