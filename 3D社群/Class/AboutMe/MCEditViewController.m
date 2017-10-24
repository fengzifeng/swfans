//
//  MCEditInfoViewController.m
//  MCFriends
//
//  Created by bob on 14-9-2.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MCEditViewController.h"

@interface MCEditViewController ()
{
    int _limitCount;
    BOOL _firstDidLayout;
}
@end

@implementation MCEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
            _firstDidLayout = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = VIEW_BG_COLOR;
    _limitCount = 50;
    _inputTextView.font = kFont_17;
    _inputTextView.textColor = RGBCOLOR(68, 68, 68);
    _inputTextView.layer.borderWidth = 1;
    _inputTextView.layer.cornerRadius = 6;
    _inputTextView.delegate = self;
    _inputTextView.layer.borderColor = [RGBCOLOR(193, 196, 199) CGColor];
    
    if (_dataTag == EDITTYPE_NICKNAME) {
        _limitCount = 10;
        
        _inputTextView.hidden = YES;
        _limitLabel.hidden = YES;
        _editTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _editTextField.borderStyle = UITextBorderStyleNone;
        _editTextField.returnKeyType = UIReturnKeyDone;
        _editTextField.delegate = self;
        
        UIButton *rightNavButton = [UIButton newClearNavButtonWithTitle:@"保存" target:self action:@selector(didClick:)];
        [self setNavigationRightView:rightNavButton];
    }else {
        _backView.hidden = YES;
        if (_dataTag == EDITTYPE_SIGNATURE)
        {
            _inputTextView.returnKeyType = UIReturnKeyDone;
            _inputTextView.delegate = self;
            UIButton *rightNavButton = [UIButton newClearNavButtonWithTitle:@"保存" target:self action:@selector(didClick:)];
            [self setNavigationRightView:rightNavButton];
        }
    }
    
    [self setNavigationBackButtonDefault];
}
-(void)didClick:(UIButton*)btn
{
    NSString *text =  nil;
    
    if (_dataTag == EDITTYPE_NICKNAME) {
        text = _editTextField.text;
        if([text rangeOfString:@"回复"].length){
            text = [text stringByReplacingOccurrencesOfString:@"回复" withString:@""];
        }
    }
    else if (_dataTag == EDITTYPE_SIGNATURE) {
        text = _inputTextView.text;
    }

    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_dataTag == EDITTYPE_NICKNAME) {
        if (text.length) {
            _editTextField.text = text;
            _loginUser.username = text;
            [self.navigationController popViewControllerAnimated:true];
        }
        else {
//            [KeyWindow showAlertMessage:@"昵称不能为空" callback:nil];
        }
    }
    else if (_dataTag == EDITTYPE_SIGNATURE) {
        _inputTextView.text = text;
//        _targetUser.signature = text;
        [self.navigationController popViewControllerAnimated:true];
    }
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (_firstDidLayout) {
        if (_dataTag == EDITTYPE_NICKNAME){
            _editTextField.text = _loginUser.username;
            [_editTextField becomeFirstResponder];
        }else
        {
            [_inputTextView becomeFirstResponder];
        }
        _firstDidLayout = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        if (_dataTag == EDITTYPE_SIGNATURE) {
//            _loginUser.signature = _inputTextView.text;
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:false animated:true];
    
    [super viewWillAppear:animated];
    
    _inputTextView.text = [self whichContentWithIndex:_dataTag];
    NSInteger length = 0;
    if (_inputTextView.text.length != 0) {
        length = _inputTextView.text.length;
    }
    _limitLabel.text = [NSString stringWithFormat:@"%@/%d", @(length), _limitCount];
}

- (NSString *)whichContentWithIndex:(NSInteger)index
{
    NSString *content;
    if (index == EDITTYPE_SIGNATURE) {
//        content = _targetUser.signature;
    }
    return content;
}

#pragma mark - textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self didClick:nil];
        return NO;
    }
    text = [_inputTextView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (text.length > _limitCount) {
        
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil && textView.text.length > _limitCount) {
        textView.text = [textView.text substringToIndex:_limitCount];
    }
    
    NSInteger count = textView.text.length > _limitCount ? _limitCount : textView.text.length;
    _limitLabel.text = [NSString stringWithFormat:@"%@/%@", @(count), @(_limitCount)];
}

#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    string = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length > _limitCount) {
        textField.text = [textField.text substringToIndex:_limitCount];
        return NO;
    }
    return YES;
}
- (void)textFieldDidChange:(NSNotificationCenter *)not
{
    NSString *text = _editTextField.text;
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([text rangeOfString:@"回复"].length){
        text = [text stringByReplacingOccurrencesOfString:@"回复" withString:@""];
    }
    if (_editTextField.markedTextRange == nil && text.length > _limitCount) {
        _editTextField.text = [text substringToIndex:_limitCount];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self didClick:nil];
    return YES;
}

//-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    [textView resignFirstResponder];
//    [self didClick:nil];
//    return YES;
//}


@end
