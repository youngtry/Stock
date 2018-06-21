//
//  AllInfoViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/6/20.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AllInfoViewController.h"
#import "AITabScrollview.h"
#import "AITabContentView.h"
#import "Masonry.h"
#import "StockInfoViewController.h"
@interface AllInfoViewController ()

@property(nonatomic,strong)UISegmentedControl* segment;
@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;

//@property(nonatomic,strong) NSMutableArray*titleLabs;
//@property(nonatomic,strong) NSMutableArray*contentVCs;
@end

@implementation AllInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _titleLabs = [NSMutableArray new];
//    _contentVCs = [NSMutableArray new];

    //国内外切换
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"国内",@"全球"]];
    _segment.frame = CGRectMake(0, 0, 200, 28);
    _segment.tintColor = kThemeYellow;
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(changeInternation:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segment;
    
    //标题滑动
    _scrollTitle=[[AITabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_scrollTitle];
    [_scrollTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    //每页vc
    _scrollContent=[[AITabContentView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_scrollContent];
    
    [_scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_scrollTitle.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    //默认国内
    [self changeToInternal];
}

-(void)changeToInternal{
    NSMutableArray* vcs = [NSMutableArray new];
    NSMutableArray* labs = [NSMutableArray new];
    
    NSArray *titles = @[@"自选",@"指数",@"沪深",@"板块",@"港美"];
    for (int i=0; i<titles.count; i++) {
        NSString *titleStr= titles[i];
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.text=titleStr;
        tab.textColor=[UIColor blackColor];
        [labs addObject:tab];
        
        StockInfoViewController *vc = [[StockInfoViewController alloc] init];
        [vcs addObject:vc];
    }
    [_scrollTitle configParameter:horizontal viewArr:labs tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollContent updateTab:index];
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}

-(void)changeToGlobal{
    NSMutableArray* vcs = [NSMutableArray new];
    NSMutableArray* labs = [NSMutableArray new];
    
    NSArray *titles = @[@"期货一",@"期货二"];
    for (int i=0; i<titles.count; i++) {
        NSString *titleStr= titles[i];
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.text=titleStr;
        tab.textColor=[UIColor blackColor];
        [labs addObject:tab];
        
        StockInfoViewController *vc = [[StockInfoViewController alloc] init];
        [vcs addObject:vc];
    }
    [_scrollTitle configParameter:horizontal viewArr:labs tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollContent updateTab:index];
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}

-(void)changeInternation:(UISegmentedControl*)seg{
    if(seg.selectedSegmentIndex==0){
        //国内
        [self changeToInternal];
    }else{
        //国外
        [self changeToGlobal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
