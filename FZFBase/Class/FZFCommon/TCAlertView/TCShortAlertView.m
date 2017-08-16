//
//  TCShortAlertView.m
//  HLMagic
//
//  Created by marujun on 13-12-3.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import "TCShortAlertView.h"

#define animationDuration   0.3

@interface TCShortAlertView ()
{
    BOOL lockedState;
}

@end

@implementation TCShortAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveTCAlertView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeFromSuperview) name:@"RemoveTCAlertView" object:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    if(IS_IOS_6) {
        CGRect selfFrame = self.frame;
        selfFrame.origin.y = 20;
        self.frame = selfFrame;
    }
    
    messageView.layer.cornerRadius = 5;
    messageView.layer.masksToBounds = YES;
    lockedState = true;
    self.backgroundColor = [UIColor clearColor];
}


- (void)setMessage:(NSString *)message
{
    messageLabel.text = message;
}

- (void)setOriginY:(float)originY
{
    CGRect frame = messageView.frame;
    frame.origin.y = originY;
    messageView.frame = frame;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if(newSuperview){
        self.alpha = 0;
        [UIView animateWithDuration:animationDuration animations:^{
            self.alpha = 1;
        }completion:^(BOOL finsished){
            lockedState = false;
            [self performSelector:@selector(removeShortAlertView) withObject:nil afterDelay:1];
        }];
    }
}

- (IBAction)tapGestureHandler:(UIButton *)sender
{
    if(lockedState){
        return;
    }
    [self performSelector:@selector(removeShortAlertView) withObject:nil];
}


- (void)removeShortAlertView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    lockedState = true;
    
    [UIView animateWithDuration:animationDuration animations:^{
        messageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.6, 0.6, 1.0);
        messageView.alpha = 0.1;
    }completion:^(BOOL finsished){
        if (_delegate && [_delegate respondsToSelector:@selector(didRemoveShortAlertView:)]) {
            [_delegate didRemoveShortAlertView:self];
        }
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
    _delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
