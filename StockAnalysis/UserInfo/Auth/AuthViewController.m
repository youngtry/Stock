//
//  AuthViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/7/6.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AuthViewController.h"
#import "AuthApproveLevelOneViewController.h"
@interface AuthViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)NSInteger authLevel;
@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.authLevel = 0;
    [self.view addSubview:self.table];
}

-(UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id"];
    }
    NSInteger row = indexPath.row;
    if(row == 0)
    {
        cell.imageView.image = [Util imageWithColor:[UIColor blueColor]];
        cell.textLabel.text = @"级别1";
        if(row>=_authLevel){
            cell.detailTextLabel.text = @"去认证";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.detailTextLabel.text = @"已完成";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }else if(row == 1){
        cell.imageView.image = [Util imageWithColor:[UIColor blueColor]];
        cell.textLabel.text = @"级别2";
        if(row>=_authLevel){
            
            if((row-1)>=_authLevel){
                cell.detailTextLabel.text = @"请先完成上一层级别";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                cell.detailTextLabel.text = @"去认证";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        }else{
            cell.detailTextLabel.text = @"已完成";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if (row == 2){
        cell.imageView.image = [Util imageWithColor:[UIColor blueColor]];
        cell.textLabel.text = @"级别3";
        if(row>=_authLevel){
            
            if((row-1)>=_authLevel){
                cell.detailTextLabel.text = @"请先完成上一层级别";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                cell.detailTextLabel.text = @"去认证";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        }else{
            cell.detailTextLabel.text = @"已完成";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        AuthApproveLevelOneViewController*vc = [AuthApproveLevelOneViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
