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
@property (nonatomic, assign) BOOL isMiss;

@end

@implementation FFPlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBackButtonDefault];
    self.title = @"主题";
    [self.view addSubview:self.switchView];
    
    self.controllerArray = @[[FFNewViewController viewController],[FFNewViewController viewController],[FFNewViewController viewController]];
    self.currentVC = self.controllerArray[0];
    [self updateUserInfo:0];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"板块";
}

- (void)viewWillDisappear:(BOOL)animated
{
    _isMiss = YES;
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
            [self updateUserInfo:index];
        }];
    }
    
    return _switchView;
}

- (void)updateUserInfo:(NSInteger)index
{
    NSString *type = @"latest";
    switch (index) {
            case 0:
            type = @"latest";
            break;
            
            case 1:
            type = @"hot";
            break;
            
            case 2:
            type = @"best";
            break;
            
        default:
            break;
    }
    ((FFNewViewController *)self.currentVC).type = type;
    ((FFNewViewController *)self.currentVC).forum_id = self.forum_id;
    ((FFNewViewController *)self.currentVC).isMiss = self.isMiss;

    [self addChildViewController:self.currentVC];
    [self.view insertSubview:self.currentVC.view belowSubview:self.switchView];
    [self.currentVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.currentVC.topConstraint.constant = _topInset + 35;
    [self.currentVC.view sizeLayoutToFit];
}


@end
