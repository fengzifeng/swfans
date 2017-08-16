//
//  MCPictureBrowersViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/26.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCPictureBrowersViewController.h"
#import "MCPicCollectionViewCell.h"

static NSString *cellIdentifier = @"MCPicCollectionViewCell";

@interface MCPictureBrowersViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
}

@end

@implementation MCPictureBrowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBackButtonDefault];
    self.view.clipsToBounds = YES;
    
    _dataSourceArray = @[[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"4.png"]];
    
    CGRect rect = CGRectMake(-10, 0, 0, 0);
    rect.size.width = SCREEN_WIDTH+20;
    rect.size.height = SCREEN_HEIGHT;
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:collectionLayout];
    
    [collectionLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_collectionView registerClass:[MCPicCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.clipsToBounds = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    collectionLayout.minimumInteritemSpacing = 0;
    collectionLayout.minimumLineSpacing = 0;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.view insertSubview:_collectionView atIndex:0];
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - 单双击手势触发
- (void)handleDoubleTap:(UITapGestureRecognizer*)tap
{
    CGPoint touchPoint = [tap locationInView:tap.view];
    
    NSArray *cellArray = _collectionView.visibleCells;
    for (MCPicCollectionViewCell *cell in cellArray) {
        [cell doubleTapWithPoint:touchPoint index:_currentIndex];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer*)tap
{
    if (self.navigationBar.hidden) {
        [self.navigationBar setHidden:false];
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];  // 显示状态栏
    }else
    {
        [self.navigationBar setHidden:true];
        [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationNone];  // 隐藏状态栏
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell initWithImage:_dataSourceArray[indexPath.row] index:indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH+20 , SCREEN_HEIGHT);
}

#pragma mark UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.navigationBar setHidden:true];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];  // 隐藏状态栏
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    _currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.title = [NSString stringWithFormat:@"%@ / %@", @(_currentIndex+1), @(_dataSourceArray.count)];
}

@end
