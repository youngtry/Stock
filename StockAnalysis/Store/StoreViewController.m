//
//  StoreViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "StoreViewController.h"
#import "AITabScrollview.h"
#import "AITabContentView.h"
#import "Masonry.h"
#import "StorePurchaseViewController.h"
#import "StoreUnitViewController.h"
#import "AddTadeViewController.h"
#import "OrderViewController.h"
#import "StockListViewController.h"
@interface StoreViewController ()
@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;

@property(nonatomic,strong) UIButton* addBtn;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =  Localize(@"Store");
    
    [self addTopView];
    
    //标题滑动
    [self scrollTitle];
    
    //每页vc
    [self scrollContent];
    
    [self.view addSubview:self.addBtn];
    
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[Localize(@"Buy"),Localize(@"Sell"),@"交易单",@"订单"];
    {
        StorePurchaseViewController *vc1 = [StorePurchaseViewController new];
        vc1.title = Localize(@"Buy");
        [vcs addObject:vc1];
        
        StorePurchaseViewController *vc2 = [StorePurchaseViewController new];
        vc2.title = Localize(@"Sell");
        [vcs addObject:vc2];
        
        StorePurchaseViewController*vc3 = [StorePurchaseViewController new];
        vc3.title = @"交易单";
        [vcs addObject:vc3];
        
//        StorePurchaseViewController*vc4 = [StorePurchaseViewController new];
//        vc4.title = @"订单";
//        [vcs addObject:vc4];
        
    }
    
    WeakSelf(weakSelf)
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        if(index==3){
            //订单
            OrderViewController *vc = [OrderViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            return ;
        }
        [_scrollContent updateTab:index];
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
    
    UIBarButtonItem* leftbtn = [[UIBarButtonItem alloc] initWithTitle:@"CNY" style:UIBarButtonItemStyleDone target:self action:@selector(switchUnit)];
    self.navigationItem.leftBarButtonItem = leftbtn;
    [leftbtn setTintColor:kColorRGBA(255, 255, 255, 0.65)];
}

-(UIButton*)addBtn{
    if(nil == _addBtn){
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"addBtn.png"] forState:UIControlStateNormal];
        [_addBtn setFrame:CGRectMake(self.view.width-60, self.view.height-180, 50, 50)];
        [_addBtn addTarget:self action:@selector(addTrade) forControlEvents:UIControlEventTouchUpInside];
        
//        NSLog(@"width = %f,height = %f,%f,%f",self.view.width,self.view.height,kScreenWidth,kScreenHeight);
    }
    
    return _addBtn;
}


-(void)addTrade{
    AddTadeViewController* vc = [[AddTadeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)switchUnit{
    StoreUnitViewController* vc = [[StoreUnitViewController alloc] initWithNibName:@"StoreUnitViewController" bundle:nil];
    [vc setTitle:self.navigationItem.leftBarButtonItem.title];
    [vc toReturnUnit:^(NSString *unit) {
        [self.navigationItem.leftBarButtonItem setTitle:unit];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTopView{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
    header.backgroundColor = kColor(245, 245, 245);
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [header addSubview:v];
    v.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16,16, 160, 20)];
    [btn setTitle:[NSString stringWithFormat:@"%@/%@",Localize(@"CNY"),Localize(@"USD")] forState:UIControlStateNormal];
    [btn setTitleColor:kColor(0, 0, 0) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.size.width-10, 0, btn.imageView.size.width+10)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width+10, 0, -btn.titleLabel.bounds.size.width-10)];
    [btn addTarget:self action:@selector(showStockList) forControlEvents:UIControlEventTouchUpInside];
//    btn.centerY = v.centerY;
    [v addSubview:btn];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 70, 15)];
    lab1.font = kTextFont(18);
    lab1.textColor = kColor(0,0,0);
    lab1.text = @"￥6.34";
    [v addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 30, 12)];
    lab2.font = kTextFont(15);
    lab2.textColor = kColorRGBA(0,0,0,0.64);
    lab2.text = @"0%";
    [v addSubview:lab2];
    
    lab2.right = kScreenWidth-16;
    lab1.right = lab2.left - 5;
    
    [self.view addSubview:header];
}

-(void)showStockList{
    StockListViewController* vc = [[StockListViewController alloc] initWithNibName:@"StockListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


-(AITabScrollview*)scrollTitle{
    if(!_scrollTitle){
        _scrollTitle=[[AITabScrollview alloc]initWithFrame:CGRectMake(0, 58, kScreenWidth, 42)];
        [self.view addSubview:_scrollTitle];
        [_scrollTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@42);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(58);
        }];
    }
    return _scrollTitle;
}

-(AITabContentView*)scrollContent{
    if(!_scrollContent){
        _scrollContent=[[AITabContentView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_scrollContent];
        [_scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(_scrollTitle.mas_bottom);
            make.bottom.equalTo(self.view);
        }];
    }
    return _scrollContent;
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
