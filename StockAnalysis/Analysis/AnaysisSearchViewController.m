//
//  AnaysisSearchViewController.m
//  StockAnalysis
//
//  Created by try on 2018/7/16.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AnaysisSearchViewController.h"
#import "AITabScrollview.h"
#import "AITabContentView.h"
#import "Masonry.h"
#import "SearchTableViewController.h"

@interface AnaysisSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>{
    //搜索
    UISearchController *searchController;
    NSMutableArray *searchResultValuesArray;
    //代码字典
    NSDictionary *sortedNameDict; //全部字典
    
    NSArray *indexArray;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;

@end

@implementation AnaysisSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    //标题滑动
    _scrollTitle=[[AITabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_scrollTitle];
    [_scrollTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
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
    
    [self changeToTrade];
    
    
//    self.searchBar.delegate = self;
    self.searchBar.hidden = YES;
    searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    searchController.delegate = self;
    searchController.searchResultsUpdater= self;
    
    //搜索时，背景变暗色
    searchController.dimsBackgroundDuringPresentation = YES;
    //搜索时，背景变模糊
    if (@available(iOS 9.1, *)) {
        searchController.obscuresBackgroundDuringPresentation = YES;
    } else {
        // Fallback on earlier versions
    }
    //隐藏导航栏
//    searchController.hidesNavigationBarDuringPresentation = YES;
    searchController.definesPresentationContext = YES;

    
//    [self.navigationController.navigationBar setTranslucent:NO];
    searchController.searchBar.frame = CGRectMake(searchController.searchBar.frame.origin.x, self.searchBar.frame.origin.y, searchController.searchBar.frame.size.width, self.searchBar.frame.size.height);

    
    [self.view addSubview:searchController.searchBar];
//    searchController = [[UISearchController alloc] initWithSearchBar:_searchBar contentsController:self];
//    [searchController setDelegate:self];
//    searchController.searchResultsDataSource = self;
//    searchController.searchResultsUpdater = self;
    
    sortedNameDict = @{@"a":@(1),
                       @"b":@(1),
                       @"c":@(1),
                       @"d":@(1),
                       };
    
    indexArray = [[NSArray alloc] initWithArray:[[sortedNameDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}


-(void)changeToTrade{
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[@"期货交易",@"商户交易"];
    
    for (int i=0; i<titles.count; i++) {
        SearchTableViewController *vc = [[SearchTableViewController alloc] init];
//        vc.index = i;
        [vcs addObject:vc];
//        vc.tableView.tableHeaderView = searchController.searchBar;
        
    }
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollContent updateTab:index];
    }];
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}

#pragma mark - UISearchControllerDelegate代理

//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [searchController.searchBar text];
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
//    NSLog(@"searchString = %@",searchString);
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
