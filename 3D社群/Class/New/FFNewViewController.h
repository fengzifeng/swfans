//
//  FFNewViewController.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/16.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"

@interface FFNewViewController : MCViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, copy) NSString *forum_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, assign) BOOL isMiss;

- (void)requestData;

@end
