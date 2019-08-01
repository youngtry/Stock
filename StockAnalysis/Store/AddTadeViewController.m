//
//  AddTadeViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AddTadeViewController.h"
#import "AITabScrollview.h"
#import "AITabContentView.h"
#import "Masonry.h"
#import "TradeDetailViewController.h"

@interface AddTadeViewController ()
@property(nonatomic,strong)UIView* titleView;
@property(nonatomic,strong)UILabel* titleName;
@property(nonatomic,strong)UILabel* titlePrice;
@property(nonatomic,strong)UILabel* titleDisPrice;

@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;

@end

@implementation AddTadeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"Distribute_Trade");
    [self.view setBackgroundColor:kColor(245, 245, 249)];
    
    [self.view addSubview:self.titleView];
    
    //标题滑动
    [self scrollTitle];
    
    //每页vc
    [self scrollContent];
    
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[Localize(@"Buy"),Localize(@"Sell")];
    {
        TradeDetailViewController *vc1 = [[TradeDetailViewController alloc] initWithNibName:@"TradeDetailViewController" bundle:nil];
        vc1.title = Localize(@"Buy");
        [vcs addObject:vc1];

        TradeDetailViewController *vc2 = [[TradeDetailViewController alloc] initWithNibName:@"TradeDetailViewController" bundle:nil];
        vc2.title = Localize(@"Sell");
        [vcs addObject:vc2];
//
//        StorePurchaseViewController*vc3 = [StorePurchaseViewController new];
//        vc3.title = @"交易单";
//        [vcs addObject:vc3];
//
//        StorePurchaseViewController*vc4 = [StorePurchaseViewController new];
//        vc4.title = @"订单";
//        [vcs addObject:vc4];
        
    }
    
    //    WeakSelf(weakSelf)
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollContent updateTab:index];
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIView*)titleView{
    if(nil == _titleView){
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
//        _titleView.layer.borderWidth = 0.5;
        [_titleView setBackgroundColor:[UIColor whiteColor]];
        [_titleView addSubview:self.titleName];
        [_titleView addSubview:self.titlePrice];
        [_titleView addSubview:self.titleDisPrice];
    }
    
    return _titleView;
}

-(UILabel*)titleName{
    if(nil == _titleName){
        _titleName =  [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth* 0.2, 50)];
        _titleName.text = [NSString stringWithFormat:@"%@1",Localize(@"Forword")];
        [_titleName setFont:[UIFont systemFontOfSize:22]];
    }
    
    return _titleName;
}

-(UILabel*)titlePrice{
    if(nil == _titlePrice){
        _titlePrice =  [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth* 0.58, 0, kScreenWidth* 0.17, 50)];
        _titlePrice.text = @"¥6.34";
        [_titlePrice setTextAlignment:NSTextAlignmentLeft];
        [_titlePrice setFont:[UIFont systemFontOfSize:18]];
        [_titlePrice setTextColor:kColor(236, 102, 95)];
    }
    
    return _titlePrice;
}

-(UILabel*)titleDisPrice{
    if(nil == _titleDisPrice){
        _titleDisPrice =  [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth* 0.75, 0, kScreenWidth* 0.2, 50)];
        _titleDisPrice.text = @"+2.95%";
        [_titleDisPrice setTextAlignment:NSTextAlignmentLeft];
        [_titleDisPrice setFont:[UIFont systemFontOfSize:15]];
        [_titleDisPrice setTextColor:kColor(236, 102, 95)];
    }
    
    return _titleDisPrice;
}

-(AITabScrollview*)scrollTitle{
    if(!_scrollTitle){
        _scrollTitle=[[AITabScrollview alloc]initWithFrame:CGRectMake(0, 62, kScreenWidth, 42)];
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
