//
//  FFNavigationBar.m
//  swfans
//
//  Created by fengzifeng on 2017/9/22.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFNavigationBar.h"

@implementation FFNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    if (ShortSystemVersion >= 11.0) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 64);
        if (IS_IPHONE_X) self.height = 88;
        for (UIView *view in self.subviews) {
            if([NSStringFromClass([view class]) containsString:@"Background"]) {
                view.frame = self.bounds;
            }
            else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
                CGRect frame = view.frame;
                frame.origin.y = 20;
                if (IS_IPHONE_X) frame.origin.y = 44;

                frame.size.height = self.bounds.size.height - frame.origin.y;
                view.frame = frame;
            }
        }
    }
}

@end
