//
//  FFPostDetailCell.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/24.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYPAttributeLabel.h"
@class FFPostItemModel;

@interface FFCommentDetailCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *contLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIButton *faceButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *upImaegView;

- (void)updateCell:(FFPostItemModel *)model;

+ (CGFloat)getCellHeight:(FFPostItemModel *)model;

@end
