//
//  GetMoneyRecordViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import "GetMoneyRecordViewController.h"

@interface GetMoneyRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *assetName;
- (IBAction)assetAddress:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *recordList;

@end

@implementation GetMoneyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";
    self.recordList.delegate = self;
    self.recordList.dataSource = self;
    
    
    
//    self.recordList.tableHeaderView = headerView;
//    self.recordList.tableHeaderView
    
//    [self.recordList set]
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickSelectAsset:(id)sender {
}
- (IBAction)clickGetMoney:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)assetAddress:(id)sender {
}

#pragma mark -UITableVIewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 38;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc]init];
    
    label.font = [UIFont systemFontOfSize:14];
    
    label.frame = CGRectMake(15, 10, 100, 20);
    
    [headerView addSubview:label];
    
    label.text = @"历史记录";
    
    return headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    indexPath.section
    //    indexPath.row
    //    if (indexPath.section == 0) {
    //        return 50;
    //    }
    return 38;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
//    NSArray* keys = [self.exchangeInfo allKeys];
//    NSString* key = [keys objectAtIndex:[indexPath row]];
//
//    NSDictionary* info = [self.exchangeInfo objectForKey:key];
//
//    cell.name.text = key;
//    cell.money.text = [NSString stringWithFormat:@"%.8f",[[info objectForKey:@"available"] floatValue]] ;
//
//    cell.frizeeMoney.text = [NSString stringWithFormat:@"冻结%.8f",[[info objectForKey:@"freeze"] floatValue]] ;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    FirstListTableViewCell *vc = [[ChargeDetailViewController alloc] initWithNibName:@"FirstListTableViewCell" bundle:nil];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    //    ExchangeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
}
@end
