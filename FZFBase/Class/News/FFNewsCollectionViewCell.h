//
//  FFNewsCollectionViewCell.h
//  FZFBase
//
//  Created by fengzifeng on 16/8/10.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFNewsCollectionViewCell : UICollectionViewCell <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (void)reloadView:(NSArray *)array;
@end
