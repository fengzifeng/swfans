//
//  HLTool.h
//  HLMagic
//
//  Created by FredHoolai on 3/5/14.
//  Copyright (c) 2014 chen ying. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HLTool : NSObject

/** 是否允许拍照（iOS7以上可用） */
+ (BOOL)cameraGranted;

/** 是否开启相册权限（iOS7以上可用） */
+ (BOOL)photoAlbumGranted;

/** 迁移老数据 */
+ (void)migrateOldVersionData;

/** 检测内存状态，如果是内存占用过多则关闭应用 */
+ (void)detectionMemoryPressureLevel;

+ (NSString *)timeStringWithDate:(NSDate *)date;

+ (NSString *)timeInfoWithDateString:(NSString *)dateString;

+ (NSString *)timeStringWithDateForBroadcastSlideView:(NSDate *)date;


@end
