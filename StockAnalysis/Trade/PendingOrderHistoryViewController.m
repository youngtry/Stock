//
//  PendingOrderHistoryViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/25.
//  Copyright © 2018年 try. All rights reserved.
//

#import "PendingOrderHistoryViewController.h"
#import "PendingOrderTableViewCell.h"
#import "EntryOrderDetailVC.h"
#import "CGXPickerView.h"
@interface PendingOrderHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,CancelDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL isUpdate;
@property(nonatomic,strong)UIView* selectView;
@property(nonatomic,strong)UITextField* startTime;
@property(nonatomic,strong)UITextField* endTime;
@property(nonatomic,strong)NSString* state;
@property(nonatomic,strong)UIView* stateView;
@property(nonatomic,strong)UIButton* allbtn;
@property(nonatomic,strong)UIButton* donebtn;
@property(nonatomic,strong)UIButton* cancelStatusbtn;
@property(nonatomic,strong)UIButton* statusbtn;
@end

@implementation PendingOrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = [NSMutableArray new];
    self.currentPage = 0;
    self.isUpdate = YES;
    self.state = @"done,cancel";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectView];
    [self.stateView setHidden:YES];
    [self.allbtn setHidden:YES];
    [self.donebtn setHidden:YES];;
    [self.cancelStatusbtn setHidden:YES];;
    //header
    [self addHeader];
    
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    self.title = Localize(@"History_Record");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.currentPage = 0;
    self.isUpdate = YES;
    [self.selectView setHidden:YES];
    [self.data removeAllObjects];
    
    
    
    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    if(nil == temp){
        temp = self.navigationController;
    }
    NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [defaultdata boolForKey:@"IsLogin"];
    if(!islogin){
//        [HUDUtil showSystemTipView:temp title:Localize(@"Menu_Title") withContent:Localize(@"Login_Tip")];
        return;
    }
    
    

    
    [self getAllHistory:1];
    
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    [self.data removeAllObjects];
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)test{
    self.startTime.text = @"";
    self.endTime.text = @"";
    [self.selectView setHidden:YES];
}

-(void)test1{
    [self.stateView setHidden:YES];
    [self.allbtn setHidden:YES];
    [self.donebtn setHidden:YES];;
    [self.cancelStatusbtn setHidden:YES];;
}

-(UIView*)stateView{
    if(nil == _stateView){
        _stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_stateView setBackgroundColor:[UIColor blackColor]];
        [_stateView setAlpha:0.3];
        UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test1)];
        [self.stateView addGestureRecognizer:f];
        self.view.userInteractionEnabled = YES;
        
        [self.view addSubview:_stateView];
        _allbtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_allbtn setTitle:Localize(@"All") forState:UIControlStateNormal];
        [_allbtn setFrame:CGRectMake(0, 0, kScreenWidth*0.6, kScreenHeight*0.1)];
        [_allbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_allbtn setBackgroundColor:[UIColor whiteColor]];
        [_allbtn addTarget:self action:@selector(clickAll) forControlEvents:UIControlEventTouchUpInside];
        _allbtn.centerX = kScreenWidth/2;
        _allbtn.centerY = kScreenHeight*0.2;
        [self.view addSubview:_allbtn];
        
        _donebtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_donebtn setTitle:Localize(@"Finished") forState:UIControlStateNormal];
        [_donebtn setFrame:CGRectMake(0, 0, kScreenWidth*0.6, kScreenHeight*0.1)];
        [_donebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_donebtn addTarget:self action:@selector(ClickDone) forControlEvents:UIControlEventTouchUpInside];
        [_donebtn setBackgroundColor:[UIColor whiteColor]];
        _donebtn.centerX = kScreenWidth/2;
        _donebtn.top = _allbtn.bottom;
        [self.view addSubview:_donebtn];
        
        _cancelStatusbtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelStatusbtn setTitle:Localize(@"Canceled") forState:UIControlStateNormal];
        [_cancelStatusbtn setFrame:CGRectMake(0, 0, kScreenWidth*0.6, kScreenHeight*0.1)];
        [_cancelStatusbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelStatusbtn setBackgroundColor:[UIColor whiteColor]];
        [_cancelStatusbtn addTarget:self action:@selector(ClickCancelStaus) forControlEvents:UIControlEventTouchUpInside];
        _cancelStatusbtn.centerX = kScreenWidth/2;
        _cancelStatusbtn.top = _donebtn.bottom;
        [self.view addSubview:_cancelStatusbtn];
        

    }
    return _stateView;
}

-(UIView*)selectView{
    if(nil == _selectView){
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 58, kScreenWidth, 100)];
        [_selectView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel* status = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
        status.text = Localize(@"State");
        [status setFont:[UIFont systemFontOfSize:13]];
        status.left = _selectView.left+10;
        status.centerY = 5;
        [_selectView addSubview:status];
        
        _statusbtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_statusbtn setTitle:Localize(@"All_Menu") forState:UIControlStateNormal];
        [_statusbtn setFrame:CGRectMake(0, 0, 80, 10)];
        [_statusbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_statusbtn addTarget:self action:@selector(clickAllState) forControlEvents:UIControlEventTouchUpInside];
        _statusbtn.left = status.right+10;
        _statusbtn.centerY = status.centerY;
        [_selectView addSubview:_statusbtn];
        
        UILabel* time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
        time.text = Localize(@"Time");
        [time setFont:[UIFont systemFontOfSize:13]];
        time.left = _selectView.left+10;
        time.top = status.bottom+15;
        [_selectView addSubview:time];
        
        self.startTime.left = time.right + 10;
        self.startTime.centerY = time.centerY;
        [_selectView addSubview:self.startTime];
        
        UIImageView* icon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhangdan"]];
        [icon1 setFrame:CGRectMake(0, 0, 10, 10)];
        icon1.right = _startTime.right-5;
        icon1.centerY = _startTime.centerY;
        [_selectView addSubview:icon1];
        
        UILabel* zhi = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
        zhi.text = Localize(@"To");
        [zhi setFont:[UIFont systemFontOfSize:13]];
        zhi.left = _startTime.right+10;
        zhi.centerY = _startTime.centerY;
        [_selectView addSubview:zhi];
        
        self.endTime.left = zhi.right + 5;
        self.endTime.centerY = zhi.centerY;
        [_selectView addSubview:self.endTime];
        
        UIImageView* icon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhangdan"]];
        [icon2 setFrame:CGRectMake(0, 0, 10, 10)];
        icon2.right = _endTime.right-5;
        icon2.centerY = _endTime.centerY;
        [_selectView addSubview:icon2];
        
        UIButton* cancelbtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelbtn setFrame:CGRectMake(0, 0, kScreenWidth*0.35, 25)];
//        [cancelbtn set]
        [cancelbtn setTitle:Localize(@"Menu_Cancel") forState:UIControlStateNormal];
        [cancelbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelbtn setBackgroundColor:[UIColor lightGrayColor]];
        [cancelbtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        cancelbtn.right = _selectView.centerX-10;
        cancelbtn.top = _startTime.bottom+20;
        [_selectView addSubview:cancelbtn];
        //设置圆角的半径
        [cancelbtn.layer setCornerRadius:6];
        //切割超出圆角范围的子视图
        cancelbtn.layer.masksToBounds = YES;
        //设置边框的颜色
//        [cancelbtn.layer setBorderColor:[UIColor blackColor].CGColor];
        //设置边框的粗细
//        [cancelbtn.layer setBorderWidth:0.5];
        
        UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [okBtn setFrame:CGRectMake(0, 0, kScreenWidth*0.35, 25)];
        [okBtn setTitle:Localize(@"Menu_Sure") forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okBtn setBackgroundColor:kColor(87, 144, 191)];
        [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
        okBtn.left = _selectView.centerX+10;
        okBtn.top = _startTime.bottom+20;
        [_selectView addSubview:okBtn];
        //设置圆角的半径
        [okBtn.layer setCornerRadius:6];
        //切割超出圆角范围的子视图
        okBtn.layer.masksToBounds = YES;
        //设置边框的颜色
//        [okBtn.layer setBorderColor:[UIColor blackColor].CGColor];
        //设置边框的粗细
//        [okBtn.layer setBorderWidth:0.5];
        
    }
    return _selectView;
}

-(UITextField*)startTime{
    if(nil == _startTime){
        _startTime = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.3, 15)];
        [_startTime setBorderStyle:UITextBorderStyleLine];
        _startTime.delegate = self;
        [_startTime setFont:[UIFont systemFontOfSize:12]];
    }
    return _startTime;
}

-(UITextField*)endTime{
    if(nil == _endTime){
        _endTime = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.3, 15)];
        [_endTime setBorderStyle:UITextBorderStyleLine];
        _endTime.delegate = self;
        [_endTime setFont:[UIFont systemFontOfSize:12]];
        
        
        
    }
    return _endTime;
}

-(void)sendCancelNotice:(BOOL)success withReason:(NSString *)msg{
    if(success){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:Localize(@"Cancel_Succ")];
        self.currentPage = 0;
        self.isUpdate = YES;
        [self.data removeAllObjects];
        [self getAllHistory:1];
    }else{
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:msg];
    }
}

-(void)getAllHistory:(NSInteger)page{
//    UINavigationController* temp = self.parentViewController.view.selfViewController.navigationController;
    self.currentPage = page;
    
    NSString* start = @"";
    NSString* end = @"";
    if(self.startTime.text.length>0){
        self.startTime.text = [NSString stringWithFormat:@"%@ 00:00:00",self.startTime.text];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:self.startTime.text];
        NSTimeInterval timeInterval = [date timeIntervalSince1970]; // *1000,是精确到毫秒；这里是精确到秒;
        NSString *result = [NSString stringWithFormat:@"%.0f",timeInterval];
        start = result;
        NSLog(@"%@",result);
    }
    
    if(self.endTime.text.length>0){
        self.endTime.text = [NSString stringWithFormat:@"%@ 00:00:00",self.endTime.text];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:self.endTime.text];
        NSTimeInterval timeInterval = [date timeIntervalSince1970]; // *1000,是精确到毫秒；这里是精确到秒;
        NSString *result = [NSString stringWithFormat:@"%.0f",timeInterval];
        end = result;
        NSLog(@"%@",result);
    }
    
    
    
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"page":@(page),
                             @"page_limit":@(10),
                             @"state":self.state,
                             @"start":start,
                             @"end":end
                             };
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据加载中……"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* trades = [[data objectForKey:@"data"] objectForKey:@"trades"];
                if(trades.count == 0){
                    if(weakSelf.currentPage == 1){
                        [weakSelf.data removeAllObjects];
                        [weakSelf.tableView reloadData];
                    }else{
                        weakSelf.isUpdate = NO;
                        [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:Localize(@"Load_Finish")];
                    }
                    
                }else{
                    [weakSelf.data addObjectsFromArray:trades];
                    [weakSelf.tableView reloadData];
                }
                
//                NSLog(@"data = %@",self.data);
            }else{
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(void)addHeader{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 120, 26)];
    lab.font = kTextBoldFont(26);
    lab.textColor = kColor(0, 0, 0);
    lab.text = Localize(@"History_Pendings");
    [header addSubview:lab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.15, 20)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btn setTitle:Localize(@"ShaiXuan") forState:UIControlStateNormal];
    [btn setTitleColor:kThemeYellow forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Path"] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.size.width, 0, btn.imageView.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
    btn.centerY = lab.centerY;
    btn.right = kScreenWidth - 16;
    [btn addTarget:self action:@selector(clickSelect) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btn];
    self.tableView.tableHeaderView = header;
}

-(void)clickSelect{
    if(self.selectView.hidden){
        [self.selectView setHidden:NO];
    }else{
        self.startTime.text = @"";
        self.endTime.text = @"";
        [self.selectView setHidden:YES];
    }
}

-(void)clickAllState{
    if(self.stateView.hidden){
        [self.stateView setHidden:NO];
        [self.allbtn setHidden:NO];
        [self.donebtn setHidden:NO];;
        [self.cancelStatusbtn setHidden:NO];;
    }else{
        [self.stateView setHidden:YES];
        [self.allbtn setHidden:YES];
        [self.donebtn setHidden:YES];;
        [self.cancelStatusbtn setHidden:YES];;
    }
}

-(void)clickOk{
    [self.data removeAllObjects];
    self.isUpdate = NO;
    [self getAllHistory:1];
    
    [self clickCancel];
    
    
}

-(void)clickAll{
    [_statusbtn setTitle:Localize(@"All_Menu") forState:UIControlStateNormal];
    [self.stateView setHidden:YES];
    [self.allbtn setHidden:YES];
    [self.donebtn setHidden:YES];;
    [self.cancelStatusbtn setHidden:YES];;
    self.state = @"done,cancel";
}

-(void)ClickDone{
    [_statusbtn setTitle:Localize(@"Done_Menu") forState:UIControlStateNormal];
    [self.stateView setHidden:YES];
    [self.allbtn setHidden:YES];
    [self.donebtn setHidden:YES];;
    [self.cancelStatusbtn setHidden:YES];;
    self.state = @"done";
}

-(void)ClickCancelStaus{
    [_statusbtn setTitle:Localize(@"Cancel_Menu") forState:UIControlStateNormal];
    [self.stateView setHidden:YES];
    [self.allbtn setHidden:YES];
    [self.donebtn setHidden:YES];;
    [self.cancelStatusbtn setHidden:YES];;
    self.state = @"cancel";
}

-(void)clickCancel{
    self.startTime.text = @"";
    self.endTime.text = @"";
    [self.selectView setHidden:YES];
}

#pragma mark - UIScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.startTime.text = @"";
    self.endTime.text = @"";
    [self.selectView setHidden:YES];
}
#pragma mark - TableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.data.count;
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PendingOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PendingOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.delegate = self;
    
    if(self.data.count>indexPath.row){
        NSDictionary* data = self.data[indexPath.row];
        
        cell.stockName.text = [data objectForKey:@"market"];
        cell.timeLabel.text = [data objectForKey:@"updated_at"];
        NSString* type = [data objectForKey:@"mode"];
        if([type isEqualToString:@"buy"]){
            cell.typeLabel.text = Localize(@"Buy");
            cell.isBuyIn = YES;
        }else if ([type isEqualToString:@"sell"]){
            cell.typeLabel.text = Localize(@"Sell");
            cell.isBuyIn = NO;
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"%.8lf",[[data objectForKey:@"price"] doubleValue]] ;
        cell.amountLabel.text = [NSString stringWithFormat:@"%.8lf",[[data objectForKey:@"num"] doubleValue]] ;
        cell.realLabel.text = [NSString stringWithFormat:@"%.8lf",[[data objectForKey:@"deal_money"] doubleValue]] ;
        cell.tradeID = [data objectForKey:@"id"];
        [cell.cancelBtn setHidden:YES];
        [cell.stateLabel setHidden:NO];
        cell.stateLabel.text = [data objectForKey:@"state"];
        if([cell.stateLabel.text isEqualToString:@"done"]){
            cell.stateLabel.text = Localize(@"Finished");
            [cell.stateLabel setTextColor:kColor(100, 149, 237)];
        }else if([cell.stateLabel.text isEqualToString:@"cancel"]){
            cell.stateLabel.text = Localize(@"Canceled");
            [cell.stateLabel setTextColor:kColor(106, 106, 106)];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* data = self.data[indexPath.row];
    
    if([[data objectForKey:@"state"] isEqualToString:@"done"]){
        EntryOrderDetailVC *vc = [[EntryOrderDetailVC alloc] initWithNibName:@"EntryOrderDetailVC" bundle:nil];
        UINavigationController *nav = (UINavigationController*)[Util getParentVC:[UINavigationController class] fromView:self.view];
        int stockid = [[data objectForKey:@"id"] intValue];
        NSLog(@"stockid = %d",stockid);
        vc.title = [NSString stringWithFormat:@"%d",stockid];
        [nav pushViewController:vc animated:YES];
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if(!self.isUpdate){
        
        return;
    }
    if(self.isUpdate && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
        [self getAllHistory:self.currentPage+1];
    }
}

-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    [textField resignFirstResponder];
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *nowStr = [fmt stringFromDate:now];
    [CGXPickerView showDatePickerWithTitle:Localize(@"Select_Date") DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:@"1900-01-01 00:00:00" MaxDateStr:nowStr IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
        NSLog(@"%@",selectValue);
        textField.text = selectValue;;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
