//
//  FFLoginCell.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/24.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFLoginCell.h"
#import "FFLoginUser.h"

@interface FFLoginCell ()

{
    NSString *_titleContent;
}

@end

@implementation FFLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];

    [_lineLabel autoSetDimension:ALDimensionHeight toSize:0.5];
}

- (void)updateCell:(NSString *)titleStr
{
    _titleContent = titleStr;
    _textFild.placeholder = titleStr;
    
}

- (void)textFieldDidChange:(NSNotification *)not
{
    UITextField * textField =  not.object;
    if (![textField isEqual:_textFild]) {
        return;
    }
    
    NSString *string = textField.text;
    if ([_titleContent isEqualToString:@"邮箱"]) {
        _loginObj.email = string;
    } else if ([_titleContent isEqualToString:@"密码"] || [_titleContent isEqualToString:@"密码(不少于6位)"]) {
        _loginObj.password = string;
    } else if ([_titleContent isEqualToString:@"用户名"]){
        _loginObj.username = string;
    }
}

- (void)keyboardShow:(NSNotification *)note
{
    
    if (_type == loginType) {
        [((USAuthViewController *)self.nearsetViewController).downButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
