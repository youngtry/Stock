//
//  UserManagerViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/8/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import "UserManagerViewController.h"
#import "GameData.h"
#import "UserManagerTableViewCell.h"

@interface UserManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *accountList;

@end

@implementation UserManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户管理";
    self.accountList.delegate = self;
    self.accountList.dataSource = self;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableVIewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* list = [GameData getAccountList];
    return list.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    indexPath.section
    //    indexPath.row
    //    if (indexPath.section == 0) {
    //        return 50;
    //    }
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserManagerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserManagerTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    NSString* account = [GameData getUserAccount];
    NSArray* list = [GameData getAccountList];
    
    if([indexPath row] == list.count){
        [cell.switchBtn setHidden:NO];
        [cell.account setHidden:YES];
        [cell.currentIcon setHidden:YES];
    }else{
        if(list.count>indexPath.row){
            NSDictionary* info = [list objectAtIndex:[indexPath row]];
            
            if([[info objectForKey:@"account"] isEqualToString:account]){
                [cell.currentIcon setHidden:NO];
            }else{
                [cell.currentIcon setHidden:YES];
            }
            [cell.switchBtn setHidden:YES];
            cell.account.text = [NSString stringWithFormat:@"%@ %@", [info objectForKey:@"district"],[info objectForKey:@"account"]];
        }
        
    }
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserManagerTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSArray* list = [GameData getAccountList];
    
    
    if([indexPath row] == list.count){
        //切换账号
    }else{
        NSDictionary* info = [list objectAtIndex:[indexPath row]];
        NSString* username = [info objectForKey:@"account"];
        NSString* password = [info objectForKey:@"password"];
        NSString* district = [info objectForKey:@"district"];
//        NSLog(@"username = %@,password = %@",username,password);
        if([username containsString:@"@"]){
            //邮箱登录
            NSDictionary *parameters = @{@"email": [GameData getUserAccount],
                                         @"password": [GameData getUserPassword]};
            
            NSString* url = @"account/login/email";
            [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
            [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
                if(success){
                    [HUDUtil hideHudView];
                    //                NSLog(@"登录消息 = %@",data);
                    if([[data objectForKey:@"ret"] intValue] == 1){
//                        [self autoLoginBack];
                        [GameData setUserAccount:username];
                        [GameData setUserPassword:password];
                        [GameData setAccountList:username withPassword:password withDistrict:district];
                        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                        [defaultdata setBool:YES forKey:@"IsLogin"];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
                    }else{
                        NSString* msg = [data objectForKey:@"msg"];
                        [HUDUtil showSystemTipView:self.navigationController title:@"登录失败" withContent:msg];
                        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                        [defaultdata setBool:NO forKey:@"IsLogin"];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
                    }
                }
            }];
        }else{
            //手机号登录
            NSDictionary *parameters = @{@"phone": [GameData getUserAccount],
                                         @"password": [GameData getUserPassword],
                                         @"district": [GameData getDistrict]
                                         };
            
            
            NSString* url = @"account/login/phone";
            [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
            [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
                if(success){
                    [HUDUtil hideHudView];
//                    NSLog(@"登录消息1 = %@",data);
                    if([[data objectForKey:@"ret"] intValue] == 1){
//                        [self autoLoginBack];
                        [GameData setUserAccount:username];
                        [GameData setUserPassword:password];
                        [GameData setAccountList:username withPassword:password withDistrict:district];
                        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                        [defaultdata setBool:YES forKey:@"IsLogin"];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
                    }else{
                        NSString* msg = [data objectForKey:@"msg"];
                        [HUDUtil showSystemTipView:self.navigationController title:@"登录失败" withContent:msg];
                        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                        [defaultdata setBool:NO forKey:@"IsLogin"];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
                    }
                    
                    
                }
            }];
        }
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
