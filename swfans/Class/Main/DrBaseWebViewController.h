//
//  DrBaseWebViewController.h
//  Driver
//
//  Created by fengzifeng on 15/5/5.
//  Copyright (c) 2015年 Driver. All rights reserved.
//
/**
 *  webview显示基类
 */

#import <UIKit/UIKit.h>

@interface DrBaseWebViewController : MCViewController <UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *drWebView;

@property (copy, nonatomic) void (^loadingFinish)(void);


- (void)webViewRequest:(NSString*)url;

- (void)showAppInApp:(NSString *)_appId;

+ (instancetype)initWithTitle:(NSString *)titleStr url:(NSString *)urlStr;

@end
