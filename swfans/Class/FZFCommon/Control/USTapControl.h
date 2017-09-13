//
//  USTapControl.h
//  USEvent
//
//  Created by marujun on 15/9/22.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USTapControl : UIControl

@property (nonatomic, assign) BOOL disableGesture;

- (instancetype)initWithView:(UIView *)view;

- (void)addTarget:(id)target action:(SEL)action;

@end
