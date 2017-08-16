//
//  RootViewController.m
//  MCFriends
//
//  Created by fengzifeng on 14-3-16.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import "MCHomeViewController.h"
#import "MCEastViewController.h"
#import "MCAboutMeViewController.h"
#import "MCLiveViewController.h"
#import "MCNewsViewController.h"

@interface MCHomeViewController ()
{
    NSArray *navArray ;
}
@end

@implementation MCHomeViewController
@synthesize currentViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
        _selectedIndex = -1;
        navArray = @[[self viewControllerWithClass:[MCNewsViewController class]],  //
                     [self viewControllerWithClass:[MCLiveViewController class]],    //
                     [self viewControllerWithClass:[MCEastViewController class]], //
                     [self viewControllerWithClass:[MCAboutMeViewController class]], //
                     ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [_tabBarView setBlurColor:[UIColor whiteColor]];
    [_tabLineLabel autoSetDimension:ALDimensionHeight toSize:0.5];
    
    [self tabButtonAction:_tabButtonCollection[0]];
}


- (UIViewController *)viewControllerWithClass:(Class)class
{
    return [[class alloc] initWithNibName:NSStringFromClass(class) bundle:nil];
}

- (void)swithchTapIndex:(NSInteger)index
{
    if (_selectedIndex == index) {
        return;
    }
    
    [currentViewController.view removeFromSuperview];
    [currentViewController removeFromParentViewController];
    
    _selectedIndex = index;
    
    currentViewController = [navArray objectAtIndex:index];
    [self addChildViewController:currentViewController];
    [self.view insertSubview:currentViewController.view belowSubview:_tabBarView];
    [currentViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [currentViewController initNavigationBar];

    for (UIButton *item in _tabButtonCollection) {
        item.selected = index==item.tag;
    }
}

- (IBAction)tabButtonAction:(UIButton *)sender
{
    UIViewController *tmpVC = [navArray objectAtIndex:sender.tag];
    if ([currentViewController isEqual:tmpVC]) {
        [currentViewController updateDisplay];
        return;
    }
    
    [self swithchTapIndex:sender.tag];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
