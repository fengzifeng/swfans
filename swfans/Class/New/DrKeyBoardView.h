//
//  DrKeyBoardView.h
//  Driver
//
//  Created by chēng on 15/7/7.
//  Copyright (c) 2015年 Driver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

#define kStartLocation 15
#define chatPanTag 1133111

@class DrKeyBoardView;
@protocol DrKeyBoardViewDelegate <NSObject>

-(void)keyBoardViewHide:(DrKeyBoardView *)keyBoardView textView:(UITextView *)contentView;

@end

@interface DrKeyBoardView : UIButton

@property (nonatomic,strong) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *cancalButton;
@property (nonatomic,strong) UIView *boardView;

@property (nonatomic, weak) id<DrKeyBoardViewDelegate> delegate;

+ (instancetype)creatKeyBoardWithDelegate:(id)delegate parentVc:(MCViewController *)parentVc;
- (void)resetSendBtnStatus;
- (void)removeListion;
- (void)addListion;

@end
