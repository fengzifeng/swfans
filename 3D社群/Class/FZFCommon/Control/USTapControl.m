//
//  USTapControl.m
//  USEvent
//
//  Created by fengzifeng on 15/9/22.
//  Copyright © 2015年 fengzifeng. All rights reserved.
//

#import "USTapControl.h"

@interface USTapControl ()

@property (nonatomic, weak) UIView *gestureView;

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation USTapControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = [[UIScreen mainScreen] bounds];
        
        [self setupGesture];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.gestureView = view;
        self.backgroundColor = [UIColor clearColor];
        self.frame = [[UIScreen mainScreen] bounds];
        
        [self setupGesture];
    }
    return self;
}

- (void)setupGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self addGestureRecognizer:panGesture];
}

- (void)gestureAction:(UIGestureRecognizer *)gesture
{
    if (_disableGesture) {
        return;
    }
    
    if (self.target && self.action) {
        [self.target performSelector:self.action withObject:nil afterDelay:0];
    } else {
        [self.gestureView endEditing:YES];
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

@end
