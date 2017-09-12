//
//  FFSearchTextField.m
//  swfans
//
//  Created by fengzifeng on 2017/9/12.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFSearchTextField.h"

@implementation FFSearchTextField

+ (FFSearchTextField *)showSearchTextField
{
    FFSearchTextField *textField = [[FFSearchTextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 25)];
    textField.backgroundColor = RGBCOLOR(196, 108, 96);
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 5;
    textField.placeholder = @"请输入搜索内容";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 15, 15)];
    imageView.image = [UIImage imageNamed:@"new_search"];
    [textField addSubview:imageView];
    
    return textField;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }

    return self;
}

@end
