//
//  MCAboutMeCell.h
//  FZFBase
//
//  Created by fengzifeng on 16/7/7.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAboutMeCell : UITableViewCell
{
    IBOutlet UIImageView *_imageView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_lineLabel;
}

- (void)updateCell:(NSString *)titleStr;

@end
