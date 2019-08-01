//
//  MarqueeContentViewController.m
//  StockAnalysis
//
//  Created by try on 2018/10/11.
//  Copyright © 2018年 try. All rights reserved.
//

#import "MarqueeContentViewController.h"

@interface MarqueeContentViewController ()

@end

@implementation MarqueeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Close") style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = right;
//    self.contentTextView.text = @"aaaaaaa";
}

-(void)close{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = YES;
    if(self.block){
        self.block();
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
