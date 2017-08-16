//
//  FFNewViewController.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/16.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFNewViewController.h"

@interface FFNewViewController ()

@end

@implementation FFNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"最新";
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
