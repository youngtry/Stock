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
@interface AllInfoViewController ()

@property(nonatomic,strong)UISegmentedControl* segment;
@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollVCs;

@property(nonatomic,strong) NSMutableArray*titleLabs;
@property(nonatomic,strong) NSMutableArray*contentVCs;
@end

@implementation AllInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabs = [NSMutableArray new];
    _contentVCs = [NSMutableArray new];
    NSArray *titles = @[@"自选",@"指数",@"沪深",@"板块",@"港美"];
    for (int i=0; i<titles.count; i++) {
        NSString *titleStr= titles[i];
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.text=titleStr;
        tab.textColor=[UIColor blackColor];
        [_titleLabs addObject:tab];
        
        int r = (arc4random() % 256) ;
        int g = (arc4random() % 256) ;
        int b = (arc4random() % 256) ;
        
        //TODO 在此定义vc
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = kColor(r, g, b);
        [_contentVCs addObject:vc];
    }
    
    //国内外切换
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"国内",@"国际"]];
    _segment.frame = CGRectMake(0, 0, 200, 28);
    _segment.tintColor = kThemeYellow;
    _segment.selectedSegmentIndex = 0;
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
    [_scrollTitle configParameter:horizontal viewArr:_titleLabs tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollVCs updateTab:index];
    }];
    //每页vc
    _scrollVCs=[[AITabContentView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_scrollVCs];
    
    [_scrollVCs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_scrollTitle.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [_scrollVCs configParam:_contentVCs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
