//
//  FFPostDetailViewController.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/25.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"
#import "DrKeyBoardView.h"

@interface FFPostDetailViewController : MCViewController

@property (nonatomic, copy) NSString *postId;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DrKeyBoardView *boardView;


@end
