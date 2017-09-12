//
//  MCAboutMeCell.h
//  FZFBase
//
//  Created by fengzifeng on 16/7/7.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFAboutMeCell : UITableViewCell
{
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_lineLabel;
}
@property (nonatomic, weak) IBOutlet UILabel *contLabel;
@property (nonatomic, weak) IBOutlet UIImageView *arrImageView;

- (void)updateCell:(NSString *)titleStr;


@end
