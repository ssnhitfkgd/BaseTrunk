//
//  WYFileClient.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
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


- (void)list_image_baidu:(NSInteger)limit offsetId:(NSInteger)offset_id text:(NSString*)text cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
@end


