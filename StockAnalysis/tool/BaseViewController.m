//
//  BaseViewController.m
//  StockAnalysis
//
//  Created by try on 2018/9/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButton];
}
-(void)setBackButton{
    //设置返回按钮
    UIBarButtonItem * backBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
}

#pragma mark - lazy 各控件的初始化方法
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 50, 40);
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
        [_backButton addTarget:self action:@selector(navBackClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

#pragma mark - click 导航栏按钮点击方法，右按钮点击方法都需要子类来实现
-(void)navBackClick{
    [self.navigationController popViewControllerAnimated:YES];
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
