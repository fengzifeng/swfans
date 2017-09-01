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

- (void)updateCell:(NSString *)titleStr;


@end
