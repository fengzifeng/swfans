//
//  MCRootViewController.h
//  MCFriends
//
//  Created by fengzifeng on 14-4-22.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCHomeViewController.h"

@interface MCRootViewController : MCViewController

//是否可以旋转屏幕
@property (assign ,nonatomic) BOOL shouldRotate;
@property (strong ,nonatomic) UINavigationController *rootNavigationController;


@end
