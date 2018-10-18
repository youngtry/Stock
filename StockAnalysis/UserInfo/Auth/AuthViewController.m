//
//  AuthViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/7/6.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AuthViewController.h"
#import "AuthApprove1VC.h"
#import "AuthApprove21ViewController.h"
@interface AuthViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)NSInteger authLevel;
@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份认证";
    [self.view addSubview:self.table];
    
    
    
//    self.authLevel = 2;
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    NSString* url = @"account/userinfo";
    NSDictionary *parameters = @{} ;
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
    [[HttpRequest getInstance] getWithURL:url parma:parameters block:^(BOOL success, id data) {
        if(success){
            [HUDUtil hideHudView];
            if([[data objectForKey:@"ret"] intValue] == 1){
                self.authLevel = [[[[data objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"level"] intValue];
                [self.table reloadData];
            }else{
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger row = indexPath.row;
    if(row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"level1.png"];
        cell.textLabel.text = @"级别1";
        if(row>=_authLevel){
            cell.detailTextLabel.text = @"去认证";
            cell.detailTextLabel.textColor = kThemeYellow;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.detailTextLabel.text = @"已完成";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }else if(row == 1){
        cell.imageView.image = [UIImage imageNamed:@"level2.png"];;
        cell.textLabel.text = @"级别2";
        if(row>=_authLevel){
            
            if((row-1)>=_authLevel){
                cell.detailTextLabel.text = @"请先完成上一层级别";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                cell.detailTextLabel.text = @"去认证";
                cell.detailTextLabel.textColor = kThemeYellow;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        }else{
            cell.detailTextLabel.text = @"已完成";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if (row == 2){
        cell.imageView.image = [UIImage imageNamed:@"level3.png"];;
        cell.textLabel.text = @"级别3";
        if(row>=_authLevel){
            
            if((row-1)>=_authLevel){
                cell.detailTextLabel.text = @"请先完成上一层级别";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                cell.detailTextLabel.text = @"去认证";
                cell.detailTextLabel.textColor = kThemeYellow;
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
    if(indexPath.row>_authLevel){
        return;
    }
    if(indexPath.row==0){
        AuthApprove1VC*vc = [AuthApprove1VC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        
        NSString *fullPath1 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Auth_1.jpg"];
        NSString *fullPath2 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Auth_2.jpg"];
        NSString *fullPath3 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Auth_3.jpg"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL result1 = [fileManager fileExistsAtPath:fullPath1];
        BOOL result2 = [fileManager fileExistsAtPath:fullPath2];
        BOOL result3 = [fileManager fileExistsAtPath:fullPath3];
        NSLog(@"这个文件已经存在：%@",result1?@"是的":@"不存在");
        NSLog(@"这个文件已经存在：%@",result2?@"是的":@"不存在");
        NSLog(@"这个文件已经存在：%@",result3?@"是的":@"不存在");
        NSLog(@"path1 = %@,path2 = %@,path3 = %@",fullPath1,fullPath2,fullPath3);
        if(result1){
            [fileManager removeItemAtPath:fullPath1 error:nil];
        }
        
        if(result2){
            [fileManager removeItemAtPath:fullPath2 error:nil];
        }
        
        if(result3){
            [fileManager removeItemAtPath:fullPath3 error:nil];
        }
        
        AuthApprove21ViewController *vc = [[AuthApprove21ViewController alloc] initWithNibName:@"AuthApprove21ViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

@end
