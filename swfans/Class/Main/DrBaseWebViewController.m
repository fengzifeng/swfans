//
//  DrBaseWebViewController.m
//  Driver
//
//  Created by fengzifeng on 15/5/5.
//  Copyright (c) 2015年 Driver. All rights reserved.
//

#import "DrBaseWebViewController.h"
#import <StoreKit/StoreKit.h>
#import "UIImage+GIF.h"
#import "DrBaseNetworkManager+NetworkTool.h"


@interface DrBaseWebViewController () <SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) NSString *requestURL;// 请求时的URL

/**
 *  初始化webview
 */
- (void)prepareWebView;


/**
 *  webview刷新
 */
- (void)webViewReload;


@end

@implementation DrBaseWebViewController


- (void)dealloc{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.drWebView setDelegate:nil];
    [self.drWebView stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self prepareWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}


// UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _drWebView.hidden = NO;
    _loadingFinish?_loadingFinish():nil;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if ([error code] == NSURLErrorCancelled)
    {
        return;
    }
   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

+ (instancetype)initWithTitle:(NSString *)titleStr url:(NSString *)urlStr
{
    DrBaseWebViewController *vc = [[DrBaseWebViewController alloc] init];
    [vc webViewRequest:urlStr];
    
    return vc;
}
/**
 *  初始化webview
 */
- (void)prepareWebView{
    if (nil == _drWebView) {

        _drWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _drWebView.delegate = self;
        [_drWebView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
         UIViewAutoresizingFlexibleWidth |
         UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleTopMargin |
         UIViewAutoresizingFlexibleHeight |
         UIViewAutoresizingFlexibleBottomMargin];
//        drWebView.scalesPageToFit = YES;
        [self.view addSubview:_drWebView];
    }
}

/**
 *  webview请求
 *
 *  @param url
 */
- (void)webViewRequest:(NSString*)urlString{
    
    if (nil == urlString || [urlString length] < 1) return;
    
    self.requestURL = urlString;
    
    [_drWebView loadRequest:[DrBaseWebViewController requestAfterSetHeaderAndCookie:[NSURL URLWithString:urlString]]];
     _drWebView.hidden = NO;
}

//设置header，打开cookie
+(NSMutableURLRequest *)requestAfterSetHeaderAndCookie:(NSURL*)url
{
    NSMutableURLRequest *aRequest = [[NSMutableURLRequest alloc] init];
    [aRequest setURL:url];
    
    [aRequest setHTTPShouldHandleCookies:YES];

//    设置请求header
    [DrBaseNetworkManager requestEncryption:aRequest];
    
    
    return aRequest;
}


/**
 *  webview刷新
 */
- (void)webViewReload{
    
    if ([self.drWebView.request.URL.absoluteString length] > 0) {
        
        [self.drWebView reload];
        _drWebView.hidden = NO;
    }else{
    
        [self webViewRequest:self.requestURL];
    }
}


#pragma mark-UIWebViewDelegate 增加与JS的交互方法

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    
    [DrBaseWebViewController requestAfterSetHeaderAndCookie:request.URL];

    NSString *requestUrl = [self URLDecodedString:[request URL].absoluteString];
    
    return YES;
    
}

-(NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


- (void)showAppInApp:(NSString *)_appId {
    if (!_appId) return;
    //iOS6以后，苹果提供了在应用内部打开App Store中某一个应用下载页面的方式，提供了 SKStoreProductViewController类进行支持
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    if (isAllow != nil) {
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        sKStoreProductViewController.delegate = self;
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: _appId}
                                                completionBlock:^(BOOL result, NSError *error) {
                                                    if (result) {
                                                                                                            }
                                                    else{
                                                        NSLog(@"%@",error);
                                                    }
                                                }];
    }
    
    return;
}

//#pragma mark - SKStoreProductViewControllerDelegate

//对视图消失的处理
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    
    [viewController dismissViewControllerAnimated:YES
                                       completion:nil];
    
    
}

@end
