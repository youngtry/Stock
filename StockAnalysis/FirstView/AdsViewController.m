//
//  AdsViewController.m
//  StockAnalysis
//
//  Created by try on 2018/9/5.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AdsViewController.h"
#import "AdsTableViewCell.h"
#import "AdContentViewController.h"
@interface AdsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *adList;

@property(nonatomic,strong)NSMutableArray* adData;

@end

@implementation AdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = Localize(@"ZEDA_Act");
    
    _adList.delegate = self;
    _adList.dataSource = self;
    self.adData = [NSMutableArray new];
    
    self.adList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString* url = @"news/ads";
    NSDictionary* params = @{@"page":@(1),
                             @"page_limit":@(10)
                             };
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    WeakSelf(weakSelf);
    [[HttpRequest getInstance] getWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                [weakSelf.adData removeAllObjects];
                NSArray* ads = [[data objectForKey:@"data"] objectForKey:@"ads"];
                weakSelf.adData = [[NSMutableArray alloc] initWithArray:ads];
                [weakSelf.adList reloadData];
            }else{
                
                [HUDUtil showHudViewTipInSuperView:weakSelf.view withMessage:[data objectForKey:@"msg"]];
                
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
    if(self.adData.count>indexPath.row){
        NSDictionary* info  = self.adData[indexPath.row];
        
        NSURL *imageUrl = [NSURL URLWithString:[info objectForKey:@"img"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        cell.adImageView.image = image;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* info  = self.adData[indexPath.row];
    NSString* link = [info objectForKey:@"link"];
    AdContentViewController* vc = [[AdContentViewController alloc] init];
    vc.title = [info objectForKey:@"title"];
    [self.navigationController pushViewController:vc animated:YES];
    vc.block = ^{
        [vc starRequest:link];
    };
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
