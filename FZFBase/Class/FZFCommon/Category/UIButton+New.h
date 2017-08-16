//
//  UIButton+New.h
//  HLMagic
//
//  Created by marujun on 13-12-6.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (New)

//蓝色箭头的返回按钮
+ (UIButton *)newBackArrowNavButtonWithTarget:(id)target action:(SEL)action;

//底色为透明的按钮
+ (UIButton *)newClearNavButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

//更多按钮
+ (UIButton *)newMoreButtonWithTarget:(id)target action:(SEL)action;

@end
