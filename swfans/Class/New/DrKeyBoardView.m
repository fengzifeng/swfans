//
//  DrKeyBoardView.m
//  Driver
//
//  Created by chēng on 15/7/7.
//  Copyright (c) 2015年 Driver. All rights reserved.
//

#import "DrKeyBoardView.h"

@interface DrKeyBoardView()<UITextViewDelegate>
{
    UIView *line1;
}

@property (nonatomic,strong) UIView *bgView;

@end

@implementation DrKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews:frame];
    }
    return self;
}


+ (instancetype)creatKeyBoardWithDelegate:(id)delegate parentVc:(MCViewController *)parentVc
{
    if ([[UIApplication sharedApplication].delegate.window viewWithTag:chatPanTag])
    {
        DrKeyBoardView *keyB = (DrKeyBoardView *)[[UIApplication sharedApplication].delegate.window viewWithTag:chatPanTag];
        [keyB removeListion];
        [keyB addListion];
        keyB.delegate=delegate;

        return keyB;
    }
        
    DrKeyBoardView *keyB =[[DrKeyBoardView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    keyB.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    keyB.delegate=delegate;
    keyB.textView.returnKeyType=UIReturnKeyDone;
    keyB.bgView = parentVc.view;
    keyB.top = SCREEN_HEIGHT;

    [parentVc.view addSubview:keyB];
    keyB.tag = chatPanTag;
    [keyB removeListion];
    [keyB addListion];
    
    return keyB;
}


- (void)keyboardShow:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    CGSize size            = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat duration      = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.top = 0;

    if (size.height > 0) {

        [UIView animateWithDuration:duration animations:^{
            self.boardView.transform=CGAffineTransformMakeTranslation(0, -size.height - 118);
            self.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
        }];
    }
 }

-(void)keyboardHide:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    CGSize size = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat duration  = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    if (size.height > 0) {// 百度键盘会调用两次，第一次高度为0

        self.boardView.transform=CGAffineTransformIdentity;
        
        [UIView animateWithDuration:duration animations:^{
            self.backgroundColor = [UIColor clearColor];
        }completion:^(BOOL finished) {
            self.top = SCREEN_HEIGHT;
        }];
    }
}

- (void)initSubviews:(CGRect)frame{
    self.backgroundColor = [UIColor clearColor];
    [self addTarget:self action:@selector(cancalKeyBoard) forControlEvents:UIControlEventTouchDown];
    UIView *boardView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 120)];
    [self addSubview:boardView];
    self.boardView = boardView;
    self.boardView.backgroundColor = [UIColor whiteColor];

    line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
    line1.backgroundColor = HexColor(0xe5e5e5);
    [boardView addSubview:line1];

    UIButton *cancalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancalButton setTitle:@"取消" forState:UIControlStateNormal];
    cancalButton.frame = CGRectMake(20, 15, 40, 25);
    cancalButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancalButton addTarget:self action:@selector(cancalKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:cancalButton];
    [cancalButton setTitleColor:HexColor(0xa9a9a9) forState:UIControlStateNormal];
    
    self.cancalButton = cancalButton;
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitleColor:HexColor(0xaa2d1b) forState:UIControlStateNormal];
//    _sendBtn.enabled = NO;
    [_sendBtn setTitle:@"发表" forState:UIControlStateNormal];
    _sendBtn.frame = CGRectMake(SCREEN_WIDTH - 20 - 40, 15, 40, 25);
    [_sendBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:_sendBtn];
    
    CGRect TVframe = CGRectMake(20, CGRectGetMaxY(cancalButton.frame) + 10 ,SCREEN_WIDTH - 40, 58);
    self.textView = [[UIPlaceHolderTextView alloc] initWithFrame:TVframe];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.masksToBounds = YES;
    self.textView.placeholder = @"请输入内容...";
    [self.textView setDelegate:self];
    self.textView.font=[UIFont systemFontOfSize:14.0];
    [boardView addSubview:self.textView];
    self.textView.enablesReturnKeyAutomatically = YES;
//    [self.textView setInputView:nil];
//    [self.textView reloadInputViews];

}

- (void)cancalKeyBoard
{
    [self.textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        if(self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewHide:textView:)]){
            [self.delegate keyBoardViewHide:self textView:self.textView];
        }

        return NO;
    }
    
    return YES;
}

//-(void)textViewDidChange:(UITextView *)textView
//{
//
//    if ([self isBlankString:textView.text]) {
////        无内容dasdas
//        [_sendBtn setTitleColor:HexColor(0xa9a9a9) forState:UIControlStateNormal];
//        _sendBtn.enabled = NO;
//
//    }else{
//        [_sendBtn setTitleColor:HexColor(0xaa2d1b) forState:UIControlStateNormal];
//
//        _sendBtn.enabled = YES;
//
//    }
//}


- (void)submitAction
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewHide:textView:)]){
        [self.delegate keyBoardViewHide:self textView:self.textView];
    }
}

#pragma mark -
#pragma mark 判断字符串是否为空
- (BOOL)isBlankString:(NSString *)string{
    
    if ([@"" isEqualToString:string]) {
        return YES;
    }
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
    
}

- (void)resetSendBtnStatus
{
    [_textView resignFirstResponder];
//    _sendBtn.enabled = NO;
    _textView.text = @"";
//    [_sendBtn setTitleColor:HexColor(0xa9a9a9) forState:UIControlStateNormal];

}

-(void)dealloc
{
    [self.textView resignFirstResponder];

    [self removeListion];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeListion
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)addListion
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

}
@end
