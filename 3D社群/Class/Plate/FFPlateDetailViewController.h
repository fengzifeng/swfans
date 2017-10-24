//
//  FFPlateDetailViewController.h
//  FZFBase
//
//  Created by 冯子丰 on 2017/8/22.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"

@interface FFPlateDetailViewController : MCViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataArray;
    BOOL _isRelate;
}

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@end
