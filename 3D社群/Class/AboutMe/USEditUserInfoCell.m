//
//  USEditUserInfoCell.m
//  USEvent
//
//  Created by FZF on 15/9/30.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USEditUserInfoCell.h"
#import "USEditUserInfoViewController.h"

@implementation USEditUserInfoCell
{

}

- (void)awakeFromNib
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}

- (void)updateCell:(NSString *)titleStr
{
    _titleLabel.text = titleStr;
    if ([_titleLabel.text isEqualToString:@"昵称"]) {
        _contnetLabel.text = _loginUser.username;
    } else if ([_titleLabel.text isEqualToString:@"性别"]) {
        switch (_loginUser.gender) {
            case 0:
                _contnetLabel.text = @"女";
                break;
            case 1:
                _contnetLabel.text = @"男";
                break;

            default:
                break;
        }
        _contnetLabel.text = [@(_loginUser.gender) stringValue] ;
    } else if ([_titleLabel.text isEqualToString:@"签名"]) {
//        _contnetLabel.text = _loginUser.signature;
    } else if ([_titleLabel.text isEqualToString:@"手机号"]) {
//        _contnetLabel.text = _loginUser.photoNumber;
    }
    
    [_contnetLabel autoSetDimension:ALDimensionWidth toSize:[_contnetLabel.text stringWidthWithFont:kFont_13 height:15]];

}


@end
