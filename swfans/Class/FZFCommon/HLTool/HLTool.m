//
//  HLTool.m
//  HLMagic
//
//  Created by FredHoolai on 3/5/14.
//  Copyright (c) 2014 chen ying. All rights reserved.
//

#import "HLTool.h"
#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation HLTool

+ (BOOL)cameraGranted
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied)
    {
        if (&UIApplicationOpenSettingsURLString) {
            USAlertView *alert = [USAlertView initWithTitle:@"相机权限未开启" message:@"请在系统设置中开启相机权限以进行相关操作" cancelButtonTitle:@"确定" otherButtonTitles:@"开启相机", nil];
            [alert showWithCompletionBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        } else {
            [USAlertView showWithMessage:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"];
        }
        
        return NO;
    } else {
        return YES;
    }
}

//是否开启相册权限
+ (BOOL)photoAlbumGranted
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
        //无权限
        if (&UIApplicationOpenSettingsURLString) {
            USAlertView *alert = [USAlertView initWithTitle:@"相册权限未开启" message:@"请在系统设置中开启相册权限以进行相关操作" cancelButtonTitle:@"确定" otherButtonTitles:@"开启相册", nil];
            [alert showWithCompletionBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        } else {
            [USAlertView showWithMessage:@"请在设备的\"设置-隐私-照片\"中允许访问相册。"];
        }
        
        return NO;
    } else {
        return YES;
    }
}

//迁移老数据
+ (void)migrateOldVersionData
{
    
}



//检测内存状态，如果是内存占用过多则关闭应用
+ (void)detectionMemoryPressureLevel
{
    BOOL levelWarning = [UIDevice usedMemory] > 200.0;
    
    NSLog(@"device availableMemory: %.1fM",[UIDevice availableMemory]);
    NSLog(@"application usedMemory: %.1fM",[UIDevice usedMemory]);
    
    UIApplication *application = [UIApplication sharedApplication];
    if (levelWarning && application.applicationState == UIApplicationStateBackground && !_applicationContext.hasSwitchToOtherApp) {
        [(AppDelegate *)application.delegate applicationWillTerminate:application];
        
        WLOG(@"Us应用即将退出！！！！");
        exit(0);
    }
}

+ (NSString *)timeInfoWithDateString:(NSString *)dateString
{
    // 把日期字符串格式化为日期对象
    NSDate *date = [NSDate dateFromString:dateString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *curDate = [NSDate date];
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    
    NSTimeInterval retTime = 1.0;
    // 小于一小时
    if (time < 3600) {
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    }
    return @"1小时前";
}

+ (NSString *)timeStringWithDate:(NSDate *)date
{
    NSString *timeString = @"";
    if (date) {
        if ([date dayIndexSinceNow] == 0 ) {
            int secondDifference = [[NSDate date] timeIntervalSinceDate:date];
            if ((secondDifference  < 6*60)) {
                timeString = @"刚刚";
            }else if(secondDifference < 60*60)
            {
                timeString = [NSString stringWithFormat:@"%d分钟前", secondDifference/60];
            }else{
                timeString = [NSString stringWithFormat:@"%d小时前", secondDifference/(60*60)];
            }
        }else if([date dayIndexSinceNow] == -1 )
        {
            timeString = @"昨天";
        }else{
            timeString = [date stringWithDateFormat:@"MM.dd"];
        }
    }
    return timeString;
}

/**
 *
 *  倒计时的formart
 *  @param date
 *
 *  @return
 */
+ (NSString *)timeStringWithDateForBroadcastSlideView:(NSDate *)date
{
    NSString *timeString = @"";
    if (date) {
        NSDate *localDate = [NSDate date];
        if ([date dayIndexSinceDate:localDate] <= 0 ) {
            int secondDifference = [localDate timeIntervalSinceDate:date];
            
            if (secondDifference<=30) {
                timeString = @"刚刚";
            }else if ((secondDifference  < 60)) {
                timeString = [NSString stringWithFormat:@"%d秒前",secondDifference];
            }else if(secondDifference < 60*60)
            {
                timeString = [NSString stringWithFormat:@"%d分钟前", secondDifference/60];
            }else{
                timeString = [NSString stringWithFormat:@"%d小时前", secondDifference/(60*60)];
            }
        }else{
            timeString = [NSString stringWithFormat:@"%d天前",[date dayIndexSinceDate:localDate]];
        }
    }
    return timeString;
}


@end
