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
#import "SearchTableViewCell.h"
#import "SearchData.h"
#import "HttpRequest.h"
#import "StockLittleViewController.h"

@interface AnaysisSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    //搜索
    UISearchController *searchController;
    NSMutableArray *searchResultValuesArray;
    //代码字典
    NSDictionary *sortedNameDict; //全部字典
    
    NSArray *indexArray;
    
    NSMutableArray* showList;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UITableView *histroyList;

@property(nonatomic,strong) AITabScrollview *scrollTitle;
@property(nonatomic,strong) AITabContentView*scrollContent;

@end

@implementation AnaysisSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"搜索";
    // Do any additional setup after loading the view from its nib.

    [self.searchBar removeFromSuperview];
    self.navigationItem.titleView = self.searchBar;
//    self.searchBar.enablesReturnKeyAutomatically = YES;
    self.view.top = kNaviHeight;
//    self.view.backgroundColor = [UIColor redColor];
    
    showList = [[NSMutableArray alloc] init];
    
    if([SearchData getInstance].searchHistoryList.count>0){
        [self changeToSearchHistroy];
    }else{
        [self changeToTrade];
    }
    
//    [self changeToTrade];
//    [self changeToSearchHistroy];
    
    self.searchBar.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[SearchData getInstance].searchList removeAllObjects];
    [[SearchData getInstance].specialList removeAllObjects];
    
    NSDictionary* parameters = @{@"page":@"1",
                                 @"page_limit":@"10",
                                 @"order_by":@"price"
                                 };
    NSString* url = @"market/follow/list";
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSDictionary* itemData = [data objectForKey:@"data"];
                if(itemData.count>0){
                    NSArray* item = [itemData objectForKey:@"items"];
                    if(item.count>0){
                        for (int i=0; i<item.count; i++) {
                            NSDictionary* info = item[i];
//                            NSLog(@"i= %d,info = %@",i,info);
                            [[SearchData getInstance] addSpecail:info];
                        }
                        if([_historyView isHidden]){
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSearchList" object:nil];
                        }else{
                            [self addDataToShowList];
                        }
                        //                        [[SearchData getInstance] addData];
                        
                    }
                }
            }
        }
    }];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (IBAction)clickClearHistroy:(id)sender {
    [[SearchData getInstance] clearHistory];
    [self changeToTrade];
}

-(void)addDataToShowList{
    
    [showList removeAllObjects];
    BOOL isshop = NO;
    for(int i=0;i<[SearchData getInstance].searchList.count;i++){
        NSDictionary* info = [SearchData getInstance].searchList[i];
        if(![self isRepeatInShowList:info]){
            [showList addObject:info];
            if([info objectForKey:@"asset"]){
                //是商户搜索
                isshop = YES;
            }
        }
    }
    
    if(!isshop){
        NSLog(@"关注列表有：%@",[SearchData getInstance].specialList);
        for(int i=0;i<[SearchData getInstance].specialList.count;i++){
            NSDictionary* info = [SearchData getInstance].specialList[i];
            if(![self isRepeatInShowList:info]){
                [showList addObject:info];
            }
        }
    }
    
    for(int i=0;i<[SearchData getInstance].searchHistoryList.count;i++){
        NSDictionary* info = [SearchData getInstance].searchHistoryList[i];
        if(![self isRepeatInShowList:info]){
            [showList addObject:info];
        }
    }
    
    [_histroyList reloadData];
}

-(BOOL)isRepeatInShowList:(NSDictionary*)info{
    
    for(int i=0;i<showList.count;i++){
        NSDictionary* data = showList[i];
        if([data objectForKey:@"asset"]){
            if([[data objectForKey:@"asset"] isEqualToString:[info objectForKey:@"asset"]]){
                return YES;
            }
        }else{
            if([[data objectForKey:@"market"] isEqualToString:[info objectForKey:@"market"]]){
                return YES;
            }
        }
        
    }
    
    return NO;
}

-(void)changeToSearchHistroy{
    _historyView.hidden = NO;
    
    [self addDataToShowList];
    
    _histroyList.dataSource = self;
    _histroyList.delegate = self;
    
    
}


-(void)changeToTrade{
    
    _historyView.hidden = YES;
    
    //标题滑动
    _scrollTitle=[[AITabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_scrollTitle];
    [_scrollTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(@20);
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
    
    sortedNameDict = @{@"a":@(1),
                       @"b":@(1),
                       @"c":@(1),
                       @"d":@(1),
                       };
    
    indexArray = [[NSArray alloc] initWithArray:[[sortedNameDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }]];
    
    NSMutableArray* vcs = [NSMutableArray new];
    NSArray *titles = @[@"期货交易",@"商户交易"];
    
    for (int i=0; i<titles.count; i++) {
        SearchTableViewController *vc = [[SearchTableViewController alloc] init];
        [vc setTitle:[NSString stringWithFormat:@"%d",i]];
        [vcs addObject:vc];
        
    }
    [_scrollTitle configParameter:horizontal viewArr:titles tabWidth:kScreenWidth/titles.count tabHeight:42 index:0 block:^(NSInteger index) {
        [_scrollContent updateTab:index];
    }];
    
    [_scrollContent configParam:vcs Index:0 block:^(NSInteger index) {
        [_scrollTitle updateTagLine:index];
    }];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchText = %@",searchText);
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"endSearch");
    
    NSLog(@"当前是；%ld",_scrollTitle.tagIndex );
    
    if(_scrollTitle.tagIndex == 0 || ![_historyView isHidden]){
        NSDictionary* parameters = @{@"market":searchBar.text};
        NSString* url = @"market/search";
        [HUDUtil showHudViewInSuperView:self.view withMessage:@"正在搜索"];
        [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
            [HUDUtil hideHudView];
            if(success){
                if([[data objectForKey:@"ret"] intValue] == 1){
                    
                    NSDictionary* market = [data objectForKey:@"data"];
                    
                    if(market.count>0){
                        NSArray* result = [market objectForKey:@"market"];
                        [[SearchData getInstance].searchList removeAllObjects];
                        NSLog(@"搜索结果：%@,%@",result,data);
                        if(result.count >0){
                            
                            for (int i=0; i<result.count; i++) {
                                NSDictionary* info = result[i];
//                                NSLog(@"i= %d,info = %@",i,info);
                                [[SearchData getInstance].searchList addObject:info];
                                
                            }
                        }
                        if([_historyView isHidden]){
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSearchList" object:nil];
                        }else{
                            [self addDataToShowList];
                        }
                    }
                }
            }
        }];
    }else{
        [HUDUtil showHudViewInSuperView:self.view withMessage:@"正在搜索"];
        NSDictionary* parameters = @{@"asset":searchBar.text};
        NSString* url = @"market/shop/search";
        [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
            [HUDUtil hideHudView];
            if(success){
                if([[data objectForKey:@"ret"] intValue] == 1){
                    NSDictionary* market = [data objectForKey:@"data"];
                    
                    if(market.count>0){
                        NSArray* result = [market objectForKey:@"assets"];
                        //
                        [[SearchData getInstance].searchList removeAllObjects];
                        NSLog(@"搜索结果：%@,%@",result,data);
                        if(result.count >0){
                            
                            for (int i=0; i<result.count; i++) {
                                NSDictionary* info = result[i];
//                                NSLog(@"i= %d,info = %@",i,info);
                                [[SearchData getInstance].searchList addObject:info];
                                
                            }
                        }
                        
                        if([_historyView isHidden]){
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSearchList" object:nil];
                        }
                    }
                }
            }
        }];
    }
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarSearchButtonClicked");
//    self.searchBar.keyboardAppearance
    [self.searchBar resignFirstResponder];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return showList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
//    NSLog(@"获取历史记录");
    NSDictionary* data = showList[indexPath.row];

    if([data objectForKey:@"asset"]){
        [cell setName:[data objectForKey:@"name"]];
        [cell setIfShop:YES];
    }else{
        [cell setName:[data objectForKey:@"market"]];
        [cell setIfShop:NO];
        if([self isCellLike:data]){
            //关注
            [cell setIfLike:YES];
        }else{
            [cell setIfLike:NO];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell){
        NSString* name = [cell getName];
        NSDictionary* data = [self getShowDataWithName:name];
        if(data){
            [[SearchData getInstance] addhistory:data];
//            [self.navigationController setBackgroundColor:[UIColor blackColor]];
            
            StockLittleViewController* vc = [[StockLittleViewController alloc] initWithNibName:@"StockLittleViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = name;
//            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

-(NSDictionary*)getShowDataWithName:(NSString*)name{
    for(int i=0;i<showList.count;i++){
        NSDictionary* data = showList[i];
        if([data objectForKey:@"asset"]){
            if([[data objectForKey:@"name"] isEqualToString:name]){
                return data;
            }
        }else if([data objectForKey:@"market"]){
            if([[data objectForKey:@"market"] isEqualToString:name]){
                return data;
            }
        }
    }
    return nil;
}

-(BOOL)isCellLike:(NSDictionary*)info{
    for(int i=0;i<[[SearchData getInstance] getSpecail].count;i++){
        NSDictionary* data = [[SearchData getInstance] getSpecail][i];
        if([[data objectForKey:@"market"] isEqualToString:[info objectForKey:@"market"]]){
            return YES;
        }
    }
    
    return NO;
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
