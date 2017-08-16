//
//  MCVideoViewController.h
//  FZFBase
//
//  Created by fengzifeng on 16/7/21.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"

@interface MCVideoViewController : MCViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
}
@end
