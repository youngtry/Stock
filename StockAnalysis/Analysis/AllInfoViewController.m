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
#import "AnaysisSearchViewController.h"
#import "HttpRequest.h"
@interface AllInfoViewController (){
    NSMutableArray* chinaTitles;
    NSMutableArray* globalTitles;
}

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
    chinaTitles = [[NSMutableArray alloc] init];
    globalTitles = [[NSMutableArray alloc] init];
    
    
    

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
    
    UIBarButtonItem* searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Shape.png"] style:UIBarButtonItemStyleDone target:self action:@selector(searchStcoks)];
    self.navigationItem.rightBarButtonItem = searchBtn;

    
    //每页vc
    _scrollContent=[[AITabContentView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_scrollContent];
    
    [_scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_scrollTitle.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    NSDictionary* parameters = @{};
    NSString* url = @"market/assortment";
    
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                if([[data objectForKey:@"data"] objectForKey:@"tabs"]){
                    NSArray* tabs = [[data objectForKey:@"data"] objectForKey:@"tabs"];
                    for (NSDictionary* tab in tabs) {
                        NSString* tabtitle = [tab objectForKey:@"asset"];
                        [chinaTitles addObject:tabtitle];
                    }
                    
                    //默认国内
                    [self changeToInternal];
                }
            }
        }
    }];
    
    NSString* url1 = @"market/global/assortment";
    [[HttpRequest getInstance] getWithURL:url1 parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"data"] objectForKey:@"tabs"]){
                globalTitles = [[data objectForKey:@"data"] objectForKey:@"tabs"];
            }
        }
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController se]
}

-(void)searchStcoks{
    AnaysisSearchViewController* vc = [[AnaysisSearchViewController alloc] initWithNibName:@"AnaysisSearchViewController" bundle:nil];
//    UIViewController *vc = [UIViewController new];
//    vc.title = @"12311";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)changeToInternal{
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[@"自选",@"指数",@"沪深",@"板块",@"港美"];

    for (int i=0; i<titles.count; i++) {
        StockInfoViewController *vc = [[StockInfoViewController alloc] init];
        vc.index = i;
//        [vc setTitle:[NSString stringWithFormat:@"china_%@",chinaTitles[i]]];
        [vc setTitle:titles[i]];
        [vcs addObject:vc];
    }
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollContent updateTab:index];
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}

-(void)changeToGlobal{
    NSMutableArray* vcs = [NSMutableArray new];
    
//    NSArray *titles = @[@"期货一",@"期货二"];
    for (int i=0; i<globalTitles.count; i++) {
        StockInfoViewController *vc = [[StockInfoViewController alloc] init];
        [vc setTitle:[NSString stringWithFormat:@"global_%@",globalTitles[i]]];
        [vcs addObject:vc];
    }
    [_scrollTitle configParameter:horizontal viewArr:globalTitles tabWidth:kScreenWidth/globalTitles.count tabHeight:42 index:0 block:^(NSInteger index) {
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
