//
//  FFActiveChooseView.h
//  swfans
//
//  Created by fengzifeng on 2017/9/22.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFPlateModel.h"

@interface FFActiveChooseView : UIView

typedef void(^choose)(FFPlateItemModel *model);

@property (nonatomic, weak) IBOutlet UITableView *tableView;

+ (FFActiveChooseView *)showActiveChooseView:(NSArray *)dataArray choose:(choose)choose;

@end
