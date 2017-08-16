//
//  MCHVButton.h
//  MCFriends
//
//  Created by marujun on 15/6/12.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCHVButton : UIButton

/*!
 @property
 @brief 图片和文字之间的垂直间距,默认为0
 */
@property (assign, nonatomic) CGFloat space;

/*!
 @property
 @brief 重置图片的尺寸,默认取图片原有的尺寸
 */
@property (assign, nonatomic) CGSize image_size;

@end
