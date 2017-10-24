//
//  MacroToolHeader.h
//  HLMagic
//
//  Created by fengzifeng on 13-10-6.
//  Copyright (c) 2013年 fengzifeng. All rights reserved.
//


#ifndef HLMagic_MacroToolHeader_h
#define HLMagic_MacroToolHeader_h

//#ifdef DEBUG
//#define FLOG(fmt,...)    NSLog((@"[%@][%d] " fmt),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,##__VA_ARGS__)
//#else
//#define FLOG(str, args...) ((void)0)
//#endif


#define IS_IPAD              (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define WINDOW_MAX_LENGTH    (MAX(SCREEN_WIDTH, SCREEN_WIDTH))

#define IS_IPHONE_4          (IS_IPHONE && WINDOW_MAX_LENGTH < 568.0)
#define IS_IPHONE_5          (IS_IPHONE && WINDOW_MAX_LENGTH == 568.0)
#define IS_IPHONE_6          (IS_IPHONE && WINDOW_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P         (IS_IPHONE && WINDOW_MAX_LENGTH == 736.0)


#define ShortSystemVersion   [[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_6             (ShortSystemVersion < 7)
#define IS_IOS_7             (ShortSystemVersion >= 7 && ShortSystemVersion < 8)
#define IS_IOS_8             (ShortSystemVersion >= 8)

#define radians(degrees)     ((degrees)*M_PI/180.0f)


#define userDefaults        [NSUserDefaults standardUserDefaults]
#define KeyWindow           [[[UIApplication sharedApplication] delegate] window]
#define WindowZoomScale     (SCREEN_WIDTH/320.f)
#define UniversalZoomScale  (MIN(1.8, WindowZoomScale))  //适配iPad

#define DocumentPath        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]    //获取Document文件夹的路径
#define ResourcePath        [[NSBundle mainBundle] resourcePath]    //获取自定义文件的bundle路径
#define ImageNamed(name)    [UIImage imageWithContentsOfFile:[ResourcePath stringByAppendingPathComponent:name]]
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]         //RGB进制颜色值
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]       //RGBA进制颜色值
#define HexColor(hexValue)  [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:1]   //16进制颜色值，如：#000000 , 注意：在使用的时候hexValue写成：0x000000

#define ThemColor            HexColor(0xaa2d1b)
#define KY_TINT_COLOR          HexColor(0xffab18)   /* 纯黄色 */

//获取随机数
#define Random(from, to) (int)(from + (arc4random() % (to - from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
#define ARC4RANDOM_MAX (0x100000000 * 20)

#define _applicationContext [ApplicationContext sharedContext]

//主界面 RootViewController
#define ROOT_VC  _applicationContext.rootViewController

//首页面 TabViewController
#define TAB_VC   _applicationContext.homeViewController


#define XcodeBundleVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


#endif
