//
//  USSuspensionView.m
//  USEvent
//
//  Created by marujun on 15/10/16.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USSuspensionView.h"

static USSuspensionView *suspensionView_only = nil;

@interface USSuspensionView ()

@property (strong, nonatomic) NSString *message;

@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation USSuspensionView

- (void)awakeFromNib
{
    _contentView.layer.cornerRadius = 5.f;
    _contentView.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    
    _contentLabel.text = _message;
    
    CGSize size = [_contentLabel sizeThatFits:CGSizeMake(240-30, CGFLOAT_MAX)];
    [_contentView autoSetDimension:ALDimensionWidth toSize:30+size.width];
    [_contentView autoSetDimension:ALDimensionHeight toSize:30+MIN(size.height, 30)];
    
    [self layoutIfNeeded];
}

+ (instancetype)showWithMessage:(NSString *)message
{
    if (!suspensionView_only) {
        suspensionView_only = [[[NSBundle mainBundle] loadNibNamed:@"USSuspensionView" owner:self options:nil] firstObject];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:suspensionView_only];
        [suspensionView_only autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [suspensionView_only startAppearAnimation];
    }
    suspensionView_only.message = message;
    [NSObject cancelPreviousPerformRequestsWithTarget:suspensionView_only];
    [suspensionView_only performSelector:@selector(disappear) withObject:nil afterDelay:2.f];
    
    return suspensionView_only;
}

- (void)startAppearAnimation
{
    [self layoutIfNeeded];
    
    _bgLabel.alpha = 0;
    _contentView.alpha = 0.5;
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            _contentView.transform = CGAffineTransformMakeScale(1, 1);
                        } completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgLabel.alpha = 1;
        _contentView.alpha = 1;
    }];
}

- (void)disappear
{
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgLabel.alpha = 0;
        _contentView.alpha = 0.1;
        _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        suspensionView_only = nil;
    }];
}

@end
