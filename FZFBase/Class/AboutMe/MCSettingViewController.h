//
//  MCSettingViewController.h
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"

@interface MCSettingViewController : MCViewController <UITableViewDelegate,UITableViewDataSource>

{
    __weak IBOutlet UITableView *_tableView;
}

@end
