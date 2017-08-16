//
//  MCNewsTableViewCell.h
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCNewsTableViewCell : UITableViewCell
{
    IBOutlet UILabel *_contentLabel;
    IBOutlet UILabel *_iconLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UIImageView *_imageView;
}

- (void)updateCell;

@end

@interface NewsCell : UITableViewCell

@end

@interface ImagesCell : UITableViewCell

@end

@interface TopImageCell : UITableViewCell

@end

@interface TopTxtCell : UITableViewCell

@end

@interface BigImageCell : UITableViewCell

@end