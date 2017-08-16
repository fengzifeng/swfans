//
//  MCNewsBaseViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.

#import "MCNewsDetailBottomCell.h"
#import "MCDetailPageViewController.h"
#import "WebViewJavascriptBridge.h"
#import "MCImageInfo.h"
#import "MCVideoInfo.h"

#define kNewsDetailControllerClose (self.tableView.contentOffset.y - (self.tableView.contentSize.height - SCREEN_HEIGHT + 55) > (100 - 54))

@interface MCDetailPageViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy)NSMutableString *requestUrlString;
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)WebViewJavascriptBridge *bridge;
@property (strong, nonatomic)  UITableView *tableView;

@property (nonatomic, copy)NSString *detailID;

@property(nonatomic,strong)MCNewsDetailBottomCell *closeCell;
@property(nonatomic,strong) NSArray *news;

@property(nonatomic,strong)UIImageView *bigImg;
@property(nonatomic,strong)NSDictionary *temImgPara;
@property(nonatomic,strong)UIView *hoverView;

@end

@implementation MCDetailPageViewController

- (NSArray *)news
{
    if (_news == nil) {
        _news = [NSArray array];
        _news = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewsURLs.plist" ofType:nil]];
    }
    return _news;
}

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 700)];
        _webView = web;
    }
    return _webView;
}

//- (SXNewsDetailViewModel *)viewModel
//{
//    if (!_viewModel) {
//        _viewModel = [[SXNewsDetailViewModel alloc]init];
//    }
//    return _viewModel;
//}

#pragma mark - ******************** lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBackButtonDefault];
    self.title = @"新闻详情";
    self.webView.delegate = self;
    self.hoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.hoverView.backgroundColor = [UIColor blackColor];
    
    _tableView = [[UITableView alloc] initForAutoLayout];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(_topInset, 0, 0, 0)];
    [self initJSbirdge];
    [self setupRequest];
}

- (void)initJSbirdge {
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
}

- (void)setupRequest {
    
    self.detailID = @"AQ72N9QG00051CA1";//一张图片
    self.detailID = @"AQ4RPLHG00964LQ9";//多张图片
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://c.m.163.com/nc/article/xukunhenwuliao/full.html"];
    [urlStr replaceOccurrencesOfString:@"xukunhenwuliao" withString:_detailID options:NSCaseInsensitiveSearch range:[urlStr rangeOfString:@"xukunhenwuliao"]];
    [NetManager getRequestToUrl:urlStr params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            [self setupWebViewByData:response.payload];
        } else {
        }
    }];
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark - ******************** webView + html

- (void)setupWebViewByData:(id)data {
    
    if (data!= nil) {
        
        //解析的字典
        NSDictionary *dic = (NSMutableDictionary *)data;
        NSDictionary *bodyDic = [dic objectForKey:_detailID];
        NSMutableString *bodyStr = [[NSMutableString alloc] initWithString:[bodyDic objectForKey:@"body"]];
        
        //写一段接收主标题的html字符串,直接拼接到字符串
        NSMutableString *titleStr= [bodyDic objectForKey:@"title"];
        NSMutableString *sourceStr = [bodyDic objectForKey:@"source"];
        NSMutableString *ptimeStr = [bodyDic objectForKey:@"ptime"];
        
        NSMutableString *allTitleStr =[NSMutableString stringWithString:@"<style type='text/css'> p.thicker{font-weight: 900}p.light{font-weight: 0}p{font-size: 108%}h2 {font-size: 120%}h3 {font-size: 80%}</style> <h2 class = 'thicker'>xukun</h2><h3>hehe    lala</h3>"];
        
        [allTitleStr replaceOccurrencesOfString:@"xukun" withString:titleStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"xukun"]];
        [allTitleStr replaceOccurrencesOfString:@"hehe" withString:sourceStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"hehe"]];
        [allTitleStr replaceOccurrencesOfString:@"lala" withString:ptimeStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"lala"]];
        
        NSArray *imageArray = [bodyDic objectForKey:@"img"];
        NSArray *videoArray = [bodyDic objectForKey:@"video"];
        if ([videoArray count]) {
            NSLog(@"这个新闻里面有视频或者音频---");
            NSMutableArray *videos = [NSMutableArray arrayWithCapacity:[videoArray count]];
            for (NSDictionary *videoDic in videoArray) {
                MCVideoInfo *videoin = [[MCVideoInfo alloc] initWithInfo:videoDic];
                [videos addObject:videoin];
                NSRange range = [bodyStr rangeOfString:videoin.ref];
                NSString *videoStr = [NSString stringWithFormat:@"<embed height='50' width='280' src='%@' />",videoin.url_mp4];
                [bodyStr replaceOccurrencesOfString:videoin.ref withString:videoStr options:NSCaseInsensitiveSearch range:range];
            }
            
        }
        if ([imageArray count]==0) {
            NSLog(@"新闻没图片");
            NSString * str5 = [allTitleStr stringByAppendingString:bodyStr];
            [_webView loadHTMLString:str5 baseURL:[[NSURL URLWithString:_requestUrlString] baseURL]];
            
        }else{
            
            NSLog(@"新闻内容里面有图片");
            
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imageArray count]];
            
            for (NSDictionary *d in imageArray) {
                
                MCImageInfo *info = [[MCImageInfo alloc] initWithInfo:d];//kvc
                [images addObject:info];
                NSRange range = [bodyStr rangeOfString:info.ref];
                NSArray *wh = [info.pixel componentsSeparatedByString:@"*"];
                CGFloat width = [[wh objectAtIndex:0] floatValue];
                
                CGFloat rate = (self.view.bounds.size.width-15)/ width;
                CGFloat height = [[wh objectAtIndex:1] floatValue];
                CGFloat newWidth = width * rate;
                CGFloat newHeight = height *rate;
                
                NSString *imageStr = [NSString stringWithFormat:@"<img src = 'loading' id = '%@' width = '%.0f' height = '%.0f' hspace='0.0' vspace='5'>",[self replaceUrlSpecialString:info.src],newWidth,newHeight];
                [bodyStr replaceOccurrencesOfString:info.ref withString:imageStr options:NSCaseInsensitiveSearch range:range];
            }
            [self getImageFromDownloaderOrDiskByImageUrlArray:imageArray];
            
            [bodyStr replaceOccurrencesOfString:@"<p>　　" withString:@"<p>" options:NSCaseInsensitiveSearch range:[bodyStr rangeOfString:@"<p>　　"]];
            
            NSString * str5 = [allTitleStr stringByAppendingString:bodyStr];
            
            NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"webViewHtml" ofType:@"html"];
            NSMutableString* appHtml = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            
            NSRange range = [appHtml rangeOfString:@"<p>mainnews</p>"];
            
            [appHtml replaceOccurrencesOfString:@"<p>mainnews</p>" withString:str5 options:NSCaseInsensitiveSearch range:range];
            NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
            [_webView loadHTMLString:appHtml baseURL:baseURL];
            
        }
    }
    
}

- (void)getImageFromDownloaderOrDiskByImageUrlArray:(NSArray *)imageArray {
    
    for (NSDictionary *d in imageArray) {
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imageArray count]];
        MCImageInfo *info = [[MCImageInfo alloc] initWithInfo:d];//kvc
        [images addObject:info];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:info.src];
        if (image) {
            
            [_bridge send:[NSString stringWithFormat:@"replaceimage%@,%@",[self replaceUrlSpecialString:info.src],[[SDImageCache sharedImageCache] defaultCachePathForKey:info.src]]];
            
        }else {
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL    URLWithString:info.src] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [_bridge send:[NSString stringWithFormat:@"replaceimage%@,%@",[self replaceUrlSpecialString:info.src],[[SDImageCache sharedImageCache] defaultCachePathForKey:info.src]]];
                    });
                }
            }];
        }
    }
}

- (NSString *)replaceUrlSpecialString:(NSString *)string {
    
    return [string stringByReplacingOccurrencesOfString:@"/"withString:@"_"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:"];
    if (range.location != NSNotFound) {
//        NSInteger begin = range.location + range.length;
//        NSString *src = [url substringFromIndex:begin];
//        [self savePictureToAlbum:src];
        [self showPictureWithAbsoluteUrl:url];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.height = self.webView.scrollView.contentSize.height;
    [self.tableView reloadData];
}

#pragma mark - **************** tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.webView;
    }else if (section == 1){
        MCNewsDetailBottomCell *head = [MCNewsDetailBottomCell theSectionHeaderCell];
        head.sectionHeaderLbl.text = @"热门跟帖";
        return head;
    }else if (section == 2){
        MCNewsDetailBottomCell *head = [MCNewsDetailBottomCell theSectionHeaderCell];
        head.sectionHeaderLbl.text = @"相关新闻";
        return head;
    }
    return [UIView new];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.webView.height;
    }else if (section == 1){
        return CGFLOAT_MIN;
    }else if (section == 2){
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2){
        MCNewsDetailBottomCell *closeCell = [MCNewsDetailBottomCell theCloseCell];
        self.closeCell = closeCell;
        return closeCell;
    }
    return [[UIView alloc]init];
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2){
        return 64;
    }
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1 ;
    }else if (section == 2){
        return 0;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
    }else if (indexPath.section == 2){
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [MCNewsDetailBottomCell theShareCell];
        
    }else if (indexPath.section == 1){
        MCNewsDetailBottomCell *foot = [MCNewsDetailBottomCell theSectionBottomCell];
        return foot;
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            MCNewsDetailBottomCell *cell = [MCNewsDetailBottomCell theKeywordCell];
            [cell.contentView addSubview:[self addKeywordButton]];
            return cell;
        }else{
            MCNewsDetailBottomCell *other = [MCNewsDetailBottomCell theContactNewsCell];
            return other;
        }
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 126;
        
    }else if (indexPath.section == 1){
        return 110.5;
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 81;
        }
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 126;
    }else if (indexPath.section == 1){
        return 110.5;
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 81;
        }
    }
    return CGFLOAT_MIN;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.closeCell) {
        self.closeCell.iSCloseing = kNewsDetailControllerClose;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (kNewsDetailControllerClose) {
        UIImageView *imgV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imgV.image = [self getImage];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:imgV];
        [self.navigationController popViewControllerAnimated:NO];
        imgV.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            imgV.frame = CGRectMake(0, SCREEN_WIDTH/2, SCREEN_WIDTH, 0);
            imgV.alpha = 0.0;
        } completion:^(BOOL finished) {
            [imgV removeFromSuperview];
        }];
    }
}

- (UIView *)addKeywordButton
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    return view;
}

// 截图用于做上划返回
- (UIImage *)getImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT), NO, 1.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 将图片保存到相册  (旧方法已废弃)
- (void)savePictureToAlbum:(NSString *)src
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSURLCache *cache =[NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        UIImage *image = [UIImage imageWithData:imgData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }]];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showPictureWithAbsoluteUrl:(NSString *)url
{
    self.view.userInteractionEnabled = NO;
    NSRange range = [url rangeOfString:@"github.com/dsxNiubility?"];
    NSInteger path = range.location + range.length;
    NSString *tail = [url substringFromIndex:path];
    NSArray *keyValues = [tail componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (NSString *str in keyValues) {
        NSArray *keyVaule = [str componentsSeparatedByString:@"="];
        if (keyVaule.count == 2) {
            [parameters setValue:keyVaule[1] forKey:keyVaule[0]];
        }else if (keyValues.count > 2){
            NSRange range = [str rangeOfString:@"src="];
            if (range.location != NSNotFound) {
                NSString *value = [str substringFromIndex:range.length];
                [parameters setValue:value forKey:@"src"];
            }
        }
    }
    self.temImgPara = parameters;
    NSURLCache *cache =[NSURLCache sharedURLCache];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:parameters[@"src"]]];
    NSData *imgData = [cache cachedResponseForRequest:request].data;
    UIImage *image = [UIImage imageWithData:imgData];
    
    CGFloat top = [parameters[@"top"] floatValue] + self.tableView.frame.origin.y - self.tableView.contentOffset.y;
    
    CGFloat height = (SCREEN_WIDTH - 15) / [parameters[@"whscale"] floatValue];
    [self.temImgPara setValue:@(top) forKey:@"top"];
    [self.temImgPara setValue:@(height) forKey:@"height"];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    imgView.frame = CGRectMake(8, top, SCREEN_WIDTH-15, height);
    self.bigImg = imgView;
    
    self.hoverView.alpha = 0.0f;
    [self.navigationController.view addSubview:self.hoverView];
    [self.navigationController.view addSubview:imgView];

    if (!image) {
        [imgView sd_setImageWithURL:parameters[@"src"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self moveToCenter];
        }];
    }else{
        [self moveToCenter];
    }
}

- (void)moveToCenter
{
    CGFloat w = SCREEN_WIDTH;
    CGFloat h = SCREEN_WIDTH / [self.temImgPara[@"whscale"] floatValue];
    CGFloat x = 0;
    CGFloat y = (SCREEN_HEIGHT - h)/2;
    [UIView animateWithDuration:0.5 animations:^{
        self.hoverView.alpha = 1.0f;
        self.bigImg.frame = CGRectMake(x, y, w, h);
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}


@end
