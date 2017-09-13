//
//  FFSearchView.m
//  swfans
//
//  Created by fengzifeng on 2017/9/12.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFSearchView.h"
#import "USTapControl.h"

#define dispatch_main_after(delayInSeconds,block)\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC), dispatch_get_main_queue(),block);

@interface FFSearchView () <UITextFieldDelegate>

@property (nonatomic, copy) done done;
@property (nonatomic, strong) UIImageView *lImageView;
@property (strong, nonatomic) USTapControl *tapControl;

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
    textField.tintColor = HexColor(0xaa201b);

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
        [self removeNotice];
        [self addNotice];
    }
    
    return self;
}

- (void)addNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotice
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)note
{
//    _textField.placeholder = @"";
//    _lImageView.hidden = YES;
    if (!_tapControl) {
        _tapControl = [[USTapControl alloc] initWithView:((MCViewController *)TAB_VC).navigationBar];
    }
    _tapControl.disableGesture = YES;
    dispatch_main_after(KeyboardAnimationDuration, ^{
        _tapControl.disableGesture = NO;
    })
    
    [_applicationContext.rootViewController.view addSubview:_tapControl];
    [_tapControl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

}

-(void)keyboardHide:(NSNotification *)note
{
//    _textField.placeholder = @"      请输入搜索内容";
//    _lImageView.hidden = NO;
    [_tapControl removeFromSuperview];

}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
