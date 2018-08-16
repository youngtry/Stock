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
        NSDictionary* info = [list objectAtIndex:[indexPath row]];
        
        if([[info objectForKey:@"account"] isEqualToString:account]){
            [cell.currentIcon setHidden:NO];
        }else{
            [cell.currentIcon setHidden:YES];
        }
        [cell.switchBtn setHidden:YES];
        cell.account.text = [info objectForKey:@"account"];
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
//        NSLog(@"username = %@,password = %@",username,password);
        if([username containsString:@"@"]){
            //邮箱登录
            NSDictionary *parameters = @{@"email": [GameData getUserAccount],
                                         @"password": [GameData getUserPassword]};
            
            NSString* url = @"account/login/email";
            
            [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
                if(success){
                    //                NSLog(@"登录消息 = %@",data);
                    if([[data objectForKey:@"ret"] intValue] == 1){
//                        [self autoLoginBack];
                        [GameData setUserAccount:username];
                        [GameData setUserPassword:password];
                        [GameData setAccountList:username withPassword:password];
                        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                        [defaultdata setBool:YES forKey:@"IsLogin"];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
                    }else{
                        NSString* msg = [data objectForKey:@"msg"];
                        [HUDUtil showSystemTipView:self title:@"登录失败" withContent:msg];
                    }
                }
            }];
        }else{
            //手机号登录
            NSDictionary *parameters = @{@"phone": [GameData getUserAccount],
                                         @"password": [GameData getUserPassword]};
            
            
            NSString* url = @"account/login/phone";
            
            [[HttpRequest getInstance] postWithURL:url parma:parameters block:^(BOOL success, id data) {
                if(success){
//                    NSLog(@"登录消息1 = %@",data);
                    if([[data objectForKey:@"ret"] intValue] == 1){
//                        [self autoLoginBack];
                        [GameData setUserAccount:username];
                        [GameData setUserPassword:password];
                        [GameData setAccountList:username withPassword:password];
                        NSUserDefaults* defaultdata = [NSUserDefaults standardUserDefaults];
                        [defaultdata setBool:YES forKey:@"IsLogin"];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAfterLogin" object:nil];
                    }else{
                        NSString* msg = [data objectForKey:@"msg"];
                        [HUDUtil showSystemTipView:self title:@"登录失败" withContent:msg];
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