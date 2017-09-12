//
//  FFSearchView.m
//  swfans
//
//  Created by fengzifeng on 2017/9/12.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFSearchView.h"

@interface FFSearchView () <UITextFieldDelegate>

@property (nonatomic, copy) done done;
@property (nonatomic, strong) UIImageView *lImageView;

@end

@implementation FFSearchView

+ (FFSearchView *)showSearchView:(done)done
{
    FFSearchView *view = [[FFSearchView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 25)];
    view.done = done;
    view.backgroundColor = RGBCOLOR(196, 108, 96);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, view.width - 25, view.height)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = @"请输入搜索内容";
    textField.delegate = view;
    textField.font = kFont_12;
    textField.returnKeyType = UIReturnKeySearch;
    textField.enablesReturnKeyAutomatically = YES;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 15, 15)];
    imageView.image = [UIImage imageNamed:@"new_search"];
    [view addSubview:textField];
    [view addSubview:imageView];
    view.lImageView = imageView;
    view.textField = textField;
    
    
    return view;
    
}

- (void)textFieldDidChange:(NSNotification *)not
{
    UITextField * textField =  not.object;
    if (textField.text.length) {
        self.lImageView.hidden = YES;
    } else {
        self.lImageView.hidden = NO;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = textField.text;
    if (!text.length) {
        [USSuspensionView showWithMessage:@"输入为空"];
    } else {
        self.done?self.done(text):nil;
    }
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil]; 
    }
    
    return self;
}

//- (void)keyboardShow:(NSNotification *)note
//{
//    _textField.placeholder = @"";
//    _lImageView.hidden = YES;
//}
//
//-(void)keyboardHide:(NSNotification *)note
//{
//    _textField.placeholder = @"      请输入搜索内容";
//    _lImageView.hidden = NO;
//}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
