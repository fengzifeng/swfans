//
//  USAuthViewController.h
//  USEvent
//
//  Created by fengzifeng on 15/9/15.
//  Copyright (c) 2015年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"

@interface USAuthViewController : MCViewController
{
    IBOutlet UITableView *_tableView;
}

@property (nonatomic, assign) BOOL isLogin;

@end
