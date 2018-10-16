//
//  StockInfoViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "StockInfoViewController.h"
#import "SortView.h"
#import "StockInfoCell.h"
#import "HttpRequest.h"
#import "StockLittleViewController.h"

@interface StockInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)UIView *rankContainer;
@property(nonatomic,strong)NSArray* items;
@end

@implementation StockInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [NSMutableArray new];
    [self.data addObjectsFromArray:@[@"N深信服",@"怡亚通",@"神州数码",@"翔港科技"]];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.rankContainer;
    
    self.items = @[];
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    if([self.title isEqualToString:@"自选"]){
        [self getSelectInfo];
    }
    
    if([self.title isEqualToString:@"指数"]){
        [self getZhishuInfo];
    }
    
    if([self.title isEqualToString:@"沪深"] || [self.title isEqualToString:@"板块"]){
        [self getHushenInfo];
    }
    
    if([self.title isEqualToString:@"港美"]){
        [self getGangmeiInfo];
    }
    
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"数据请求中"];
    
    if([self.title containsString:@"china_"]){
        NSString* asset = [self.title substringFromIndex:6];
        NSLog(@"asset = %@",asset);
        NSDictionary* parameters = @{@"order_by":@"price",
                                     @"order":@"desc",
                                     @"asset":asset
                                     };
        NSString* url = @"market/item";
        
        [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
            
            if(success){
                [HUDUtil hideHudView];
                //            NSLog(@"list = %@",data);
                if([[data objectForKey:@"ret"] intValue] == 1){
                    _items = [[data objectForKey:@"data"] objectForKey:@"items"];
                    if(_items){
                        //                    NSLog(@"items = %@,数量为：%lu",_items,(unsigned long)_items.count);
                        [self.tableView reloadData];
                    }
                }else{
                    [HUDUtil showHudViewInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                }
            }
        }];
    }else if([self.title containsString:@"global_"]){
        NSString* asset = [self.title substringFromIndex:7];
        NSLog(@"asset = %@",asset);
        NSDictionary* parameters = @{@"page":@"1",
                                     @"page_limit":@"10",
                                     @"asset":asset
                                     };
        NSString* url = @"market/global/pricelist";
        [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
            
            if(success){
                [HUDUtil hideHudView];
//                NSLog(@"list = %@",data);
                if([[data objectForKey:@"ret"] intValue] == 1){
                    _items = [[data objectForKey:@"data"] objectForKey:@"assets"];
                    if(_items){
                        //                    NSLog(@"items = %@,数量为：%lu",_items,(unsigned long)_items.count);
                        [self.tableView reloadData];
                    }
                }else{
                    [HUDUtil showHudViewInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
                }
            }
        }];
    }
    
    
}

-(void)getSelectInfo{

    NSDictionary* parameters = @{@"page":@(1),
                                 @"page_limit":@(10),
                                 @"order_by":@"price",
                                 @"order":@"desc"
                                 };
    NSString* url = @"market/follow/list";
    
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
//        [HUDUtil hideHudView];
        if(success){
            [HUDUtil hideHudView];
//            NSLog(@"list = %@",data);
            if([[data objectForKey:@"ret"] intValue] == 1){
                _items = [[data objectForKey:@"data"] objectForKey:@"items"];
                if(_items){
                    //                    NSLog(@"items = %@,数量为：%lu",_items,(unsigned long)_items.count);
                    [self.tableView reloadData];
                }
            }else{
                [HUDUtil showHudViewInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
}

-(void)getZhishuInfo{
    NSDictionary* parameters = @{};
    NSString* url = @"market/asset/index/tickerAll";
    
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        [HUDUtil hideHudView];
        if(success){
//            NSLog(@"list = %@",data);
            if([[data objectForKey:@"ret"] intValue] == 1){
                _items = [[data objectForKey:@"data"] objectForKey:@"tickers"];
                if(_items){
                    //                    NSLog(@"items = %@,数量为：%lu",_items,(unsigned long)_items.count);
                    [self.tableView reloadData];
                }
            }
        }
    }];
}

-(void)getHushenInfo{
    NSDictionary* parameters = @{@"order_by":@"price",
                                 @"order":@"desc",
                                 @"asset":@"RMB"
                                 };
    NSString* url = @"market/item";
    
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        [HUDUtil hideHudView];
        if(success){
//            NSLog(@"list = %@",data);
            if([[data objectForKey:@"ret"] intValue] == 1){
                _items = [[data objectForKey:@"data"] objectForKey:@"items"];
                if(_items){
                    //                    NSLog(@"items = %@,数量为：%lu",_items,(unsigned long)_items.count);
                    [self.tableView reloadData];
                }
            }
        }
    }];
}

-(void)getGangmeiInfo{
    NSDictionary* parameters = @{@"order_by":@"price",
                                 @"order":@"desc",
                                 @"asset":@"USD"
                                 };
    NSString* url = @"market/item";
    
    [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
        [HUDUtil hideHudView];
        if(success){
//            NSLog(@"list = %@",data);
            if([[data objectForKey:@"ret"] intValue] == 1){
                _items = [[data objectForKey:@"data"] objectForKey:@"items"];
                if(_items){
                    //                    NSLog(@"items = %@,数量为：%lu",_items,(unsigned long)_items.count);
                    [self.tableView reloadData];
                }
            }
        }
    }];
}

-(UITableView*)tableView{
    if(nil==_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(UIView*)rankContainer{
    if(!_rankContainer){
        _rankContainer = [UIView new];
        _rankContainer.frame = CGRectMake(0, 0, kScreenWidth, 40);
        _rankContainer.backgroundColor = kColor(245, 245, 245);
        
        WeakSelf(weakSelf)
        SortView *sort1 = [[SortView alloc] initWithFrame:CGRectMake(15, 0, 0, 15) title:@"股票"];
        sort1.block = ^(BOOL isUp){
          //TODO 数据排序，reload
            [weakSelf.tableView reloadData];
        };
        sort1.centerY = _rankContainer.centerY;
        [_rankContainer addSubview:sort1];
        
        SortView *sort2 = [[SortView alloc] initWithFrame:CGRectMake(15, 0, 0, 15) title:@"最新价"];
        sort2.block = ^(BOOL isUp){
            //TODO 数据排序，reload
            [weakSelf.tableView reloadData];
        };
        sort2.centerY = _rankContainer.centerY;
        sort2.right = kScreenWidth-112;
        [_rankContainer addSubview:sort2];
        
        SortView *sort3 = [[SortView alloc] initWithFrame:CGRectMake(15, 0, 0, 15) title:@"24H涨跌"];
        sort3.block = ^(BOOL isUp){
            //TODO 数据排序，reload
            [weakSelf.tableView reloadData];
        };
        sort3.right = kScreenWidth-15;
        sort3.centerY = _rankContainer.centerY;
        [_rankContainer addSubview:sort3];
    }
    return _rankContainer;
}
#pragma mark - TableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.data.count;
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stockinfoid"];
    if(!cell){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StockInfoCell" owner:self options:nil] objectAtIndex:0];
        
        
    }
    //TODO 塞数据
    
    if(self.items.count>0){
//        NSLog(@"keys = %ld",self.items.allValues.count);
        NSDictionary* item = self.items[indexPath.row];
        if(item){
            if([self.title isEqualToString:@"自选"] || [self.title isEqualToString:@"沪深"] || [self.title isEqualToString:@"港美"] ||[self.title isEqualToString:@"板块"]){
                cell.titleLabel.text = [item objectForKey:@"market"];
            }else if ([self.title isEqualToString:@"指数"]){
                cell.titleLabel.text = [item objectForKey:@"asset"];
            }else if ([self.title containsString:@"global_"]){
                cell.titleLabel.text = [item objectForKey:@"store"];
            }else if ([self.title containsString:@"china_"]){
                cell.titleLabel.text = [item objectForKey:@"market"];
            }
            
            if (![self.title isEqualToString:@"指数"]){
                cell.volLabel.text = [item objectForKey:@"volume"];
            }
            
            
            if ([self.title isEqualToString:@"指数"]){
                cell.priceLabel.text = [item objectForKey:@"open"];
            }else{
                cell.priceLabel.text = [item objectForKey:@"price"];
            }
            NSString* incre = @"";
            if ([self.title isEqualToString:@"指数"]){
                incre = [item objectForKey:@"changePercent"];
            }else{
                incre = [item objectForKey:@"increase"];
            }
            float ins = [incre floatValue];
            incre = [NSString stringWithFormat:@"%.2f%%",ins*100];
            cell.percentLabel.text = incre;
            
            cell.isFollow = [item objectForKey:@"follow"];
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StockInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell){
        NSString* name = cell.titleLabel.text;
//        NSDictionary* data = [self getShowDataWithName:name];
//        if(data){
//            [[SearchData getInstance] addhistory:data];
//
//
//        }
        name = [NSString stringWithFormat:@"%@",name];
        StockLittleViewController* vc = [[StockLittleViewController alloc] initWithNibName:@"StockLittleViewController" bundle:nil];
        [vc setTitle:name];
        
        id temp = self.parentViewController.view.selfViewController.navigationController;
        [temp pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    DLog(@"");
}
@end
