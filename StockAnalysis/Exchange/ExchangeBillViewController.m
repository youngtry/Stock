//
//  ExchangeBillViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/15.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ExchangeBillViewController.h"
#import "ExchangeBillTableViewCell.h"

@interface ExchangeBillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *allNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *allTypeBtn;
@property (weak, nonatomic) IBOutlet UITableView *nameList;
@property (weak, nonatomic) IBOutlet UITableView *typeList;

@property (nonatomic,strong)NSMutableArray* nameArray;
@property (nonatomic,strong)NSMutableArray* typeArray;

@end

@implementation ExchangeBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"交易账单";
    
    self.nameList.delegate = self;
    self.nameList.dataSource = self;
    self.typeList.delegate = self;
    self.typeList.dataSource = self;
    
    self.nameArray = [NSMutableArray new];
    self.typeArray = [NSMutableArray new];
    
    self.nameList.tableFooterView = [UIView new];
    self.typeList.tableFooterView = [UIView new];
    
    [self.nameList setHidden:YES];
    [self.typeList setHidden:YES];
    
    [self.nameArray addObject:@"全部"];
    for (int i=0;i<8; i++) {
        NSString* info = [NSString stringWithFormat:@"期货%d",i];
        [self.nameArray addObject:info];
    }
    [self.typeArray addObject:@"全部"];
    [self.typeArray addObject:@"充值"];
    [self.typeArray addObject:@"提现"];
    [self.typeArray addObject:@"买入"];
    [self.typeArray addObject:@"卖出"];
    [self.typeArray addObject:@"新手任务"];
    [self.typeArray addObject:@"邀请好友完成新手任务"];
    [self.typeArray addObject:@"扣除任务奖励"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickAllNameBtn:(id)sender {
    if(self.nameList.isHidden){
        [self.nameList setHidden:NO];
        [self.nameList reloadData];
    }else{
        [self.nameList setHidden:YES];
    }
    
}
- (IBAction)clickAllTypeBtn:(id)sender {
    if(self.typeList.isHidden){
        [self.typeList setHidden:NO];
        [self.typeList reloadData];
    }else{
        [self.typeList setHidden:YES];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.nameList){
        return self.nameArray.count;
    }
    
    if(tableView == self.typeList){
        return self.typeArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExchangeBillTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ExchangeBillTableViewCell" owner:self options:nil] objectAtIndex:0];

    }
    //    NSLog(@"获取历史记录");
    [cell.name setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    [cell.currentIcon setHidden:YES];
    if(tableView == self.nameList){
        cell.name.text = self.nameArray[[indexPath row]];
        if([cell.name.text isEqualToString:self.allNameBtn.titleLabel.text]){
            [cell.name setTextColor:[UIColor colorWithRed:251.0/255.0 green:173.0/255.0 blue:20.0/255.0 alpha:1.0]];
            [cell.currentIcon setHidden:NO];
        }
    }
    
    if(tableView == self.typeList){
        cell.name.text = self.typeArray[[indexPath row]];
        if([cell.name.text isEqualToString:self.allTypeBtn.titleLabel.text]){
            [cell.name setTextColor:[UIColor colorWithRed:251.0/255.0 green:173.0/255.0 blue:20.0/255.0 alpha:1.0]];
            [cell.currentIcon setHidden:NO];
        }
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExchangeBillTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell){
        NSString* name = cell.name.text;
        if(tableView == self.nameList){
            [self.allNameBtn setTitle:name forState:UIControlStateNormal];
            
        }
        
        if(tableView == self.typeList){
            [self.allTypeBtn setTitle:name forState:UIControlStateNormal];
        }
        
        [tableView setHidden:YES];
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

@end
