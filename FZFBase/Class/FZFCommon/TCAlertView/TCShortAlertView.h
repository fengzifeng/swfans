//
//  TCShortAlertView.h
//  HLMagic
//
//  Created by marujun on 13-12-3.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCShortAlertView;
@protocol TCShortAlertViewDelegate <NSObject>

- (void)didRemoveShortAlertView:(TCShortAlertView *)alertView;

@end

@interface TCShortAlertView : UIView
{
    __unsafe_unretained IBOutlet UILabel *messageLabel;
    __unsafe_unretained IBOutlet UIView *messageView;
}

@property(nonatomic, assign) id<TCShortAlertViewDelegate> delegate;

- (IBAction)tapGestureHandler:(UIButton *)sender;
- (void)setMessage:(NSString *)message;
- (void)setOriginY:(float)originY;

@end
