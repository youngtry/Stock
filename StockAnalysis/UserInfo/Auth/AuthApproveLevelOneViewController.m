//
//  AuthApproveLevelOneViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/7/6.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AuthApproveLevelOneViewController.h"

@interface AuthApproveLevelOneViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)UITextField* fieldName;
@property(nonatomic,strong)UITextField* fieldNum;

@property(nonatomic,strong)UIButton *commitBtn;
@end

@implementation AuthApproveLevelOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"级别1";
    
    [self.view addSubview:self.table];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"权益" style:UIBarButtonItemStylePlain target:self action:@selector(onRightNavClick)];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)onRightNavClick{
    
}

-(UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        [v addSubview:self.commitBtn];
        self.commitBtn.bottom = v.bottom;
        _table.tableFooterView = v;
    }
    return _table;
}

-(UITextField*)fieldNum{
    if(!_fieldNum){
        _fieldNum = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
        _fieldNum.placeholder = @"请输入身份证号码";
        [_fieldNum addTarget:self action:@selector(numTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _fieldNum;
}
-(UITextField*)fieldName{
    if(!_fieldName){
        _fieldName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
        _fieldName.placeholder = @"请输入真实姓名";
        [_fieldNum addTarget:self action:@selector(nameTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _fieldName;
}

-(UIButton*)commitBtn{
    if(!_commitBtn){
        _commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth-32, 50)];
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:[Util imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:[Util imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [_commitBtn setEnabled:NO];
        _commitBtn.layer.cornerRadius = 25;
        _commitBtn.layer.masksToBounds = YES;
    }
    return _commitBtn;
}

-(void)numTextChange:(UITextField*)num{
    if(!IsStrEmpty(self.fieldNum.text) && !IsStrEmpty(self.fieldName.text)){
        [self.commitBtn setEnabled:YES];
    }else{
        [self.commitBtn setEnabled:NO];
    }
}

-(void)nameTextChange:(UITextField*)name{
    if(!IsStrEmpty(self.fieldNum.text) && !IsStrEmpty(self.fieldName.text)){
        [self.commitBtn setEnabled:YES];
    }else{
        [self.commitBtn setEnabled:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id"];
    }
    
    NSInteger row = indexPath.row;
    if(row == 0){
        cell.textLabel.text = @"国籍";
        cell.detailTextLabel.text = @"中国";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (row == 1){
        cell.textLabel.text = @"姓名";
        [cell.contentView addSubview:self.fieldName];
        self.fieldName.left = 120;
        self.fieldName.centerY = cell.contentView.centerY;
        self.fieldName.width = kScreenWidth-120;
    }else if (row == 2){
        cell.textLabel.text = @"身份证号码";
        [cell.contentView addSubview:self.fieldNum];
        self.fieldNum.left = 120;
        self.fieldNum.centerY = cell.contentView.centerY;
        self.fieldNum.width = kScreenWidth-120;
    }
    return cell;
}

@end
