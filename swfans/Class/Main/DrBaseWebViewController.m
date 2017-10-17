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
    [self.drWebView setDelegate:nil];
    [self.drWebView stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationBackButtonDefault];
    self.title = @"抽奖";
    [self prepareWebView];
    [self webViewRequest:self.requestURL];

//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:path];
//    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
//                                                          ofType:@"html"];
//    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
//                                                    encoding:NSUTF8StringEncoding
//                                                       error:nil];
    
    
//    [self.drWebView loadHTMLString:self.requestURL baseURL:baseURL];
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



- (void)webViewDidFinishLoad:(UIWebView *)webView{

}




+ (instancetype)initWithTitle:(NSString *)titleStr url:(NSString *)urlStr
{
    DrBaseWebViewController *vc = [[DrBaseWebViewController alloc] init];
    vc.requestURL = urlStr;

    
    return vc;
}
/**
 *  初始化webview
 */
- (void)prepareWebView{
    if (nil == _drWebView) {

        _drWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
}

//设置header，打开cookie
+(NSMutableURLRequest *)requestAfterSetHeaderAndCookie:(NSURL*)url
{
    NSMutableURLRequest *aRequest = [[NSMutableURLRequest alloc] init];
    [aRequest setURL:url];
    
//    [aRequest setHTTPShouldHandleCookies:YES];

//    设置请求header
//    [DrBaseNetworkManager requestEncryption:aRequest];
//    
    
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
    
    
//
//    [DrBaseWebViewController requestAfterSetHeaderAndCookie:request.URL];

//    NSString *requestUrl = [self URLDecodedString:[request URL].absoluteString];
    
    return YES;
    
}




@end
