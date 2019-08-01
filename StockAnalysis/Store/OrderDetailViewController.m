//
//  OrderDetailViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "CommonOrderTableViewCell.h"
#import "UnpayTableViewCell.h"
#import "OrderPayDetailViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderList;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"全部订单";
    self.orderList.delegate = self;
    self.orderList.dataSource = self;
    
    self.orderList.tableFooterView = [UIView new];
//    self.orderList.separatorStyle = UITableViewSeparatorInsetFromAutomaticInsets;
    
    if ([self.orderList respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.orderList setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.orderList respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.orderList setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.title isEqualToString:Localize(@"Undone")]){
        return 150;
    }
    return 105;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.title isEqualToString:Localize(@"Undone")]){
        UnpayTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if(nil == cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UnpayTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        cell.stateLabel.text = Localize(@"Wait_To_Pay");
        
        return cell;
    }
    CommonOrderTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(nil == cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if([self.title isEqualToString:Localize(@"Finished")]){
        cell.stateLabel.text = Localize(@"Finished");
    }else{
        cell.stateLabel.text = Localize(@"Unpay_Error");
        if(kScreenWidth == 320){
            cell.stateLabel.text = Localize(@"Already_Cancel");
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderPayDetailViewController* vc = [[OrderPayDetailViewController alloc] initWithNibName:@"OrderPayDetailViewController" bundle:nil];
    id temp = self.parentViewController.view.selfViewController.navigationController;
    [temp pushViewController:vc animated:YES];
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
