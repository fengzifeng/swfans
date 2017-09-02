//
//  FFInputePostViewController.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/26.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFInputePostViewController.h"

@interface FFInputePostViewController ()  <UITextViewDelegate,UITextFieldDelegate>

@end

@implementation FFInputePostViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    
    _textView.placeholder = @"写文章…";
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    
    UIButton *leftButton = [UIButton newBackArrowNavButtonWithTarget:self action:@selector(clickLeft)];
    [self setNavigationLeftView:leftButton];
    UIButton *rightButton = [UIButton newCloseButtonWithTarget:self action:@selector(clickRight)];
    [self setNavigationRightView:rightButton];
    __weak typeof(self) weakSelf = self;

    [self.view setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
    }];

}

- (void)clickRight
{
    
    
}

- (void)clickLeft
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)textFieldDidChange:(NSNotification *)not
{
    UITextField * textField =  not.object;
    if (![textField isEqual:_textField]) {
        return;
    }
    
    NSString *string = textField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //    [self didClick:nil];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        //        [self didClick:nil];
        return NO;
    }
    
    
    return YES;
}

- (IBAction)clickChoose:(id)sender
{
    USActionSheet *actionSheet = [USActionSheet initWithTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重试", @"删除上传失败的照片", nil];
    [actionSheet showWithCompletionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
        }
        else if (buttonIndex == 1) {
        }
    }];

}



@end
