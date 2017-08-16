//
//  USEditUserInfoCell.h
//  USEvent
//
//  Created by FZF on 15/9/30.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USEditUserInfoCell : UITableViewCell<UITextFieldDelegate>
{
    __weak IBOutlet  UILabel *_titleLabel;
    __weak IBOutlet  UILabel *_contnetLabel;
}

- (void)updateCell:(NSString *)titleStr;

@end
