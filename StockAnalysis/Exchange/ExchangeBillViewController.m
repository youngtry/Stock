//
//  ExchangeBillViewController.m
//  StockAnalysis
//
//  Created by try on 2018/8/15.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ExchangeBillViewController.h"
#import "ExchangeBillTableViewCell.h"
#import "TradeTableViewCell.h"

@interface ExchangeBillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *allNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *allTypeBtn;
@property (weak, nonatomic) IBOutlet UITableView *nameList;
@property (weak, nonatomic) IBOutlet UITableView *typeList;
@property (weak, nonatomic) IBOutlet UIImageView *nameArrrow;
@property (weak, nonatomic) IBOutlet UIImageView *typeArrow;
@property (weak, nonatomic) IBOutlet UITableView *billList;

@property (nonatomic,strong)NSMutableArray* nameArray;
@property (nonatomic,strong)NSMutableArray* typeArray;
@property (nonatomic,strong)NSMutableArray* billArray;

@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL isUpdate;

@end

@implementation ExchangeBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"交易账单";
    
    self.nameList.delegate = self;
    self.nameList.dataSource = self;
    self.typeList.delegate = self;
    self.typeList.dataSource = self;
    self.billList.delegate = self;
    self.billList.dataSource = self;
    
    self.page = 1;
    self.isUpdate = YES;
    
    self.nameList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.typeList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.nameArray = [NSMutableArray new];
    self.typeArray = [NSMutableArray new];
    self.billArray = [NSMutableArray new];
    
    self.nameList.tableFooterView = [UIView new];
    self.typeList.tableFooterView = [UIView new];
    self.billList.tableFooterView = [UIView new];
    
    [self.nameList setHidden:YES];
    [self.typeList setHidden:YES];
    
    [self.nameArrrow setHidden:YES];
    [self.typeArrow setHidden:YES];
    
    
    
    [self.nameArray addObject:@"全部"];
    for (int i=0;i<8; i++) {
        NSString* info = [NSString stringWithFormat:@"期货%d",i];
        [self.nameArray addObject:info];
    }
    [self.typeArray addObject:@"全部"];
//    [self.typeArray addObject:@"充值"];
//    [self.typeArray addObject:@"提现"];
    [self.typeArray addObject:@"买入"];
    [self.typeArray addObject:@"卖出"];
//    [self.typeArray addObject:@"新手任务"];
//    [self.typeArray addObject:@"邀请好友完成新手任务"];
//    [self.typeArray addObject:@"扣除任务奖励"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.billArray removeAllObjects];
    self.page = 1;
    self.isUpdate = YES;
//    [self.nameArray removeAllObjects];
//    [self.typeArray removeAllObjects];
//    [self.nameArray addObject:@"全部"];
//    [self.typeArray addObject:@"全部"];
    [self getTrade:self.page];
}

-(void)getTrade:(NSInteger)page{
    self.page++;
    NSString* url = @"exchange/trades";
    NSDictionary* params = @{@"page":@(page),
                             @"page_limit":@(10)
                             };
    [[HttpRequest getInstance] postWithURL:url parma:params block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                NSArray* list = [[data objectForKey:@"data"] objectForKey:@"trades"];
                if(list.count>0){
                    [self.billArray addObjectsFromArray:list];
                    [self.billList reloadData];
                    
//                    for(NSDictionary* info in list){
//                        NSString* name = [info objectForKey:@"market"];
//                        [self addObject:self.nameArray withObject:name];
//                        NSString* mode = [info objectForKey:@"mode"];
//                        [self addObject:self.typeArray withObject:mode];
//                        [self.nameList reloadData];
//                        [self.typeList reloadData];
//                    }
                    
                }else{
                    self.isUpdate = NO;
                    [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"数据全部加载完毕"];
                }
                
            }
        }
    }];
}

-(void)addObject:(NSMutableArray* )array withObject:(NSString*)object{
    BOOL isHave = NO;
    for (NSString* info in array) {
        if([info isEqualToString:object]){
            isHave = YES;
        }
    }
    
    if(!isHave){
        [array addObject:object];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.page = 1;
    self.isUpdate = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickAllNameBtn:(id)sender {
    if(self.nameList.isHidden){
        [self.nameList setHidden:NO];
        [self.nameArrrow setHidden:NO];
        
        [self.nameList reloadData];
        
        UIImage *contentBgImagebubble = [UIImage imageNamed:@"xialakuang.png"];
        
        UIImage * newBgImage =[contentBgImagebubble stretchableImageWithLeftCapWidth:40 topCapHeight:40];
//        NSLog(@"self.typeList.frame = %f,%f",self.nameList.frame.size.width,self.nameList.frame.size.height);
        
        UIImageView* bg = [[UIImageView alloc] initWithFrame:self.nameList.frame];
        [bg setImage:newBgImage];
        
        [self.nameList setBackgroundView:bg];
        
    }else{
        [self.nameList setHidden:YES];
        [self.nameArrrow setHidden:YES];
    
    }
    
}
- (IBAction)clickAllTypeBtn:(id)sender {
    if(self.typeList.isHidden){
        [self.typeList setHidden:NO];
        [self.typeArrow setHidden:NO];
        [self.typeList reloadData];
        
        UIImage *contentBgImagebubble1 = [UIImage imageNamed:@"xialakuang.png"];
        
        UIImage * newBgImage1 =[contentBgImagebubble1 stretchableImageWithLeftCapWidth:40 topCapHeight:40];
//        NSLog(@"self.typeList.frame = %f,%f",self.typeList.frame.size.width,self.typeList.frame.size.height);
        
        UIImageView* bg1 = [[UIImageView alloc] initWithFrame:self.typeList.frame];
        [bg1 setImage:newBgImage1];
        
        [self.typeList setBackgroundView:bg1];
        
    }else{
        [self.typeList setHidden:YES];
        [self.typeArrow setHidden:YES];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.nameList){
//        NSLog(@"self.nameArray.count = %ld",self.nameArray.count);
        return self.nameArray.count;
    }
    
    if(tableView == self.typeList){
        return self.typeArray.count;
    }
    
    if(tableView == self.billList){
        return self.billArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(tableView == self.billList){
        return 105;
    }
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.billList){
        TradeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"TradeTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        NSDictionary* info = self.billArray[indexPath.row];
        cell.nameLabel.text = [info objectForKey:@"market"];
        cell.dateLabel.text = [info objectForKey:@"updated_at"];
        cell.stateLabel.text = [info objectForKey:@"state"];
        cell.modeLabel.text = [info objectForKey:@"mode"];
        
        return cell;
        
    }
    
    
    ExchangeBillTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ExchangeBillTableViewCell" owner:self options:nil] objectAtIndex:0];

    }
    //    NSLog(@"获取历史记录");
    [cell.name setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    [cell.currentIcon setHidden:YES];
    if(tableView == self.nameList){
        cell.name.text = self.nameArray[[indexPath row]];
        if([cell.name.text isEqualToString:self.allNameBtn.titleLabel.text]){
            [cell.name setTextColor:[UIColor colorWithRed:251.0/255.0 green:173.0/255.0 blue:20.0/255.0 alpha:1.0]];
            [cell.currentIcon setHidden:NO];
        }
    }
    
    if(tableView == self.typeList){
        cell.name.text = self.typeArray[[indexPath row]];
        if([cell.name.text isEqualToString:self.allTypeBtn.titleLabel.text]){
            [cell.name setTextColor:[UIColor colorWithRed:251.0/255.0 green:173.0/255.0 blue:20.0/255.0 alpha:1.0]];
            [cell.currentIcon setHidden:NO];
        }
    }
    
    if(kScreenWidth == 320){
       [cell.name setFont:[UIFont systemFontOfSize:9]];
    }
    
    [tableView setBackgroundColor:[UIColor clearColor]];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView != self.billList){
        ExchangeBillTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell){
            NSString* name = cell.name.text;
            if(tableView == self.nameList){
                [self.allNameBtn setTitle:name forState:UIControlStateNormal];
                [self.nameArrrow setHidden:YES];
                
            }
            
            if(tableView == self.typeList){
                [self.allTypeBtn setTitle:name forState:UIControlStateNormal];
                [self.typeArrow setHidden:YES];
            }
            
            [tableView setHidden:YES];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView != self.billList){
        return;
    }
    // 下拉到最底部时显示更多数据
    if(!self.isUpdate){
        return;
    }
    if(self.isUpdate && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
        [self getTrade:self.page];
    }
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
