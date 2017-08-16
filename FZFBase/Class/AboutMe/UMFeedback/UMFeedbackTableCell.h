//
//  UMFeedbackTableCell.h
//  MCFriends
//
//  Created by fengzifeng on 14-8-19.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMFeedbackTableCell : UITableViewCell <HBCoreLabelDelegate>
{
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UIView *chatContentView;
    
    __weak IBOutlet UIButton *avatarButton;
    __weak IBOutlet UIImageView *bubbleImageView;
    __weak IBOutlet HBCoreLabel *contentLabel;
    __weak IBOutlet UIActivityIndicatorView *indicatorView;
}

+ (float)heightWithData:(NSDictionary *)data;

- (void)initWithData:(NSDictionary *)data indexPath:(NSIndexPath *)indexPath;

@end
