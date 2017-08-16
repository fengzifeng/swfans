//
//  DrBaseNetworkManager+NetworkTool.m
//  Driver
//
//  Created by wei on 16/11/9.
//  Copyright © 2016年 Driver. All rights reserved.
//

#import "DrBaseNetworkManager+NetworkTool.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation DrBaseNetworkManager (NetworkTool)

/**
 hos	系统	android或ios
 hosver	操作系统版本	4.2.0
 himei	手机唯一标识码	864334021687429
 hurl	请求url	http://api.jxedt.com/api/ad/1/3.8.0/1/?os=android&model=vivo%20Y13&lon=101.074807&kemutype=1&density=240.0&adheight=100&osv=4.2.2&imei=864334021687429&packagename=com.jxedt&mac=80%3A41%3A4e%3A2b%3A51%3A7a&type=practopbanad&cartype=0&screenwidth=480&version=3.8.0&cityid=287&androidid=492140c81704a0e5&time=1448467232872&productid=1&aaid=&adwidth=640&screenheight=854&make=BBK&channel=1&lat=24.665552
 happver	app版本	3.8.0
 hlon	经度	101.074807
 hlat	纬度	24.665552
 htime	时间戳，精确到毫秒	1448467232872
 hprodctorid	产品id，同prodctorid，android是1，ios是3等	1
 hr	本次请求的随机数	123456(6位随机数）
 hsign	签名	743829147912417284329104214231(32位md5码）
 
 */
+ (NSMutableURLRequest *)requestEncryption:(NSMutableURLRequest *)request{
    
    [DrBaseNetworkManager setCommonHeader:request url:nil];
    return request;
}

+(void)setCommonHeader:(id )obj url:(NSString *)urlStr
{
//    id request = nil;
//    if ([obj isKindOfClass:[NSMutableURLRequest class]]) {
//        request = (NSMutableURLRequest *)obj;
//    }else if ([obj isKindOfClass:[AFHTTPSessionManager class]])
//    {
//        request = (AFHTTPRequestSerializer *)[obj requestSerializer];
//    }else
//    {
//        NSLog(@"不能为此类型设置header");
//        return ;
//    }
//    [request setValue:[DrBaseNetworkManager getNetWorkStatus] forHTTPHeaderField:@"net"];
//    [request setValue:@"ios" forHTTPHeaderField:@"hos"];
//    [request setValue:[UIDevice dr_OSVer] forHTTPHeaderField:@"hosver"];
//    [request setValue:[UIDevice dr_deviceID] forHTTPHeaderField:@"himei"];
//    NSString *appVer = [DrPrefs appVersion];
//    [request setValue:appVer forHTTPHeaderField:@"happver"];
//    [request setValue:[DRUserManagerShare getLogin_UserId] forHTTPHeaderField:@"huserid"];
//    [request setValue:[self getCarrierName] forHTTPHeaderField:@"carriername"];
//    if (DRUserManagerShare.pincode) {
//        [request setValue:DRUserManagerShare.pincode forHTTPHeaderField:@"hpincode"];
//    }
//    NSURL *tempUrl = nil;
//    if ([obj isKindOfClass:[NSMutableURLRequest class]]) {
//        tempUrl = [(NSMutableURLRequest *)obj URL];
//    }else if ([obj isKindOfClass:[AFHTTPSessionManager class]])
//    {
//        tempUrl = [NSURL URLWithString:urlStr];//[(AFHTTPSessionManager *)obj baseURL];
//    }
//   
//    
//    NSString *url = [NSString stringWithFormat:@"%@",[tempUrl absoluteString]];
//    NSArray *urls = [url componentsSeparatedByString:@"?"];
//    [request setValue:[tempUrl description] forHTTPHeaderField:@"hurl"];
//    NSString *urlPath = (urls.count>0)?urls[0]:@"nunll";
//    [request setValue:urlPath forHTTPHeaderField:@"hpath"];
//    
//    
//    
//    NSString *lat = [DrConfig config].lat;
//    NSString *lon = [DrConfig config].lon;
//    [request setValue:([DrSubjectUtilities isBlankString:lon]?@"null":lon) forHTTPHeaderField:@"hlon"];
//    [request setValue:([DrSubjectUtilities isBlankString:lat]?@"null":lat) forHTTPHeaderField:@"hlat"];
//    
//    
//    
//    //时间戳
//    NSDate *localDate = [NSDate date];
//    localDate = [self getNowDateFromatAnDate:localDate];
//    NSTimeInterval date = [localDate timeIntervalSince1970]*1000;
//    NSString *timeSp = [NSString stringWithFormat:@"%.0f", date];
//    [request setValue:timeSp forHTTPHeaderField:@"htime"];
//    
//    
//    //产品ID
//    [request setValue:DR_Product_ID forHTTPHeaderField:@"hproductid"];
//    
//    if ([USERDEFAULTS objectForKey:@"jxsessionid"]) {
//        [request setValue:[USERDEFAULTS objectForKey:@"jxsessionid"] forHTTPHeaderField:@"jxsessionid"];
//    }
//    if ([USERDEFAULTS objectForKey:@"jxverifycode"]) {
//        [request setValue:[USERDEFAULTS objectForKey:@"jxverifycode"] forHTTPHeaderField:@"jxverifycode"];
//    }
//    if ([USERDEFAULTS objectForKey:@"jxphone"]) {
//        [request setValue:[USERDEFAULTS objectForKey:@"jxphone"] forHTTPHeaderField:@"jxphone"];
//    }
//    if (DRUserManagerShare.jiaxiaoID && [DRUserManagerShare.jiaxiaoID length] && ![DRUserManagerShare.jiaxiaoID isEqualToString:@"0"]) {
//        [request setValue:DRUserManagerShare.jiaxiaoID  forHTTPHeaderField:@"jxid"];
//    }
//    //随机六位数
//    NSArray *array = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];//存放十个数，以备随机取
//    NSMutableString * getStr = [[NSMutableString alloc] initWithCapacity:5];
//    NSString *changeString = [[NSMutableString alloc] initWithCapacity:6];//申请内存空间，一定要写，要不没有效果
//    for (int i = 0; i<6; i++) {
//        NSInteger index = arc4random()%([array count]-1);//循环六次，得到一个随机数，作为下标值取数组里面的数放到一个可变字符串里，在存放到自身定义的可变字符串
//        getStr = array[index];
//        changeString = (NSMutableString *)[changeString stringByAppendingString:getStr];
//        
//    }
//    [request setValue:changeString forHTTPHeaderField:@"hr"];
//    
//    
//    
//    //数字签名   happver,himei,hlat,hlon,hos,hosver,hpath,hprodctorid,hr,htime
//    NSString *sign = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@_%@_%@_%@_%@_hZLJ3qzMgFK25A2S",[DrPrefs appVersion],[UIDevice dr_deviceID],([DrSubjectUtilities isBlankString:[DrConfig config].lat]?@"null":[DrConfig config].lat),([DrSubjectUtilities isBlankString:[DrConfig config].lon]?@"null":[DrConfig config].lon),@"ios",[UIDevice dr_OSVer],urlPath,DR_Product_ID,changeString,timeSp];
//    
//    NSString *signMd5 = [SecurityUtil encryptMD5String:sign];
//    [request setValue:signMd5 forHTTPHeaderField:@"hsign"];
}


+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    return destinationDateNow;
}

+(NSString *)getCarrierName{
    
    CTTelephonyNetworkInfo  *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    
    NSString * mobilCode=[NSString stringWithFormat:@"%@",[carrier mobileNetworkCode]];
    
    NSLog(@"mobilCode==%@",mobilCode);
    
    NSString *carrierCode = nil;
    if ([mCarrier isEqualToString:@"中国移动"]) {
        carrierCode = @"1";
    }else if ([mCarrier isEqualToString:@"中国联通"]){
        carrierCode = @"2";
    }else if ([mCarrier isEqualToString:@"中国电信"]){
        carrierCode = @"3";
    }else{
        carrierCode = @"0";
        
    }
    return carrierCode;
}

+ (void)setHttpHeader:(AFHTTPSessionManager *)manager{

////    时间戳
//    NSString *time = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
//    
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",DRUserManagerShare.cityCode]                             forHTTPHeaderField:@"cityid"];
//    [manager.requestSerializer setValue:time                                                    forHTTPHeaderField:@"time"];
//    [manager.requestSerializer setValue:@"ios"                                                  forHTTPHeaderField:@"os"];
//    [manager.requestSerializer setValue:@"jkqad"                                                forHTTPHeaderField:@"type"];
//    [manager.requestSerializer setValue:[UIDevice dr_deviceID]                                  forHTTPHeaderField:@"imei"];
//    [manager.requestSerializer setValue:[UIDevice dr_IDFA]                                      forHTTPHeaderField:@"idfa"];
//    [manager.requestSerializer setValue:[UIDevice dr_OSVer]                                     forHTTPHeaderField:@"osv"];
//    [manager.requestSerializer setValue:[UIDevice dr_devicemodel]                               forHTTPHeaderField:@"model"];
//    [manager.requestSerializer setValue:@"640"                                                  forHTTPHeaderField:@"adwidth"];
//    [manager.requestSerializer setValue:@"960"                                                  forHTTPHeaderField:@"adheight"];
//    [manager.requestSerializer setValue:DR_CHANNEL_ID                                           forHTTPHeaderField:@"channelid"];
//    [manager.requestSerializer setValue:DR_Product_ID                                           forHTTPHeaderField:@"productid"];
//    [manager.requestSerializer setValue:[DrPrefs appVersion]                                    forHTTPHeaderField:@"version"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)[[NSNumber numberWithFloat:kMAIN_SCREEN_HEIGHT] integerValue]]   forHTTPHeaderField:@"screenheight"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)[[NSNumber numberWithFloat:kMAIN_SCREEN_WIDTH] integerValue]]    forHTTPHeaderField:@"screenwidth"];
//    [manager.requestSerializer setValue:DR_IssupportDeeplink                                           forHTTPHeaderField:@"issupportdeeplink"];
//    if (DRUserManagerShare.jiaxiaoID && [DRUserManagerShare.jiaxiaoID length] && ![DRUserManagerShare.jiaxiaoID isEqualToString:@"0"]) {
//        [manager.requestSerializer setValue:DRUserManagerShare.jiaxiaoID                                           forHTTPHeaderField:@"jxid"];
//    }
//
//    //广告用
//    NSString * agent=[[NSUserDefaults standardUserDefaults] objectForKey:@"WebUserAgent"];
//    if (agent) {
//        [manager.requestSerializer setValue:agent forHTTPHeaderField:@"User-Agent"];
//    }
}


@end
