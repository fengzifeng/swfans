//
//  USSafariViewController.h
//  MCFriends
//
//  Created by marujun on 14-5-16.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USSafariViewController : MCViewController<UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *commonWebView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicatorView;
    
    __weak IBOutlet NSLayoutConstraint *_topConstraint;
}

@property (nonatomic, strong) NSString *url;

+ (instancetype)initWithUrl:(NSString *)url;
+ (instancetype)initWithTitle:(NSString *)title url:(NSString *)url;

@end
