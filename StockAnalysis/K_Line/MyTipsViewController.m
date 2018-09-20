//
//  MyTipsViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/24.
//  Copyright © 2018年 try. All rights reserved.
//

#import "MyTipsViewController.h"
#import "MyTipsTableViewCell.h"

@interface MyTipsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tipsList;

@property (nonatomic,strong) NSMutableArray* myTips;


@end

@implementation MyTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的提醒";
    self.tipsList.delegate = self;
    self.tipsList.dataSource = self;
    self.tipsList.tableFooterView = [UIView new];
    self.myTips = [NSMutableArray new];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    NSString* url = @"market/notice";
    NSDictionary* params = @{@"page":@(1),
                             @"page_limit":@(10),
                             @"state":@""
                             };
    
    [[HttpRequest getInstance] getWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [self.myTips removeAllObjects];
                NSArray* items = [[data objectForKey:@"data"] objectForKey:@"items"];
                for (NSDictionary* item in items) {
                    if([[item objectForKey:@"state"] isEqualToString:@"enable"]){
                        [self.myTips addObject:item];
                    }
                }
                
                [self.tipsList reloadData];
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


#pragma marks ------tableviewdelegate-----

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myTips.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTipsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTipsTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSDictionary* item = self.myTips[indexPath.row];
    cell.name.text = [item objectForKey:@"market"];
    cell.topLimit.text = [NSString stringWithFormat:@"价格上限:%@",[item objectForKey:@"upper_limit"]];
    cell.lowLimit.text = [NSString stringWithFormat:@"价格上限:%@",[item objectForKey:@"lower_limit"]];
    
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
