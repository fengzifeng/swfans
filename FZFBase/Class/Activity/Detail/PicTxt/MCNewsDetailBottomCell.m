//
//  MCNewsBaseViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.

#import "MCNewsDetailBottomCell.h"

@interface MCNewsDetailBottomCell ()

@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *userLbl;
@property (strong, nonatomic) IBOutlet UILabel *goodLbl;
@property (strong, nonatomic) IBOutlet UILabel *userLocationLbl;
@property (strong, nonatomic) IBOutlet UILabel *replyDetail;


@property (strong, nonatomic) IBOutlet UIImageView *newsIcon;
@property (strong, nonatomic) IBOutlet UILabel *newsTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *newsFromLbl;
@property (strong, nonatomic) IBOutlet UILabel *newsTimeLbl;


@property (strong, nonatomic) IBOutlet UIImageView *closeImg;
@property (strong, nonatomic) IBOutlet UILabel *closeLbl;

@end
@implementation MCNewsDetailBottomCell

+ (instancetype)theShareCell{
    return [[NSBundle mainBundle]loadNibNamed:@"MCNewsDetailBottomCell" owner:nil options:nil][0];
}

+ (instancetype)theSectionHeaderCell{
    return [[NSBundle mainBundle]loadNibNamed:@"MCNewsDetailBottomCell" owner:nil options:nil][1];
}

+ (instancetype)theSectionBottomCell{
    return [[NSBundle mainBundle]loadNibNamed:@"MCNewsDetailBottomCell" owner:nil options:nil][2];
}

+ (instancetype)theHotReplyCellWithTableView:(UITableView *)tableView;{
    static NSString *ID = @"horreplycell";
    MCNewsDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MCNewsDetailBottomCell" owner:nil options:nil][3];
    }
    return cell;
}

+ (instancetype)theContactNewsCell{
    return [[NSBundle mainBundle]loadNibNamed:@"MCNewsDetailBottomCell" owner:nil options:nil][4];
}

+ (instancetype)theCloseCell{
    return [[NSBundle mainBundle]loadNibNamed:@"MCNewsDetailBottomCell" owner:nil options:nil][5];
}

+ (instancetype)theKeywordCell{
    return [[NSBundle mainBundle]loadNibNamed:@"MCNewsDetailBottomCell" owner:nil options:nil][6];
}

- (void)setISCloseing:(BOOL)iSCloseing
{
    _iSCloseing = iSCloseing;
    self.closeImg.image = [UIImage imageNamed:iSCloseing ? @"newscontent_drag_return" : @"newscontent_drag_arrow"];
    self.closeLbl.text = iSCloseing ? @"松手关闭当前页" : @"上拉关闭当前页" ;
}

@end
