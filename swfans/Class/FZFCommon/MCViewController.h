//
//  MCViewController.h
//  FrictionMakingFriends
//
//  Created by fengzifeng on 14-3-11.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "USTransitionAnimator.h"
#import "FFNavigationBar.h"

@interface MCViewController : UIViewController
<UITableViewDataSource, UITableViewDataSource>
{
    float _topInset;
    USNavigationTransitionOption _transitionOption;
}
//
@property(nonatomic, assign) float topInset;
//@property(nonatomic, strong) NSString *requestIngURL;
//
@property(nonatomic, strong) FFNavigationBar *navigationBar;
@property(nonatomic, strong) UINavigationItem *myNavigationItem;
@property(nonatomic, strong) UIView *amsNavigationBar;
@property (nonatomic, assign) USNavigationTransitionOption transitionOption;
@property (nonatomic, assign) BOOL enableScreenEdgePanGesture;

//
- (void)updateDisplay;
- (void)initNavigationBar;

- (void)initAmsNavigationBar;
//
//#pragma mark- scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (UIViewController *)viewControllerWillPushForLeftDirectionPan;

+ (instancetype)viewController;

@end
