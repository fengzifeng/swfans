//
//  USActionSheet.h
//  USEvent
//
//  Created by marujun on 15/10/19.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USActionSheet : UIView

+ (instancetype)initWithOtherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
        otherButtonTitleArray:(NSArray *)otherButtonTitleArray;

- (void)clickedIndex:(NSInteger)index;

- (void)showWithCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock;

@end
