//
//  StorePurchaseViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "StorePurchaseViewController.h"
#import "StoreCell.h"
#import "SADropMenu.h"
@interface StorePurchaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@end

@implementation StorePurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [NSMutableArray new];
    
    [self.view addSubview:self.tableView];
    
    [self addHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addHeader{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
    CGFloat wid = ((kScreenWidth-16*2)-90*3)/2 + 90;
    {
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, 90, 20)];
        [btn1 setTitle:@"优选商家" forState:UIControlStateNormal];
        [btn1 setTitleColor:kColor(64,64,64) forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
//        [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn1.imageView.size.width, 0, btn1.imageView.size.width)];
//        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, btn1.titleLabel.bounds.size.width, 0, -btn1.titleLabel.bounds.size.width)];
        
        [header addSubview:btn1];
        btn1.centerY = header.centerY;

        [btn1 addTarget:self action:@selector(clickExcellent:) forControlEvents:UIControlEventTouchUpInside];
    }
    {
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(16+wid, 0, 90, 20)];
        [btn1 setTitle:@"所有金额" forState:UIControlStateNormal];
        [btn1 setTitleColor:kColor(64,64,64) forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn1.imageView.size.width, 0, btn1.imageView.size.width)];
        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, btn1.titleLabel.bounds.size.width, 0, -btn1.titleLabel.bounds.size.width)];
        
        [header addSubview:btn1];
        btn1.centerY = header.centerY;
        
        [btn1 addTarget:self action:@selector(clickMoney:) forControlEvents:UIControlEventTouchUpInside];
    }
    {
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(16+wid*2, 0, 90, 20)];
        [btn1 setTitle:@"所有方式" forState:UIControlStateNormal];
        [btn1 setTitleColor:kColor(64,64,64) forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn1.imageView.size.width, 0, btn1.imageView.size.width)];
        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, btn1.titleLabel.bounds.size.width, 0, -btn1.titleLabel.bounds.size.width)];
        
        [header addSubview:btn1];
        btn1.centerY = header.centerY;
        
        [btn1 addTarget:self action:@selector(clickWay:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,header.height-0.5f, header.width, 0.5)];
    v.backgroundColor = kColor(200, 200, 200);
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0,0, header.width, 0.5)];
    v2.backgroundColor = kColor(200, 200, 200);
    
    [header addSubview:v];
    [header addSubview:v2];
    
    self.tableView.tableHeaderView = header;
}

-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNaviHeight-kTabBarHeight-kScrollTitleHeight-58) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - TableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.data.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StoreCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0f;
}

-(void)clickExcellent:(id)sender{
    
}

-(void)clickMoney:(id)sender{
//    NSMutableArray *data = @[@"aa",@"bb",@"cc"];
//    SADropMenu *menu = [[SADropMenu alloc] initWithFrame:CGRectMake(0, 0, 0, 0) titles:data rowHeight:50];
//    menu.block = ^(int index){
//
//    };
}

-(void)clickWay:(id)sender{
    
}
@end
