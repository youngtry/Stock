//
//  AuthApproveLevelOneViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/7/6.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AuthApprove1VC.h"

@interface AuthApprove1VC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)UITextField* fieldName;
@property(nonatomic,strong)UITextField* fieldNum;

@property(nonatomic,strong)UIButton *commitBtn;
@end

@implementation AuthApprove1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"级别1";
    [self.view setBackgroundColor:kColor(245, 245, 245)];
    
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    [topView setBackgroundColor:kColor(253, 250, 243)];
    UITextView* tips = [[UITextView alloc] initWithFrame:CGRectMake(kScreenWidth*.025, 0, kScreenWidth*0.95, 55)];
    tips.text = @"为了您的资金安全，需验证您的身份才可进行其他操作；认证信 息一经验证不能修改，请务必如实填写。";
    [topView addSubview:tips];
    [tips setBackgroundColor:[UIColor clearColor]];
    [tips setFont:[UIFont systemFontOfSize:12]];
    [tips setTextColor:kColor(235, 181, 50)];
    
    [self.view addSubview:topView];
    
    [self.view addSubview:self.table];
    [self.table setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"权益" style:UIBarButtonItemStylePlain target:self action:@selector(onRightNavClick)];
    self.navigationItem.rightBarButtonItem = right;
    
    
}

-(void)onRightNavClick{
    
}

-(UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, self.view.bounds.size.height-55) style:UITableViewStylePlain];
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
        [_commitBtn setBackgroundImage:[UIImage imageNamed:@"color_blue"] forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:[UIImage imageNamed:@"color_gray"] forState:UIControlStateDisabled];
        [_commitBtn setEnabled:NO];
        _commitBtn.layer.cornerRadius = 25;
        _commitBtn.layer.masksToBounds = YES;
        [_commitBtn addTarget:self action:@selector(clickCommit:) forControlEvents:UIControlEventTouchUpInside];
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
        UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        text.text = @"中国大陆";
        [text setTextAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:text];
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

-(void)clickCommit:(id)sender{
    NSString* url = @"account/verity1";
    NSDictionary* params = @{@"username":self.fieldName.text,
                             @"id_card":self.fieldNum.text
                             };
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"认证成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
//
}
@end
