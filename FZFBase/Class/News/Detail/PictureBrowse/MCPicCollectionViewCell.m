//
//  CollectionViewCell.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/26.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCPicCollectionViewCell.h"

@interface MCPicCollectionViewCell ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIScrollView *bottomScrollView;

@end

@implementation MCPicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = RGBACOLOR(0, 0, 0, .8);
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    _imageScrollView.showsVerticalScrollIndicator   = NO;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.bouncesZoom                    = YES;
    _imageScrollView.backgroundColor                = [UIColor clearColor];
    _imageScrollView.decelerationRate               = UIScrollViewDecelerationRateFast;
    _imageScrollView.delegate                       = self;
    [self.contentView addSubview:_imageScrollView];

    [self setupViews];
}

- (void)setupViews
{
    UIImageView *imageView = [UIImageView new];
    imageView.isAccessibilityElement    = YES;
    imageView.accessibilityTraits       = UIAccessibilityTraitImage;
    self.imageView = imageView;
    [self.imageScrollView addSubview:self.imageView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initForAutoLayout];
    scrollView.backgroundColor = RGBACOLOR(0, 0, 0, 0.95);
    self.bottomScrollView = scrollView;
    [self.contentView addSubview:self.bottomScrollView];
    self.bottomScrollView.frame = CGRectMake(10, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 150);
    
    NSString *contStr = @"可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗可是你的男的就看你看就是你能看出你女婿你们v每年需吗";
    float height = [contStr stringHeightWithFont:kFont_13 width:SCREEN_WIDTH - 20];
    self.bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height + 10);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, SCREEN_WIDTH, height)];
    label.font = kFont_13;
    label.text = contStr;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    [self.bottomScrollView addSubview:label];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorView = activityView;
    [self.imageScrollView addSubview:self.indicatorView];
    [self.indicatorView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.indicatorView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

- (void)initWithUrl:(NSString *)url index:(NSInteger)index
{
    
}

- (void)initWithAsset:(ALAsset *)asset index:(NSInteger)index
{

}

- (void)initWithImage:(UIImage *)image index:(NSInteger)index
{
    if (!image || ![image isKindOfClass:[UIImage class]]) return;
    
    _image = image;
    
    _imageView.image = image;
    _imageView.bounds = [self boundsOfImage:image forSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    _imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    [self setMaximumZoomScale];
}

#pragma mark - 双击手势触发
- (void)doubleTapWithPoint:(CGPoint)point index:(NSInteger)index
{
    if (self.imageScrollView.zoomScale > 1) {
        [self.imageScrollView setZoomScale:1 animated:YES];
    } else {
        [self.imageScrollView zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}

- (void)setMaximumZoomScale
{
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    float scale = _imageView.image.size.width/(SCREEN_WIDTH*scale_screen);
    
    self.imageScrollView.maximumZoomScale = MAX(scale, 2);
}

- (CGRect)boundsOfImage:(UIImage *)image forSize:(CGSize)size
{
    CGSize imageSize = image.size;
    CGSize viewSize = size;
    
    CGSize finalSize = CGSizeZero;
    
    if (imageSize.width / imageSize.height < viewSize.width / viewSize.height) {
        finalSize.height = viewSize.height;
        finalSize.width = viewSize.height / imageSize.height * imageSize.width;
    }
    else {
        finalSize.width = viewSize.width;
        finalSize.height = viewSize.width / imageSize.width * imageSize.height;
    }
    return CGRectMake(0, 0, finalSize.width, finalSize.height);
}

#pragma mark UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIImageView *zoomView = _imageView;
    
    CGSize boundSize = scrollView.bounds.size;
    CGSize contentSize = scrollView.contentSize;
    
    CGFloat offsetX = (boundSize.width > contentSize.width)? (boundSize.width - contentSize.width)/2 : 0.0;
    CGFloat offsetY = (boundSize.height > contentSize.height)? (boundSize.height - contentSize.height)/2 : 0.0;
    
    zoomView.center = CGPointMake(contentSize.width/2 + offsetX, contentSize.height/2 + offsetY);
}

@end
