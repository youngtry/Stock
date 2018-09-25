//
//  SearchTableViewController.h
//  StockAnalysis
//
//  Created by try on 2018/7/16.
//  Copyright © 2018年 try. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray* searchResultList;
@property(nonatomic,strong)NSMutableArray* specialList;

@end
