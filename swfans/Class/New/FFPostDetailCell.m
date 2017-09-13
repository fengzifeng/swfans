//
//  FFPostDetailCell.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/24.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPostDetailCell.h"
#import "ZYPAttributeLabel.h"
#import "FFPostModel.h"
#import "FFPostDetailViewController.h"

@interface FFPostDetailCell ()
{
    FFPostItemModel *_model;
}
@end

@implementation FFPostDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _contLabel.isHtml = YES;
    _upImaegView.image = [_upImaegView.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, -5)];

}

- (void)updateCell:(FFPostItemModel *)model
{
    _model = model;
    _postButton.layer.masksToBounds = YES;
    _postButton.layer.cornerRadius = 5;
    _faceButton.layer.masksToBounds = YES;
    _faceButton.layer.cornerRadius = 10;
    _nameLabel.text = model.author;
    _contLabel.textcolor = HexColor(0x5a5a5a);
    _contLabel.textfont = [UIFont systemFontOfSize:14];
    _contLabel.text1 = model.message;
    [_contLabel autoSetDimension:ALDimensionHeight toSize:model.contentHeight];
    [_faceButton sd_setImageWithURL:[NSURL URLWithString:model.userImagePath] forState:UIControlStateNormal];
    _timeLabel.text = [NSString stringWithFormat:@"发表于 %@",model.dateline];

}

+ (CGFloat)getCellHeight:(FFPostItemModel *)model
{

    CGFloat height = 70;
    ZYPAttributeLabel *label = [[ZYPAttributeLabel alloc] init];
    label.isHtml = YES;
    CGSize size;
    if (model.message.length) size = [label sizeWithWidth:SCREEN_WIDTH - 20 attstr:model.message textFont:[UIFont systemFontOfSize:14]];
    
    if (model.isComment) {
        height += size.height + 12;
    } else {
        height += size.height + 52;
    }
    
    return height;
}

- (IBAction)clickPost:(id)sender
{
    ((FFPostDetailViewController *)self.nearsetViewController).boardView.top = 0;
    [((FFPostDetailViewController *)self.nearsetViewController).boardView.textView becomeFirstResponder];
}

- (IBAction)clickReport:(id)sender
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@/api/%@",url_submitarticle,_loginUser.username,_loginUser.signCode,_model.message];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            
            if ([response.payload[@"data"][@"status"] integerValue] == 1) {
                [USSuspensionView showWithMessage:@"举报成功"];
                
            } else {
                [USSuspensionView showWithMessage:@"举报失败"];
                
            }
        } else {
            [USSuspensionView showWithMessage:@"举报失败"];
        }
    }];


}
@end
