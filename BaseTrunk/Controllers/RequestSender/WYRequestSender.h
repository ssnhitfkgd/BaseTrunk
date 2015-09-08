//
//  WYRequestSender.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "WYParamsBaseObject.h"

//uploadtype
typedef NS_ENUM(NSUInteger, UploadType){
	UploadTypePicture = 0,
};

@interface WYRequestSender : AFHTTPRequestOperationManager

@property (nonatomic, weak)   id requestDelegate;
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, strong) WYParamsBaseObject *paramsObject;

@property (nonatomic) SEL completeSelector;
@property (nonatomic) SEL errorSelector;
@property (nonatomic) SEL argumentSelector;

+ (id)requestSenderWithParams:(id)params
                       cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                          delegate:(id)requestDelegate
                  completeSelector:(SEL)completeSelector
                     errorSelector:(SEL)errorSelector
                  argumentSelector:(SEL)argumentSelector;

- (void)send;
- (void)uploadData:(UploadType)type;
+ (instancetype)currentClient;
@end
