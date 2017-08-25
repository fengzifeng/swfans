//
//  MCRootViewController.m
//  MCFriends
//
//  Created by fengzifeng on 14-4-22.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import "MCRootViewController.h"
#import "USNavDelegateHandler.h"
#import "USAuthViewController.h"

@interface MCRootViewController ()

@end

@implementation MCRootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _shouldRotate = NO;

    MCHomeViewController *homeViewController = [[MCHomeViewController alloc] initWithNibName:@"MCHomeViewController" bundle:nil];
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [_rootNavigationController setNavigationBarHidden:true animated:false];
    
//    [[Controller sharedController] setRootViewController:self];
//    [[Controller sharedController] setHomeViewController:homeViewController];
    
    [self addChildViewController:_rootNavigationController];
    [self.view addSubview:_rootNavigationController.view];
    [_rootNavigationController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.navigationBar.hidden = true;
    
    USNavDelegateHandler *handler = [[USNavDelegateHandler alloc] init];
    handler.navigationController = _rootNavigationController;
    _rootNavigationController.view.backgroundColor = [UIColor blackColor];
    _rootNavigationController.delegate = handler;
    _rootNavigationController.interactivePopGestureRecognizer.delegate = handler;

//    if(!_loginUser){
//        USAuthViewController *authViewController = [USAuthViewController viewController];
//        [_applicationContext presentNavigationController:authViewController animated:NO completion:nil];
//    }
}

//横屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (_shouldRotate) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
