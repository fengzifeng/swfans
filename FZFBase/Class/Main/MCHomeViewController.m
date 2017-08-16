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
                     [self viewControllerWithClass:[FFPlateViewController class]],    //
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
    
    int i = 0;
    for (MCHVButton *item in _tabButtonCollection) {
        
        switch (i) {
            case 0:
                item.image_size = CGSizeMake(23, 19.5);
                break;
            case 1:
                item.image_size = CGSizeMake(21, 21);
                break;

            case 2:
                item.image_size = CGSizeMake(43, 43);
                break;
            case 3:
                item.image_size = CGSizeMake(10, 21.5);

                break;
            case 4:
                item.image_size = CGSizeMake(23, 22.5);
                break;
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
    
    
    for (UIButton *item in _tabButtonCollection) {
        item.selected = index==item.tag;
    }
    
    if (index == 2) {
        return;
    } else {
        [currentViewController.view removeFromSuperview];
        [currentViewController removeFromParentViewController];
        
        _selectedIndex = index;
        
        currentViewController = [navArray objectAtIndex:index];
        [self addChildViewController:currentViewController];
        [self.view insertSubview:currentViewController.view belowSubview:_tabBarView];
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
