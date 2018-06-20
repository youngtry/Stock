//
//  AllInfoViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/6/20.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AllInfoViewController.h"

@interface AllInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property(nonatomic, assign) UIColor* borderUIColor;
@end

@implementation AllInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBorderUIColor:[UIColor lightGrayColor]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //返回白色
    return UIStatusBarStyleLightContent;
    //返回黑色
    //return UIStatusBarStyleDefault;
}

-(void)setBorderUIColor:(UIColor*)color
{
    self.titleView.layer.borderColor=color.CGColor;
}
-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.titleView.layer.borderColor];
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
