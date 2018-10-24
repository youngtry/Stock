//
//  BankCodeViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/14.
//  Copyright © 2018年 try. All rights reserved.
//

#import "BankCodeViewController.h"
#import "BankCodeTableViewCell.h"

@interface BankCodeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    //代码字典
    NSDictionary *sortedNameDict; //代码字典
    
    NSArray *indexArray;
}
@property (weak, nonatomic) IBOutlet UITableView *bankList;

@end

@implementation BankCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"银行列表";
    
    self.bankList.delegate = self;
    self.bankList.dataSource = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankSortedChnames" ofType:@"plist"];
    
    sortedNameDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    indexArray = [[NSArray alloc] initWithArray:[[sortedNameDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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

#pragma mark - UITableView
//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.bankList) {
        return [sortedNameDict allKeys].count;
    }else{
        return 1;
    }
}
//row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [sortedNameDict objectForKey:[indexArray objectAtIndex:section]];
    return array.count;
}
//height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
//初始化cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankCodeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BankCodeTableViewCell" owner:self options:nil] objectAtIndex:0];;
    }
    //初始化cell数据!
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(indexArray.count>section && sortedNameDict.count>row){
        cell.name.text = [[sortedNameDict objectForKey:[indexArray objectAtIndex:section]] objectAtIndex:row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    }
    
    
    return cell;
}
//indexTitle
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.bankList) {
        return indexArray;
    }else{
        return nil;
    }
}
//
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView == self.bankList) {
        return index;
    }else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.bankList) {
        if (section == 0) {
            return 0;
        }
        return 30;
    }else {
        return 0;
    }
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [indexArray objectAtIndex:section];
}

#pragma mark - 选择银行代码
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BankCodeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (self.returnbankCodeBlock != nil) {
        self.returnbankCodeBlock(cell.name.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 代理传值
-(void)toReturnCountryCode:(returnBankCodeBlock)block{
    self.returnbankCodeBlock = block;
}


@end
