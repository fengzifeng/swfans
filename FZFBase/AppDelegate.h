//
//  AppDelegate.h
//  FZFBase
//
//  Created by fengzifeng on 16/6/2.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMFeedback.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UMFeedbackDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MCRootViewController *rootViewController;


@end

