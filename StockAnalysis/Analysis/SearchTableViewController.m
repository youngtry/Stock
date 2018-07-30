//
//  SearchTableViewController.m
//  StockAnalysis
//
//  Created by try on 2018/7/16.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchTableViewCell.h"
#import "SearchData.h"

@interface SearchTableViewController (){
    NSMutableArray* showList;
    
}

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    showList = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchList) name:@"ShowSearchList" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"showTableview  %@",[self title]);
 
    [showList removeAllObjects];
    if([[self title] isEqualToString:@"0"]){
        for(int i=0;i<[SearchData getInstance].searchList.count;i++){
            NSDictionary* info = [SearchData getInstance].searchList[i];
            if(![self isRepeatInShowList:info]){

                if(![info objectForKey:@"asset"]){
                    //不能是商户搜索
                    [showList addObject:info];
                }
            }
        }

        for(int i=0;i<[[SearchData getInstance] getSpecail].count;i++){
            NSDictionary* info = [[SearchData getInstance] getSpecail][i];
            if(![self isRepeatInShowList:info]){
                [showList addObject:info];
            }
        }
    }else if ([[self title] isEqualToString:@"1"]){

        for(int i=0;i<[SearchData getInstance].searchList.count;i++){
            NSDictionary* info = [SearchData getInstance].searchList[i];
            if(![self isRepeatInShowList:info]){

                if([info objectForKey:@"asset"]){
                    //是商户搜索

                    [showList addObject:info];
                }
            }
        }
    }

    [_tableView reloadData];
   
}
-(void)showSearchList{
    
    [showList removeAllObjects];
    BOOL isshop = NO;
    for(int i=0;i<[SearchData getInstance].searchList.count;i++){
        NSDictionary* info = [SearchData getInstance].searchList[i];
        if(![self isRepeatInShowList:info]){
            [showList addObject:info];
            if([info objectForKey:@"asset"]){
                //是商户搜索
                isshop = YES;
            }
        }
    }
    
    if(!isshop){
        for(int i=0;i<[[SearchData getInstance] getSpecail].count;i++){
            NSDictionary* info = [[SearchData getInstance] getSpecail][i];
            if(![self isRepeatInShowList:info]){
                [showList addObject:info];
            }
        }
    }
    
    
    [_tableView reloadData];
}

-(BOOL)isRepeatInShowList:(NSDictionary*)info{
    
    for(int i=0;i<showList.count;i++){
        NSDictionary* data = showList[i];
        if([[data objectForKey:@"market"] isEqualToString:[info objectForKey:@"market"]]){
            return YES;
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView*)tableView{
    if(nil==_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    NSMutableArray* searchlist = showList;
    return searchlist.count;;
//    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSMutableArray* searchlist = showList;
    
    
    
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil] objectAtIndex:0];
//
    }
    
    NSDictionary* data = searchlist[[indexPath row]];
    if([data objectForKey:@"asset"]){
        [cell setName:[data objectForKey:@"name"]];
        [cell setIfShop:YES];
    }else{
        [cell setName:[data objectForKey:@"market"]];
        [cell setIfShop:NO];
        if([self isCellLike:data]){
            //关注
            [cell setIfLike:YES];
        }else{
            [cell setIfLike:NO];
        }
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell){
        NSString* name = [cell getName];
        NSDictionary* data = [self getShowDataWithName:name];
        if(data){
            [[SearchData getInstance] addhistory:data];
            [[SearchData getInstance] addData];
        }
    }
}

-(NSDictionary*)getShowDataWithName:(NSString*)name{
    for(int i=0;i<showList.count;i++){
        NSDictionary* data = showList[i];
        if([[data objectForKey:@"market"] isEqualToString:name]){
            return data;
        }
    }
    return nil;
}

-(BOOL)isCellLike:(NSDictionary*)info{
    for(int i=0;i<[[SearchData getInstance] getSpecail].count;i++){
        NSDictionary* data = [[SearchData getInstance] getSpecail][i];
        if([[data objectForKey:@"market"] isEqualToString:[info objectForKey:@"market"]]){
            return YES;
        }
    }
    
    return NO;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
