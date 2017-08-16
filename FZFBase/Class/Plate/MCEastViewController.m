//
//  MCMessageViewController.m
//  MCFriends
//
//  Created by 马汝军 on 14-3-16.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MCEastViewController.h"
#import "FSCycleCrollView.h"
#import "DrBaseWebViewController.h"

@interface MCEastViewController ()

@end

@implementation MCEastViewController


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
    DrBaseWebViewController *safarVC = [DrBaseWebViewController initWithTitle:@"直播" url:@"www.baidu.com"];
    [self addChildViewController:safarVC];
    
    [self.view addSubview:safarVC.view];
    
    [safarVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
//    FSCycleCrollView *cycleView = [FSCycleCrollView showCycleScrollView:@[[UIView new],[UIView new],[UIView new],[UIView new],[UIView new]]];
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, cycleView.width, cycleView.height)];
//    [headView addSubview:cycleView];
//    
//    [self.view addSubview:headView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
 }

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"EAST";
}



@end
