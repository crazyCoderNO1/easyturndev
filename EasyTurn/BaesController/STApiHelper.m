//
//  STApiHelper.m
//  Stone
//
//  Created by song on 2018/7/16.
//  Copyright © 2018年 song. All rights reserved.
//

#import "STApiHelper.h"
@implementation STApiHelper

+ (NSString *)urlWithHost:(NSString *)host path:(NSString *)path file:(NSString *)file {
    return [NSString stringWithFormat:@"%@%@%@", host, path ? path : @"", file ? file : @""];
}

+ (NSDictionary *)signNeedOptionParams:(NSDictionary *)params {
    
    NSString *token = [UserInfoModel loadUserInfoModel].token;
//    NSString *times = [self timeInterval];
//    NSString *sign = [NSString stringWithFormat:@"%@sszb",times];
//    NSString *signMD5 = [sign ak_md5];
//    NSString *fisetStr = [signMD5 substringToIndex:4];
//    NSString *lastStr = [signMD5 substringFromIndex:4];
//    NSString *signStr = [NSString stringWithFormat:@"%@%@",lastStr,fisetStr];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableDict setValue:token forKey:@"token"];
//    [mutableDict setValue:times forKey:@"times"];
//    [mutableDict setValue:signStr forKey:@"sign"];
    return mutableDict;
}


//时间戳
+ (NSString *)timeInterval {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSMutableString *appId = [NSMutableString stringWithFormat:@"%.0f", a]; //转为字符型
    return appId;
}
@end
