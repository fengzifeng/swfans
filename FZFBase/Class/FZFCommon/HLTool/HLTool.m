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

@end
