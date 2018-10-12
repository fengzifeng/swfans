//
//  MCViewController.m
//  FrictionMakingFriends
//
//  Created by fengzifeng on 14-3-11.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"

@interface MCViewController ()
{
    UIView *_amsNavBgView;
    UILabel *_amsNavTitleLabel;
    UIImageView *_amsNavMaskView;
    UIView *_amsNavContentView;
    NSMutableArray *_amsNavButtonArray;
    
    BOOL _hasAppear;
}

@end

@implementation MCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self fInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _topInset = 64;
    if (IS_IPHONE_X) _topInset = 88;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.barTintColor = ThemColor;
    self.navigationBar.clipsToBounds = true;
    self.navigationBar.translucent = false;
    self.navigationBar.tag = NAVBAR_TAG;
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor clearColor]];

    NSDictionary * dict = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSShadowAttributeName:shadow};
    self.navigationBar.titleTextAttributes = dict;
    [self.view addSubview:self.navigationBar];
    [self.navigationBar pushNavigationItem:self.myNavigationItem animated:false];
    [self.navigationBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
}

- (void)setTitle:(NSString *)title
{
    self.myNavigationItem.title = title;
    _amsNavTitleLabel.text = title;
    
    [super setTitle:title];
}
//
- (void)fInit
{
    _enableScreenEdgePanGesture = YES;

    self.navigationBar = [[FFNavigationBar alloc] initForAutoLayout];
    [self.navigationBar autoSetDimension:ALDimensionHeight toSize:64];
    
    self.myNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    
	NSLog(@"init 创建类 %@", NSStringFromClass([self class]));
}
//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _hasAppear = true;
    
    
//    [[ImageCacheManager defaultManager] openOperationForIdentify:NSStringFromClass([self class])];
}
//
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _hasAppear = false;
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
  }

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	NSLog(@"dealloc 释放类 %@",  NSStringFromClass([self class]));
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)updateDisplay
{
    
}

- (void)initNavigationBar
{
    
}

#pragma mark - Ttable View DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)initAmsNavigationBar
{
    self.navigationBar.hidden = true;
    
    if (!_amsNavigationBar) {
        _amsNavigationBar = [[UIView alloc] init];
//        _amsNavigationBar.frame = CGRectMake(0, 0, WINDOW_WIDTH, IS_IOS_6?44:64);
        _amsNavigationBar.tag = NAVBAR_TAG;
        _amsNavBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_amsNavigationBar];
        [_amsNavigationBar autoSetDimension:ALDimensionHeight toSize:_topInset];
        [_amsNavigationBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        
        _amsNavBgView = [[UIView alloc] initForAutoLayout];
        _amsNavBgView.backgroundColor = ThemColor;
        [_amsNavigationBar addSubview:_amsNavBgView];
        [_amsNavBgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        UILabel *line = [[UILabel alloc] initForAutoLayout];
        line.backgroundColor = RGBCOLOR(223 , 223, 221);
        
        _amsNavContentView = [[UIView alloc] initForAutoLayout];
        _amsNavContentView.backgroundColor = [UIColor clearColor];
        [_amsNavigationBar addSubview:_amsNavContentView];
        [_amsNavContentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        _amsNavButtonArray = [[NSMutableArray alloc] init];
        
        UIButton *backButton = [[UIButton alloc] initForAutoLayout];
        [backButton setImage:[UIImage imageNamed:@"pub_nav_back.png"] forState:UIControlStateSelected];
        [backButton setImage:[UIImage imageNamed:@"pub_nav_white_back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(navigationBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_amsNavContentView addSubview:backButton];
        
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [backButton autoSetDimensionsToSize:CGSizeMake(46, 44)];
        [backButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        [backButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        [_amsNavButtonArray addObject:backButton];
        
        UIView *rightNavView = [[self.myNavigationItem.rightBarButtonItems lastObject] customView];
        if ([rightNavView isKindOfClass:[UIButton class]]) {
            [_amsNavButtonArray addObject:rightNavView];
        }
        else{
            for (UIView *item in rightNavView.subviews) {
                if ([item isKindOfClass:[UIButton class]]) {
                    [_amsNavButtonArray addObject:item];
                }
            }
        }
        
        float titleWidth = SCREEN_WIDTH-rightNavView.frame.size.width*2;
        
        _amsNavTitleLabel = [[UILabel alloc] initForAutoLayout];
        _amsNavTitleLabel.font = [UIFont boldSystemFontOfSize:17];
        _amsNavTitleLabel.textAlignment = NSTextAlignmentCenter;
        _amsNavTitleLabel.backgroundColor = [UIColor clearColor];
        _amsNavTitleLabel.textColor = [UIColor whiteColor];
        
        _amsNavTitleLabel.adjustsFontSizeToFitWidth = YES;
        _amsNavTitleLabel.minimumScaleFactor = 15.0/line.font.pointSize;
        [_amsNavContentView addSubview:_amsNavTitleLabel];
        
        [_amsNavTitleLabel autoSetDimensionsToSize:CGSizeMake(titleWidth, 44)];
        [_amsNavTitleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_amsNavTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        [_amsNavContentView addSubview:rightNavView];
        [rightNavView autoSetDimensionsToSize:rightNavView.frame.size];
        [rightNavView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [rightNavView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }
    _amsNavTitleLabel.text = self.title;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_amsNavigationBar)
    {
        float offsetY = scrollView?scrollView.contentOffset.y:0;
        float maxAlpha = 1.0;
        float firstHalf = 106.f;
        float secondHalf = 96.f;
        float minAlpha = 0.01;
        
        if(offsetY<=0){
            _amsNavBgView.alpha = 0;
        }
        else if (offsetY<firstHalf) {
            float alpha = minAlpha + (maxAlpha-minAlpha)-(maxAlpha-minAlpha)*((firstHalf+secondHalf)-offsetY)/(firstHalf+secondHalf);
            _amsNavBgView.alpha = MIN(maxAlpha, alpha);
        }
        else{

            float alpha = minAlpha + (maxAlpha-minAlpha)-(maxAlpha-minAlpha)*((firstHalf+secondHalf)-offsetY)/(firstHalf+secondHalf);
            _amsNavBgView.alpha = MIN(maxAlpha, alpha);
        }
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //execute this gesture only if there's one on-screen scroll view with `scrollsToTop` == YES. If more than one is found, none will be scrolled.
    
    return YES;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (UIViewController *)viewControllerWillPushForLeftDirectionPan
{
    return nil;
}

+ (instancetype)viewController
{
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}


@end
