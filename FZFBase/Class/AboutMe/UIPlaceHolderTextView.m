//
//  UIPlaceHolderTextView.m
//  FrictionMakingFriends
//
//  Created by zeke on 1/20/14.
//  Copyright (c) 2014 FrictionTeam. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@interface UIPlaceHolderTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation UIPlaceHolderTextView


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [_placeholderColor release]; _placeholderColor = nil;
    [_placeholder release]; _placeholder = nil;
    [super dealloc];
#endif
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    self.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if (_placeHolderLabel == nil )
    {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = _placeholderColor;
        _placeHolderLabel.alpha = 0;
        _placeHolderLabel.tag = 999;
        [self addSubview:_placeHolderLabel];
    }
    
    CGFloat top = 8.0;
    if ([self respondsToSelector:@selector(textContainerInset)]) {
        top = self.textContainerInset.bottom;
    }
    
    _placeHolderLabel.frame = CGRectMake(6, top, self.bounds.size.width - 16, 0);
    _placeHolderLabel.text = _placeholder;

    [_placeHolderLabel sizeToFit];
    [self sendSubviewToBack:_placeHolderLabel];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    _placeHolderLabel.textColor = _placeholderColor;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}
- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        [self setPlaceholder:_placeholder];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
}


@end
