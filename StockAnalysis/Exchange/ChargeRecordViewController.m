//
//  ChargeRecordViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ChargeRecordViewController.h"
#import "ChargeRecordTableViewCell.h"
#import "ChargeDetailViewController.h"

@interface ChargeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *recordList;

@end

@implementation ChargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"最近十天充值记录";
    
    self.recordList.delegate = self;
    self.recordList.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableVIewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    indexPath.section
    //    indexPath.row
//    if (indexPath.section == 0) {
//        return 50;
//    }
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ChargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chargecell"];
    if(!cell){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChargeRecordTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChargeDetailViewController *vc = [[ChargeDetailViewController alloc] initWithNibName:@"ChargeDetailViewController" bundle:nil];
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
