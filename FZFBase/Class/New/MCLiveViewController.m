//
//  MCFindViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/7.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCLiveViewController.h"

@interface MCLiveViewController ()

@end

@implementation MCLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"直播";
}


- (void)requestData
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://businessapitest.58v5.cn/jxbus/list"];
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:@{@"jxid":@"869846979897745408"} complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            
        } else {
        }
    }];
    
}

@end
