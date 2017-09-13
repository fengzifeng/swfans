//
//  FFSearchView.h
//  swfans
//
//  Created by fengzifeng on 2017/9/12.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^done)(NSString *text);

@interface FFSearchView : UIView

+ (FFSearchView *)showSearchView:(done)done;
@property (nonatomic, strong) UITextField *textField;
- (void)removeNotice;
- (void)addNotice;
@end
