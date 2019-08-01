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
@property(nonatomic,strong)UIView* moneyInfoView;
@end

@implementation StorePurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [NSMutableArray new];
    
    [self.view addSubview:self.tableView];
    
    [self addHeader];
    
    if([self.title isEqualToString:Localize(@"Sell")]){
        [self.view addSubview:self.moneyInfoView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)moneyInfoView{
    if(nil == _moneyInfoView){
        
        _moneyInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [_moneyInfoView setBackgroundColor:kColor(245, 245, 249)];
        
        UILabel* lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth*0.3, 44)];
        lab1.text = [NSString stringWithFormat:@"%@:0.00",Localize(@"Can_Use_1")];
        [lab1 setFont:[UIFont systemFontOfSize:13]];
        [lab1 setAlpha:0.45];
        [lab1 setTextAlignment:NSTextAlignmentLeft];
        [_moneyInfoView addSubview:lab1];
        
        UILabel* lab2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.45, 0, kScreenWidth*0.3, 44)];
        lab2.text = [NSString stringWithFormat:@"%@:0.00",Localize(@"Freeze")];
        [lab2 setFont:[UIFont systemFontOfSize:13]];
        [lab2 setAlpha:0.45];
        [lab2 setTextAlignment:NSTextAlignmentLeft];
        [_moneyInfoView addSubview:lab2];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(kScreenWidth*0.9, 22-8, 9, 15)];
        [_moneyInfoView addSubview:btn];
    }
    
    return _moneyInfoView;
}


-(void)addHeader{
  
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    CGFloat wid = ((kScreenWidth-16*2)-90*3)/2 + 90;
    {
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, 90, 22)];
        [btn1 setTitle:Localize(@"Greate_Store") forState:UIControlStateNormal];
        [btn1 setTitleColor:kColor(0,0,0) forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"unselectquan"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateSelected];
        
//        btn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1.titleLabel setAlpha:0.25];
//        [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn1.imageView.size.width, 0, btn1.imageView.size.width)];
//        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, btn1.titleLabel.bounds.size.width, 0, btn1.titleLabel.bounds.size.width)];
        
        [header addSubview:btn1];
        btn1.centerY = header.centerY;
        [btn1 setTag:1000];

        [btn1 addTarget:self action:@selector(clickExcellent:) forControlEvents:UIControlEventTouchUpInside];
    }
    {
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(16+wid, 0, 90, 20)];
        [btn1 setTitle:Localize(@"All_Money") forState:UIControlStateNormal];
        [btn1.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [btn1 setTitleColor:kColor(64,64,64) forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
//        btn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn1.imageView.size.width, 0, btn1.imageView.size.width)];
        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, btn1.titleLabel.bounds.size.width, 0, -btn1.titleLabel.bounds.size.width)];
        
        
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1.titleLabel setAlpha:0.25];
        [btn1 setTag:1001];
        [header addSubview:btn1];
        btn1.centerY = header.centerY;
        
        [btn1 addTarget:self action:@selector(clickMoney:) forControlEvents:UIControlEventTouchUpInside];
    }
    {
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(16+wid*2, 0, 90, 20)];
        [btn1 setTitle:Localize(@"All_Way") forState:UIControlStateNormal];
        [btn1.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [btn1 setTitleColor:kColor(64,64,64) forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn1.imageView.size.width, 0, btn1.imageView.size.width)];
        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, btn1.titleLabel.bounds.size.width, 0, -btn1.titleLabel.bounds.size.width)];
        
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1.titleLabel setAlpha:0.25];
        
        [header addSubview:btn1];
        btn1.centerY = header.centerY;
        [btn1 setTag:1002];
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
        CGFloat y = 0;
        if([self.title isEqualToString:Localize(@"Sell")]){
            y = 44;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, kScreenHeight-kNaviHeight-kTabBarHeight-kScrollTitleHeight-58) style:UITableViewStylePlain];
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
    
    if([self.title isEqualToString:Localize(@"Buy")]){
        [cell.purchaseBtn setBackgroundColor:kColor(75, 185, 112)];
        [cell.purchaseBtn setTitle:self.title forState:UIControlStateNormal];
    }else if([self.title isEqualToString:Localize(@"Sell")]){
        [cell.purchaseBtn setBackgroundColor:kColor(236, 102, 95)];
        [cell.purchaseBtn setTitle:self.title forState:UIControlStateNormal];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112.0f;
}

-(void)clickExcellent:(id)sender{
    UIButton* btn = sender;
    if(btn.selected){
        [btn setSelected:NO];
    }else{
        [btn setSelected:YES];
    }
}

-(void)clickMoney:(id)sender{
    NSMutableArray *data = @[Localize(@"All_Money"),[NSString stringWithFormat:@"5%@",Localize(@"Select_Money_Label")],[NSString stringWithFormat:@"10%@",Localize(@"Select_Money_Label")],[NSString stringWithFormat:@"20%@",Localize(@"Select_Money_Label")]].mutableCopy;
    
    UIButton* btn = (UIButton*)[self.tableView.tableHeaderView subviewWithTag:1001];
    NSString* title = btn.titleLabel.text;
//    NSLog(@"title = %@",title);
    
    int currindex = 0;
    
    for (int i=0;i<data.count;i++) {
        NSString* info = data[i];
        if([info isEqualToString:title]){
            currindex = i;
        }
    }
    
    SADropMenu *menu = [[SADropMenu alloc] initWithFrame:CGRectMake(0, 42, kScreenWidth, 42*data.count) target:self.view  titles:data rowHeight:42 index:currindex];
    menu.block = ^(int index){
//        NSLog(@"index = %d",index);
        [btn setTitle:data[index] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.size.width, 0, btn.imageView.size.width)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
    };
}

-(void)clickWay:(id)sender{
    NSMutableArray *data = @[Localize(@"All_Way"),Localize(@"Band_Way"),Localize(@"Ali_Way"),Localize(@"Wechat_Way")].mutableCopy;
    
    UIButton* btn = (UIButton*)[self.tableView.tableHeaderView subviewWithTag:1002];
    NSString* title = btn.titleLabel.text;
    
    int currindex = 0;
    
    for (int i=0;i<data.count;i++) {
        NSString* info = data[i];
        if([info isEqualToString:title]){
            currindex = i;
        }
    }
    
    SADropMenu *menu = [[SADropMenu alloc] initWithFrame:CGRectMake(0, 42, kScreenWidth, 42*data.count) target:self.view  titles:data rowHeight:42 index:currindex];
    menu.images = @[@"menu",@"card",@"weixin",@"zhifubao"].mutableCopy;

    menu.block = ^(int index){
        [btn setTitle:data[index] forState:UIControlStateNormal];
        NSLog(@"title = %@",btn.titleLabel.text);
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.size.width, 0, btn.imageView.size.width)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
    };
}
@end
