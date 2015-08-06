//
//  WYConfig.m
//
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "WYConfig.h"

@implementation WYConfig

- (NSString*)serverURL
{
#ifndef __OPTIMIZE__
    return @"http://42.96.186.99:1025/";
#else
    return @"https://api.71ao.cn/yoyo/";
#endif
    
}

- (NSString*)applicationVersion
{
    return @"1";
}

- (NSString*)getServerApiUrl:(NSString*)api
{
    return [NSString stringWithFormat:@"%@%@%@",[self serverURL],[self applicationVersion],api];
}

- (NSString*)getServerApiVersion:(NSString*)version Url:(NSString*)api
{
    return [NSString stringWithFormat:@"%@%@/%@",[self serverURL],version,api];
}
@end
