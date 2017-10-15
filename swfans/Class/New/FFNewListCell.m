//
//  FFNewListCell.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/16.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFNewListCell.h"
#import "FFNewListModel.h"

@interface FFNewListCell ()
{
    FFNewListItemModel*_currentModel;
}

@end

@implementation FFNewListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _upImaegView.image = [_upImaegView.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 7, -5)];


}

- (void)updateCell:(FFNewListItemModel *)model
{
    _currentModel = model;
    _faceButton.layer.masksToBounds = YES;
    _faceButton.layer.cornerRadius = 10;
    [_faceButton sd_setImageWithURL:[NSURL URLWithString:model.userImagePath] forState:UIControlStateNormal];
    _nameLabel.text = model.author;
    [_typeLabel setTitle:model.forumName forState:UIControlStateNormal];
    _upLabel.text = model.subject;
    NSString *str = [HLTool timeInfoWithDateString:model.dateline];
    _timeLabel.text = str;
    if (model.replies.length) {
        _replyLabel.text = [NSString stringWithFormat:@"评论 %@",model.replies];
    } else {
        _replyLabel.text = @"";
    }
    _picImaegView.backgroundColor = [UIColor yellowColor];
    NSArray *array = [[self class] getImageurlFromHtml:model.message];
    if (array.count) {
        NSString *image = array[0];
        [_picImaegView sd_setImageWithURL:[NSURL URLWithString:image]];
        [_picImaegView autoSetDimension:ALDimensionHeight toSize:(SCREEN_WIDTH-20)*337/600.0];
        _picImaegView.hidden = NO;
        [_upLabel autoSetDimension:ALDimensionHeight toSize:_currentModel.height - 70 - 5 - (SCREEN_WIDTH-20)*337/600.0];

    } else {
        [_upLabel autoSetDimension:ALDimensionHeight toSize:_currentModel.height - 70];
        [_picImaegView autoSetDimension:ALDimensionHeight toSize:0];

        _picImaegView.hidden = YES;
    }
    [self setNeedsLayout];
}

+ (NSArray *) getImageurlFromHtml:(NSString *) webString
{
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    
    //标签匹配
    NSString *parten = @"<img(.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length] - 1)];
    
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];
        
        
        //从图片中的标签中提取ImageURL
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:imagekUrl];
    }
    
    return imageurlArray;
}


- (void)layoutSubviews
{
    if (!_currentModel) return;
    
    CGFloat typeWidth = [_currentModel.forumName stringWidthWithFont:_typeLabel.titleLabel.font height:11] + 3;
    [_typeLabel autoSetDimension:ALDimensionWidth toSize:typeWidth];
//    CGFloat replyWidth = [_replyLabel.text stringWidthWithFont:_replyLabel.font height:11] + 2;
//    [_replyLabel autoSetDimension:ALDimensionWidth toSize:replyWidth];
}


- (IBAction)clcikType:(id)sender
{

}

@end
