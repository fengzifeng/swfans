//
//  UIPlaceHolderTextView.h
//  FrictionMakingFriends
//
//  Created by zeke on 1/20/14.
//  Copyright (c) 2014 FrictionTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
