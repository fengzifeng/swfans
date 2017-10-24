//  Created by fengzifeng on 13-9-24.
//  Copyright (c) 2013年 fengzifeng. All rights reserved.

#ifndef HLMagic_HLConfig_h
#define HLMagic_HLConfig_h

//友盟SDK
//#define kAppKey_YouMeng                        @"561df3f5e0f55a3593003858"


//页面默认背景色
#define VIEW_BG_COLOR         RGBCOLOR(244, 244, 244)
#define DEFAULT_BIRTH         @"1995-01-01"

#define _loginUser            [AuthData loginUser]
#define NetManager            [DrHttpManager defaultManager]
#define Location(titude)      [[userDefaults valueForKey:titude] floatValue]


#define kFont_10 [UIFont systemFontOfSize:10]
#define kFont_11 [UIFont systemFontOfSize:11]
#define kFont_12 [UIFont systemFontOfSize:12]
#define kFont_13 [UIFont systemFontOfSize:13]
#define kFont_14 [UIFont systemFontOfSize:14]
#define kFont_15 [UIFont systemFontOfSize:15]
#define kFont_16 [UIFont systemFontOfSize:16]
#define kFont_17 [UIFont systemFontOfSize:17]
#define kFont_18 [UIFont systemFontOfSize:18]
#define kFont_19 [UIFont systemFontOfSize:19]
#define kFont_20 [UIFont systemFontOfSize:20]
#define kFont_21 [UIFont systemFontOfSize:21]


//接口
#define HS_Scheme_Http              @"http://"
#define HS_Scheme_Http_S            @"https://"

#define BASE_URL_API                [NSString stringWithFormat:@"%@%@/", HS_Scheme_Http,@"attendee.solidworks.com.cn/api"]
#define GeneralUrl(relativeUrl)     [NSString stringWithFormat:@"%@%@", BASE_URL_API, relativeUrl]
#define url_structedgroups          GeneralUrl(@"structed_groups")
#define url_latestthreads           GeneralUrl(@"latest_threads/page/")
#define url_threads                 GeneralUrl(@"threads/")
#define url_articles                GeneralUrl(@"articles/page/")
#define url_threadlist              GeneralUrl(@"thread/list/")
#define url_submitpost              GeneralUrl(@"submit_post/")
#define url_register                GeneralUrl(@"register/")
#define url_login                   GeneralUrl(@"login/")
#define url_submitarticle           GeneralUrl(@"submit_article/")
#define url_search                  GeneralUrl(@"search_threads/page/")
#define url_profile_threads         GeneralUrl(@"profile/threads/")
#define url_profile_posts           GeneralUrl(@"profile/posts/")
#define url_reset_password           GeneralUrl(@"reset/password/")

//http://t.vduor.cn/api.html

#define NAVBAR_TAG 100109

typedef enum {
    GENDER_WOMEN = 0,
    GENDER_MAN,
    GENDER_NONE
} GENDER;

#endif

