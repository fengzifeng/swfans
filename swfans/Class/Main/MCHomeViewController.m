//
//  RootViewController.m
//  MCFriends
//
//  Created by fengzifeng on 14-3-16.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import "MCHomeViewController.h"
#import "MCAboutMeViewController.h"
#import "FFNewViewController.h"
#import "FFPlateViewController.h"
#import "FFActivityViewController.h"
#import "MCHVButton.h"
#import "FFInputePostViewController.h"
#import "FFPlateDetailViewController.h"

@interface MCHomeViewController ()
{
    NSArray *navArray;
}
@end

@implementation MCHomeViewController
@synthesize currentViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedIndex = -1;
        navArray = @[[self viewControllerWithClass:[FFNewViewController class]],  //
                     [self viewControllerWithClass:[FFPlateDetailViewController class]],    //
                     @"",
                     [self viewControllerWithClass:[FFActivityViewController class]], //
                     [self viewControllerWithClass:[MCAboutMeViewController class]], //
                     ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    unreadPlate.layer.masksToBounds = YES;
    unreadPlate.layer.cornerRadius = 4;
    unreadActive.layer.masksToBounds = YES;
    unreadActive.layer.cornerRadius = 4;

    int i = 0;
    for (MCHVButton *item in _tabButtonCollection) {
        
        if (i == 2) {
            item.image_size = CGSizeMake(43, 43);
        } else {
            item.image_size = CGSizeMake(23, 22.5);
        }        
        i++;
    }
    

    
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
    
    
    if (index == 2) {
        if (_loginUser) {
            FFInputePostViewController *vc = [FFInputePostViewController viewController];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [self swithchTapIndex:4];
        }
    } else {
        if (index == 1) {
            unreadPlate.hidden = YES;
        } else if (index == 3) {
            unreadActive.hidden = YES;
        }
        
        for (UIButton *item in _tabButtonCollection) {
            item.selected = index==item.tag;
        }
        
        [currentViewController.view removeFromSuperview];
        [currentViewController removeFromParentViewController];
        
        _selectedIndex = index;
        
        currentViewController = [navArray objectAtIndex:index];
        [self addChildViewController:currentViewController];
        [self.view insertSubview:currentViewController.view belowSubview:_tabLineLabel];
        [currentViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [currentViewController initNavigationBar];
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
