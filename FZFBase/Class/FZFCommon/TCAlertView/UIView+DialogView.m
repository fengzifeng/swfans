//
//  UIView+DialogView.m
//  HLMagic
//
//  Created by marujun on 13-11-29.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import "UIView+DialogView.h"

@implementation UIView (DialogView)

void (^ExternCallBack)(void);
void (^IndexCallBack)(int index);

- (void)showAlertMessage:(NSString *)message callback:(void (^)(void))callback
{
    [self showAlertMessage:message originY:0 callback:callback];
}

- (void)showAlertMessage:(NSString *)message originY:(float)originY callback:(void (^)(void))callback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ExternCallBack = callback;
        
        TCShortAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:@"TCShortAlertView" owner:self options:nil] lastObject];
        alertView.delegate = self;
        [alertView setMessage:message];
        alertView.frame = [[UIScreen mainScreen] bounds];
        
        if(originY){
            [alertView setOriginY:originY];
        }
        
        [KeyWindow addSubview:alertView];
    });
}

#pragma mark - TCShortAlertViewDelegate
- (void)didRemoveShortAlertView:(TCShortAlertView *)alertView
{
    if(ExternCallBack){
        ExternCallBack();
    }
}

@end
