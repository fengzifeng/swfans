//
//  ApplicationContext.m
//  USEvent
//
//  Created by marujun on 15/9/14.
//  Copyright (c) 2015年 MaRuJun. All rights reserved.
//

#import "ApplicationContext.h"
#import "AppDelegate.h"

@interface ApplicationContext ()
{
    UINavigationController *presentNavigationController;
}

@end

@implementation ApplicationContext

+ (instancetype)sharedContext
{
    static ApplicationContext *sharedContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContext = [[self alloc] init];
    });
    return sharedContext;
}

- (CGFloat)height
{
    return self.rootViewController.view.frame.size.height;
}

- (MCRootViewController *)rootViewController
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] rootViewController];
}

- (UINavigationController *)navigationController
{
    return self.rootViewController.rootNavigationController;
}

- (MCHomeViewController *)homeViewController
{

    return (MCHomeViewController *)self.navigationController.viewControllers.firstObject;
}

- (void)presentNavigationController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if(presentNavigationController){
        [self removePresentNavigationController];
    }
    
    presentNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [presentNavigationController setNavigationBarHidden:true animated:false];
    
    [self.rootViewController.view addSubview:presentNavigationController.view];
    [self.rootViewController addChildViewController:presentNavigationController];
    [presentNavigationController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    if(animated){
        CGFloat viewHeight = presentNavigationController.view.bounds.size.height;
        [presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:viewHeight];
        [presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-viewHeight];
        [self.rootViewController.view layoutIfNeeded];
        
        [UIView animateWithDuration:0.5
                              delay:0.f
             usingSpringWithDamping:1.f
              initialSpringVelocity:1.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
                             [presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
                             [self.rootViewController.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             if (completion) completion();
                         }];
    } else {
        if (completion) completion();
    }
}

- (void)removePresentNavigationController
{
    [presentNavigationController.view removeFromSuperview];
    [presentNavigationController removeFromParentViewController];
    
    presentNavigationController = nil;
}

- (void)dismissNavigationControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (!animated) {
        [self removePresentNavigationController];
        if (completion) completion();
        return;
    }
    
    CGFloat viewHeight = presentNavigationController.view.bounds.size.height;
    [UIView animateWithDuration:0.5
                          delay:0.f
         usingSpringWithDamping:1.f
          initialSpringVelocity:1.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:viewHeight];
                         [presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-viewHeight];
                         [self.rootViewController.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self removePresentNavigationController];
                         if (completion) completion();
                     }];
}

@end
