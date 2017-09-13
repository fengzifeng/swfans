//
//  USTapControl.h
//  USEvent
//
//  Created by fengzifeng on 15/9/22.
//  Copyright © 2015年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USTapControl : UIControl

@property (nonatomic, assign) BOOL disableGesture;

- (instancetype)initWithView:(UIView *)view;

- (void)addTarget:(id)target action:(SEL)action;

@end
