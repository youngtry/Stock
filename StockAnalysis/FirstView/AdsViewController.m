//
//  AdsViewController.m
//  StockAnalysis
//
//  Created by try on 2018/9/5.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AdsViewController.h"
#import "AdsTableViewCell.h"
@interface AdsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *adList;

@property(nonatomic,strong)NSMutableArray* adData;

@end

@implementation AdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"ZEDA 活动";
    
    _adList.delegate = self;
    _adList.dataSource = self;
    self.adData = [NSMutableArray new];
    
    self.adList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString* url = @"news/ads";
    NSDictionary* params = @{@"page":@(1),
                             @"page_limit":@(10)
                             };
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] getWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [self.adData removeAllObjects];
                NSArray* ads = [[data objectForKey:@"data"] objectForKey:@"ads"];
                self.adData = [[NSMutableArray alloc] initWithArray:ads];
                [self.adList reloadData];
            }else{
                
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                
            }
        }
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.adData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(nil == cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AdsTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSDictionary* info  = self.adData[indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:[info objectForKey:@"img"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    cell.adImageView.image = image;
    
    return cell;
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
