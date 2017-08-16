//
//  UIButton+New.m
//  HLMagic
//
//  Created by marujun on 13-12-6.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import "UIButton+New.h"

@implementation UIButton (New)


//蓝色箭头的返回按钮
+ (UIButton *)newBackArrowNavButtonWithTarget:(id)target action:(SEL)action
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
//    [rightButton setTitleColor:RGBCOLOR(1, 113, 239) forState:UIControlStateNormal];
    [rightButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    
//    [rightButton setImage:[UIImage imageNamed:(@"pub_nav_back.png")] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:(@"pub_nav_white_back.png")] forState:UIControlStateNormal];
    [rightButton setTitleColor:RGBCOLOR(136, 136, 136) forState:UIControlStateHighlighted];
    if (action && target) {
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return rightButton;
}

+ (UIButton *)newClearNavButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    float height = 44;
    UIFont *font = [UIFont systemFontOfSize:16];
    float width = [title stringWidthWithFont:font height:height];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width + 5, height)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.titleLabel.font = font;
    
    [rightButton setTitle:title forState:UIControlStateNormal];
//    [rightButton setTitleColor:RGBCOLOR(1, 113, 239) forState:UIControlStateNormal];
    [rightButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    if (action && target) {
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return rightButton;
}

+ (UIButton *)newMoreButtonWithTarget:(id)target action:(SEL)action
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [rightButton setContentEdgeInsets:UIEdgeInsetsMake(19, 16, 20, 8)];
    [rightButton setImage:[UIImage imageNamed:(@"chat_omitb_white.png")] forState:UIControlStateNormal];
    if (action && target) {
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return rightButton;
}

@end
