//
//  WYFileClient.h
//
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WYRequestSender.h"
#import "WYConfig.h"


@interface WYFileClient : WYConfig
{
    int nNetworkingType;
}

+ (instancetype)sharedInstance;
- (int)getNetworkingType;

/**
 *推送绑定
 
 *请求地址
 *push_token
 */
- (void)push_bind:(NSString*)push_token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

/**
 主播列表
 获取主播列表
 
 协议¶
 HTTP
 
 地址
 /resource/data/all_host.json
 
 请求参数
 无
 */
- (void)all_host:(int)limit offsetId:(NSString*)offset_id cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

/**
 主播列表
 获取主播列表
 
 协议¶
 HTTP
 
 地址
 /resource/data/live_host.json
 
 请求参数
 无
 */
- (void)live_host:(int)limit offsetId:(NSString*)offset_id cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
@end


