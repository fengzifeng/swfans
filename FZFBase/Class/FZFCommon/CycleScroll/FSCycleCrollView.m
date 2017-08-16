//
//  FSCycleCrollView.m
//  FZFBase
//
//  Created by fengzifeng on 16/6/8.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "FSCycleCrollView.h"

#define viewHeight 100
#define viewWidth SCREEN_WIDTH
#define move_During 3

@interface FSCycleCrollView ()
{
    UIScrollView *_scrollView;
    NSInteger _tempCount;
    NSInteger _moveDuring;
}

@end

@implementation FSCycleCrollView

+ (FSCycleCrollView *)showCycleScrollView:(NSArray *)viewArray
{
    FSCycleCrollView *cycleView = [[FSCycleCrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    [cycleView setupViews:viewArray];
    
    return cycleView;
}

- (void)setupViews:(NSArray *)array
{
    if (!array.count) return;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    NSMutableArray *tempArray = [array mutableCopy];
    [tempArray insertObject:array[0] atIndex:0];
    [tempArray addObject:array[array.count-1]];
    _tempCount = tempArray.count;
    
    for (int i=0; i<_tempCount; i++) {
        UIView *itemView = tempArray[i];
        itemView.frame = CGRectMake(i*viewWidth, 0, viewWidth, viewHeight);
        if (i%2) itemView.backgroundColor = [UIColor yellowColor];
        [_scrollView addSubview:itemView];
    }
    
    _moveDuring = move_During;
    [self performSelector:@selector(scrollerMoveFunction) withObject:nil afterDelay:_moveDuring];

    _scrollView.contentSize = CGSizeMake(viewWidth*tempArray.count, viewHeight);
    [_scrollView setContentOffset:CGPointMake(viewWidth, 0) animated:NO];
}

- (void)scrollerMoveFunction
{
    [UIView animateWithDuration:0.23 animations:^{
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + viewWidth, 0) animated:NO];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(scrollerMoveFunction) withObject:nil afterDelay:_moveDuring];
        [self changeForLoop];
    }];
}

- (void)changeForLoop
{
    if (_scrollView.contentOffset.x >= viewWidth*(_tempCount-1)) {
        [_scrollView setContentOffset:CGPointMake(viewWidth, 0) animated:NO];
    }
    
    if (_scrollView.contentOffset.x == 0) {
        [_scrollView setContentOffset:CGPointMake(viewWidth*2, 0) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollerMoveFunction) object:nil];
    _moveDuring = move_During;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollerMoveFunction) object:nil];
    [self performSelector:@selector(scrollerMoveFunction) withObject:nil afterDelay:_moveDuring];
    [self changeForLoop];
}

@end
