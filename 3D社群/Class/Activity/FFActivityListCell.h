//
//  FFActivityListCell.h
//  FZFBase
//
//  Created by 冯子丰 on 2017/8/22.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFActivityItemModel;

@interface FFActivityListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *picImageView;
@property (nonatomic, weak) IBOutlet UILabel *peopleCount;
@property (nonatomic, weak) IBOutlet UILabel *replyCount;
@property (nonatomic, weak) IBOutlet UIImageView *upImaegView;

- (void)updateCell:(FFActivityItemModel *)model;

@end
