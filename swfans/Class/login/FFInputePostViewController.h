//
//  FFInputePostViewController.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/26.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"
#import "UIPlaceHolderTextView.h"

@interface FFInputePostViewController : MCViewController

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIPlaceHolderTextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *chooseBtn;

@end
