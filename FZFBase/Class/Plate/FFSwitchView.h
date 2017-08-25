//
//  FFSwitchView.h
//  FZFBase
//
//  Created by 冯子丰 on 2017/8/22.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^choose)(NSInteger);

@interface FFSwitchView : UIView

+ (instancetype)showSwitchView:(choose)choose;

@end
