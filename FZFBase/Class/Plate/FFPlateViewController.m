//
//  FFPlateViewController.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/16.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPlateViewController.h"
#import "FFSwitchView.h"
#import "FFNewViewController.h"

@interface FFPlateViewController ()

@property (nonatomic, strong) FFSwitchView *switchView;
@property (nonatomic, strong) FFNewViewController *currentVC;
@property (nonatomic, strong) NSArray *controllerArray;

@end

@implementation FFPlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBackButtonDefault];

    [self.view addSubview:self.switchView];
    
    self.controllerArray = @[[FFNewViewController viewController],[FFNewViewController viewController],[FFNewViewController viewController]];
    self.currentVC = self.controllerArray[0];
    [self updateUserInfo];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"板块";
}

- (FFNewViewController *)viewControllerWithClassFromXib:(Class)class
{
    FFNewViewController *vc = [[class alloc] initWithNibName:NSStringFromClass(class) bundle:nil];
    return vc;
}

- (FFSwitchView *)switchView
{
    if (!_switchView) {
        _switchView = [FFSwitchView showSwitchView:^(NSInteger index) {
            
            [self.currentVC removeFromParentViewController];
            [self.currentVC.view removeFromSuperview];
            self.currentVC = _controllerArray[index];
            [self updateUserInfo];
        }];
    }
    
    return _switchView;
}

- (void)updateUserInfo
{
    [self addChildViewController:self.currentVC];
    [self.view insertSubview:self.currentVC.view belowSubview:self.switchView];
    [self.currentVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.currentVC.topConstraint.constant = 64 + 35;
    [self.currentVC requestData];
    [self.currentVC.view sizeLayoutToFit];
}


@end
