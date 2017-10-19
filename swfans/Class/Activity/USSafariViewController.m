//
//  USSafariViewController.m
//  MCFriends
//
//  Created by marujun on 14-5-16.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "USSafariViewController.h"
//#import "WebViewJavascriptBridge.h"

@interface USSafariViewController ()
{
//    WebViewJavascriptBridge *_bridge;
    
    NSString *_shareUrl;
    NSString *_shareTitle;
    NSString *_shareIcon;
}

@end

@implementation USSafariViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (instancetype)initWithUrl:(NSString *)url
{
    return [self initWithTitle:@"" url:url];
}

+ (instancetype)initWithTitle:(NSString *)title url:(NSString *)url
{
    USSafariViewController *safariVC = [[USSafariViewController alloc] initWithNibName:@"USSafariViewController" bundle:nil];
    safariVC.url = url;
    safariVC.title = title;
    return safariVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _topConstraint.constant = _topInset + 13;
    
    [self setNavigationBackButtonDefault];
    
    if (!_url || !_url.length) {
        return;
    }
    
//    //加载本地文件
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:_url]) {
//        [self startLoadURL:[NSURL fileURLWithPath:_url]];
//        return;
//    }

    //加载网络资源
//    if ([_url hasSuffix:@".jpg"] || [_url hasSuffix:@".png"]) {
//        //加载本地缓存中的图片
//        NSString *filePath = [UIImage diskCachePathWithURL:_url];
//        NSString *jpgPath = [filePath stringByAppendingString:@".jpg"];
//
//        if ([fileManager fileExistsAtPath:jpgPath]) {
//            [self startLoadURL:[NSURL fileURLWithPath:jpgPath]];
//        }else{
//            [activityIndicatorView startAnimating];
//            [UIImage imageWithURL:_url callback:^(UIImage *image) {
//                [fileManager moveItemAtPath:filePath toPath:jpgPath error:nil];
//                [self startLoadURL:[NSURL fileURLWithPath:jpgPath]];
//            }];
//        }
//        return;
//    }
    
    if (![_url hasPrefix:@"http"]) {
        _url = [NSString stringWithFormat:@"http://%@",_url];
    }
    [self startLoadURL:[NSURL URLWithString:_url]];
    
    NSURL *urlObj = [NSURL URLWithString:_url];
//    if (![urlObj.host hasSuffix:MocaHostSuffix]) {
//        [self startLoadURL:urlObj];
//
//        return;
//    }
    
    //只有官方链接才提供桥接功能
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:commonWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//
//        FLOG(@"WebViewJavascriptBridge received message: %@",data);
//        if ([data isKindOfClass:[NSDictionary class]] && data[@"title"] && data[@"url"]) {
//
//        }else{
//            responseCallback?responseCallback(@{@"success":@(NO)}):nil;
//        }
//    }];
//    [_bridge registerHandler:@"UserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
//        responseCallback(_loginUser?[_loginUser dictionary]:@{});
//    }];
//    [_bridge registerHandler:@"DeviceInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
//        responseCallback([UIDevice BIData]);
//    }];
//    [_bridge registerHandler:@"PushView" handler:^(id data, WVJBResponseCallback responseCallback) {
//        if (data && [data isKindOfClass:[NSString class]]) {
//            Class class = NSClassFromString(data);
//            UIViewController *viewController = [[class alloc] initWithNibName:NSStringFromClass(class) bundle:nil];
//            [self.navigationController pushViewController:viewController animated:YES];
//            responseCallback?responseCallback(@{@"success":@(YES)}):nil;
//        }
//    }];
//    [_bridge registerHandler:@"PopView" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [self.navigationController popViewControllerAnimated:true];
//        responseCallback?responseCallback(@{@"success":@(YES)}):nil;
//    }];
//    [_bridge registerHandler:@"CallInterface" handler:^(id data, WVJBResponseCallback responseCallback) {
//        if (data && [data isKindOfClass:[NSDictionary class]]) {
//            [NetManager postRequestToUrl:data[@"url"] params:data[@"params"] complete:^(BOOL successed, id result) {
//                responseCallback?responseCallback(@{@"success":@(successed),@"result":result}):nil;
//            }];
//        }
//    }];
//    [_bridge registerHandler:@"SetUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
//        if (data && [data isKindOfClass:[NSDictionary class]] && _loginUser) {
//            data[@"avatar"]?_loginUser.avatar = data[@"avatar"]:nil;
//            data[@"birthday"]?_loginUser.birthday = data[@"birthday"]:nil;
//            data[@"nickname"]?_loginUser.nickname = data[@"nickname"]:nil;
//
//            [_loginUser synchronize];
//
//            responseCallback?responseCallback(@{@"success":@(YES),@"info":[_loginUser dictionary]}):nil;
//        }else{
//            responseCallback?responseCallback(@{@"success":@(NO)}):nil;
//        }
//    }];
//
    [self startLoadURL:urlObj];
}

- (void)startLoadURL:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [commonWebView loadRequest:request];
    [commonWebView setScalesPageToFit:true];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!self.title || !self.title.length) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    [activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    FLOG(@"网页加载失败 Error : %@",error);
}

@end
