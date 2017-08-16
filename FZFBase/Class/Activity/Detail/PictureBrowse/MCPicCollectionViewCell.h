//
//  CollectionViewCell.h
//  FZFBase
//
//  Created by fengzifeng on 16/7/26.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCPicCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void)initWithUrl:(NSString *)url index:(NSInteger)index;
- (void)initWithAsset:(ALAsset *)asset index:(NSInteger)index;
- (void)initWithImage:(UIImage *)image index:(NSInteger)index;
- (void)doubleTapWithPoint:(CGPoint)point index:(NSInteger)index;

@end
