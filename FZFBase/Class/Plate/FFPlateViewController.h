//
//  FFPlateViewController.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/16.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"

@interface FFPlateViewController : MCViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataArray;
    BOOL _isRelate;
}

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;


@end
