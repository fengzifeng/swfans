//
//  USAuthViewController.h
//  USEvent
//
//  Created by fengzifeng on 15/9/15.
//  Copyright (c) 2015年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"

typedef enum {
    reginType = 0,
    loginType,
    getPassword
} authType;

@interface USAuthViewController : MCViewController
{
    IBOutlet UITableView *_tableView;
}

@property (nonatomic, assign) authType type;
@property (nonatomic, strong) UIButton *downButton;


@end
