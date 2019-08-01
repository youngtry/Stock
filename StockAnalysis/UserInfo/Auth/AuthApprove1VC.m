//
//  AuthApproveLevelOneViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/7/6.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AuthApprove1VC.h"
#import "AuthCountryCodeController.h"

@interface AuthApprove1VC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AuthCountryCodeControllerDelegate>
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)UILabel* countryName;
@property(nonatomic,strong)UITextField* fieldName;
@property(nonatomic,strong)UITextField* fieldNum;

@property(nonatomic,strong)UIButton *commitBtn;
@property(nonatomic,strong)UIButton *choseCountryBtn;

@end

@implementation AuthApprove1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = Localize(@"Level_1");
    [self.view setBackgroundColor:kColor(245, 245, 245)];
    
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    [topView setBackgroundColor:kColor(253, 250, 243)];
    UITextView* tips = [[UITextView alloc] initWithFrame:CGRectMake(kScreenWidth*.025, 0, kScreenWidth*0.95, 55)];
    tips.text = Localize(@"Level1_Tip");
    [topView addSubview:tips];
    [tips setBackgroundColor:[UIColor clearColor]];
    [tips setFont:[UIFont systemFontOfSize:12]];
    [tips setTextColor:kColor(235, 181, 50)];
    
    [self.view addSubview:topView];
    
    [self.view addSubview:self.table];
    [self.table setBackgroundColor:[UIColor clearColor]];
    
//    self.countryName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.8, 35)];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Right") style:UIBarButtonItemStylePlain target:self action:@selector(onRightNavClick)];
    self.navigationItem.rightBarButtonItem = right;
    
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

-(UIButton*)choseCountryBtn{
    if(!_choseCountryBtn){
        _choseCountryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_choseCountryBtn setFrame:CGRectMake(0, 0, 100, 35)];
        [_choseCountryBtn setTitle:Localize(@"China") forState:UIControlStateNormal];
//        [_choseCountryBtn.titleLabel setTextColor:[UIColor blackColor]];
        [_choseCountryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_choseCountryBtn addTarget:self action:@selector(choseCountry) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choseCountryBtn;
}

-(UITextField*)fieldNum{
    if(!_fieldNum){
        _fieldNum = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
        _fieldNum.placeholder = Localize(@"Input_ID_Num");
        [_fieldNum addTarget:self action:@selector(numTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _fieldNum;
}
-(UITextField*)fieldName{
    if(!_fieldName){
        _fieldName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
        _fieldName.placeholder = Localize(@"Input_Real_Name");
        [_fieldName addTarget:self action:@selector(nameTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _fieldName;
}

-(UIButton*)commitBtn{
    if(!_commitBtn){
        _commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth-32, 50)];
        [_commitBtn setTitle:Localize(@"Up") forState:UIControlStateNormal];
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

-(void)choseCountry{
    AuthCountryCodeController* countrycodeVC = [[AuthCountryCodeController alloc] init];
    countrycodeVC.deleagete = self;
    [countrycodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        NSLog(@"countryCodeStr = %@",countryCodeStr);
        //            countryCodeStr = [countryCodeStr substringFromIndex:[countryCodeStr rangeOfString:@"+"].location];
        NSLog(@"countryCodeStr = %@",countryCodeStr);
        //        [self.countryCodeButton.titleLabel setText:countryCodeStr];
        [self.choseCountryBtn setTitle:countryCodeStr forState:UIControlStateNormal];
    }];
    
    [self.navigationController pushViewController:countrycodeVC animated:YES];
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
        cell.textLabel.text = Localize(@"National");
        [cell.contentView addSubview:self.countryName];
//        self.countryName.text = @"中国大陆";
//        [self.countryName setTextAlignment:NSTextAlignmentRight];
        [cell.contentView addSubview:self.choseCountryBtn];
        self.choseCountryBtn.left = 120;
        self.choseCountryBtn.centerY = cell.contentView.centerY;
        self.choseCountryBtn.width = kScreenWidth-120;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (row == 1){
        cell.textLabel.text = Localize(@"Name");
        [cell.contentView addSubview:self.fieldName];
        self.fieldName.left = 120;
        self.fieldName.centerY = cell.contentView.centerY;
        self.fieldName.width = kScreenWidth-120;
    }else if (row == 2){
        cell.textLabel.text = Localize(@"ID_Num");
        [cell.contentView addSubview:self.fieldNum];
        self.fieldNum.left = 120;
        self.fieldNum.centerY = cell.contentView.centerY;
        self.fieldNum.width = kScreenWidth-120;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row == 0){
        //选择国籍
        
    }
}

-(void)clickCommit:(id)sender{
    NSString* url = @"account/verity1";
    NSDictionary* params = @{@"username":self.fieldName.text,
                             @"id_card":self.fieldNum.text
                             };
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:weakSelf.navigationController.view withMessage:Localize(@"ID_Verify_Succ")];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [HUDUtil showHudViewTipInSuperView:weakSelf.navigationController.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
//
    
}

//1.代理传值
#pragma mark - XWCountryCodeControllerDelegate
-(void)returnCountryCode:(NSString *)countryCode{
    
    countryCode = [countryCode substringFromIndex:[countryCode rangeOfString:@"+"].location];
    NSLog(@"countryCode = %@",countryCode);
    //    [self.countryCodeButton.titleLabel setText:countryCode];
    //    [self.countryCodeButton setTitle:countryCode forState:UIControlStateNormal];
    [self.choseCountryBtn setTitle:countryCode forState:UIControlStateNormal];
}
@end
