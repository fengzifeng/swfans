//
//  MCEditInfoViewController.h
//  MCFriends
//
//  Created by bob on 14-9-2.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

typedef enum {
    EDITTYPE_SIGNATURE =0,  //签名
    EDITTYPE_NICKNAME,      //昵称
} EDIT_TYPE;

@interface MCEditViewController : MCViewController<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;

@property (nonatomic, assign) EDIT_TYPE dataTag;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *editTextField;

//适配 iOS 6
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPinConstraint;
@end
