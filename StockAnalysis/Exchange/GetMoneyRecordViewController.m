//
//  GetMoneyRecordViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import "GetMoneyRecordViewController.h"
#import "GetMoneyRecordTableViewCell.h"
#import "AppData.h"

@interface GetMoneyRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *assetName;

@property (weak, nonatomic) IBOutlet UITextField *assetAddress;
@property (weak, nonatomic) IBOutlet UITableView *recordList;
@property(nonatomic,strong) NSMutableArray* addressInfo;

@end

@implementation GetMoneyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"Cash_Record");
    self.recordList.delegate = self;
    self.recordList.dataSource = self;
    
    self.addressInfo = [NSMutableArray new];
    
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getAddress];
}

-(void)getAddress{
    NSString* url  = @"wallet/externalAddress";
    NSDictionary* parameters = @{};
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSMutableArray* info = [[data objectForKey:@"data"] objectForKey:@"address"];
                if(info && info.count>0){
                    weakSelf.addressInfo = info;
                    [weakSelf.recordList reloadData];
                }
            }else{
                
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickSelectAsset:(id)sender {
    
}
- (IBAction)clickGetMoney:(id)sender {
    if([self.assetAddress.text length]>0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:Localize(@"Cash_Fail_Tip")];
    }
    
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
    
    label.text = Localize(@"Cash_History");
    
    return headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressInfo.count;
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
    
    GetMoneyRecordTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GetMoneyRecordTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    if(self.addressInfo.count>indexPath.row){
        NSDictionary* info = [self.addressInfo objectAtIndex:[indexPath row]];
        
        cell.addressName.text = [info objectForKey:@"address"];
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    FirstListTableViewCell *vc = [[ChargeDetailViewController alloc] initWithNibName:@"FirstListTableViewCell" bundle:nil];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    GetMoneyRecordTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.assetAddress.text = cell.addressName.text;
    
}
@end
