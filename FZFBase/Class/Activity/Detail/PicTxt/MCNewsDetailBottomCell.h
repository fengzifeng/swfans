//
//  MCNewsBaseViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.

#import <UIKit/UIKit.h>

@interface MCNewsDetailBottomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sectionHeaderLbl;

@property(nonatomic,assign)BOOL iSCloseing;

+ (instancetype)theShareCell;

+ (instancetype)theSectionHeaderCell;

+ (instancetype)theSectionBottomCell;

+ (instancetype)theHotReplyCellWithTableView:(UITableView *)tableView;

+ (instancetype)theContactNewsCell;

+ (instancetype)theCloseCell;

+ (instancetype)theKeywordCell;

@end
