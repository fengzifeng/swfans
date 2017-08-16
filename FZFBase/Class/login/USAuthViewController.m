//
//  USAuthViewController.m
//  USEvent
//
//  Created by fengzifeng on 15/9/15.
//  Copyright (c) 2015年 fengzifeng. All rights reserved.
//

#import "USAuthViewController.h"

@interface USAuthViewController ()
{
}

@end

@implementation USAuthViewController

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
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"登录注册";
    self.navigationBar.hidden = YES;
    
}

- (IBAction)login:(id)sender
{
    
    [AuthData loginSuccess:@{@"uid":@"1"}];

    [_applicationContext dismissNavigationControllerAnimated:YES completion:nil];


}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
