//
//  UMFeedbackTableCell.m
//  MCFriends
//
//  Created by fengzifeng on 14-8-19.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import "UMFeedbackTableCell.h"

@implementation UMFeedbackTableCell
{
    UIWebView * phoneCallWebView ;
}

- (void)awakeFromNib
{
    timeLabel.layer.cornerRadius = 4;
    timeLabel.layer.masksToBounds = YES;
    timeLabel.backgroundColor = RGBCOLOR(224, 224, 224);
    
    avatarButton.layer.cornerRadius = 3;
    avatarButton.layer.masksToBounds = true;
    
    bubbleImageView.userInteractionEnabled = YES;
    contentLabel.delegate = self;
}

+ (float)maxLabelWidth
{
    return SCREEN_WIDTH-(41+(60+20+13))*WindowZoomScale;
}

- (void)initWithData:(NSDictionary *)data indexPath:(NSIndexPath *)indexPath
{
    BOOL isMyMsg = ![data[@"type"] isEqualToString:@"dev_reply"];
    
    //因为iOS7.0版本的BUG，导致图片变大的时候无法正确渲染；暂时使用图片代替，iOS7.1已修复
    //_bubbleImageView.image = self.bubbleImage;
    //_bubbleImageView.tintColor =
    
    UIImage *bubbleImage = nil;
    if (isMyMsg) {
        bubbleImage = [UIImage imageNamed:[NSString stringWithFormat:@"chat_bubble_right_%@_bg.png",@"0x18b4ed"]];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 26)];
    } else {
        bubbleImage = [UIImage imageNamed:[NSString stringWithFormat:@"chat_bubble_left_%@_bg.png",@"0xf1f1f1"]];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(16, 26, 16, 16)];
    }
    bubbleImageView.image = bubbleImage;
    
    timeLabel.text = [data[@"date"] string];
    
    int maxLabelWidth = [[self class] maxLabelWidth];
    
    MatchParser *match = [[self class] matchText:data[@"content"] width:maxLabelWidth Font:15 isMine:isMyMsg];

    contentLabel.match = match;
    float lblWidth = match.miniWidth;
    float popWidth = lblWidth + 20 + 13;
    
    float relativeHeight = match.height;
    float popHeight = relativeHeight + 20;
    
    CGRect indicatorRect = indicatorView.frame;
    if (isMyMsg) {
        //我的头像，显示在右侧
        NSString *avatarUrl = nil;
        avatarButton.frame = CGRectMake(SCREEN_WIDTH - 10 - 40, 0, 40, 40);
        
        float popX = SCREEN_WIDTH - 60 - popWidth;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.frame = CGRectMake(popX + 13, 10, lblWidth, relativeHeight);
        bubbleImageView.frame = CGRectMake(popX, 0, popWidth, popHeight);
        
        indicatorRect.origin.x = popX-indicatorRect.size.width-5;
    } else {
        //别人头像，显示在左侧
        [avatarButton setImage:[UIImage defaultAvatar] forState:UIControlStateNormal];
        avatarButton.frame = CGRectMake(10, 0, 40, 40);
        
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.frame = CGRectMake(70 + 13, 10, lblWidth, relativeHeight);
        bubbleImageView.frame = CGRectMake(60, 0, popWidth, popHeight);
        
        indicatorRect.origin.x = 60+popWidth+5;
    }

    indicatorView.frame = indicatorRect;
    
    if ([data[@"is_failed"] boolValue]) {
        [indicatorView startAnimating];
    }else{
        [indicatorView stopAnimating];
    }
    
    CGRect rect = chatContentView.frame;
    rect.size.height = popHeight;
    chatContentView.frame = rect;
}

+ (MatchParser *)matchText:(NSString *)text width:(float)width Font:(float)font isMine:(BOOL)isMine
{
    MatchParser *match = [[MatchParser alloc] init];
    match.width = width;
    if (isMine) {
        match.textColor = [UIColor whiteColor];
    }else{
        match.textColor = [UIColor blackColor];
    }
    match.font = [UIFont systemFontOfSize:font];
    match.mobieLink = true;
    match.phoneLink = true;
    [match match:text];
    
    return match;
}


+ (float)heightWithData:(NSDictionary *)data
{
    int maxLabelWidth = [self maxLabelWidth];
    BOOL isMyMsg = ![data[@"type"] isEqualToString:@"dev_reply"];
    MatchParser *match = [self matchText:data[@"content"] width:maxLabelWidth Font:15 isMine:isMyMsg];
    
    return match.height + 20 + 50;
}

@end
