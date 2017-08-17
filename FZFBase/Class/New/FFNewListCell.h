//
//  FFNewListCell.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/16.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFNewListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *faceButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *upLabel;
@property (nonatomic, weak) IBOutlet UIImageView *picImaegView;
@property (nonatomic, weak) IBOutlet UILabel *desLabel;

@end
