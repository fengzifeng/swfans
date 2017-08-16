//
//  FSCycleCrollView.h
//  FZFBase
//
//  Created by fengzifeng on 16/6/8.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSCycleCrollView : UIView <UIScrollViewDelegate>

+ (FSCycleCrollView *)showCycleScrollView:(NSArray *)viewArray;

@end
