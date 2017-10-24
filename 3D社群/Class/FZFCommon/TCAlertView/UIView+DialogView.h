//
//  UIView+DialogView.h
//  HLMagic
//
//  Created by marujun on 13-11-29.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCShortAlertView.h"

#define defaultLeftButtonTitle   @"取消"
#define defaultRightButtonTitle  @"确认"

@interface UIView (DialogView) <TCShortAlertViewDelegate>

//简短提示信息
- (void)showAlertMessage:(NSString *)message callback:(void (^)(void))callback;
- (void)showAlertMessage:(NSString *)message originY:(float)originY callback:(void (^)(void))callback;

@end
