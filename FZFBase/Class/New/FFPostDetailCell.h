//
//  FFPostDetailCell.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/24.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYPAttributeLabel.h"

@interface FFPostDetailCell : UITableViewCell

@property (nonatomic, weak) IBOutlet ZYPAttributeLabel *contLabel;

- (void)updateCell;

+ (CGFloat)getCellHeight;

@end
