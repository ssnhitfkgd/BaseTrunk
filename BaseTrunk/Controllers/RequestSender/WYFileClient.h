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
#import "WYParamsBaseObject.h"

@interface WYFileClient : WYConfig
{
    int nNetworkingType;
}

+ (instancetype)sharedInstance;
- (int)getNetworkingType;


- (void)request_send:(WYParamsBaseObject*)model cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

@end


