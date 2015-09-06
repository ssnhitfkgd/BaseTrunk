//
//  WYRequestSender.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//uploadtype
typedef NS_ENUM(NSUInteger, UploadType){
    
	UploadTypePicture = 0,

};

@interface WYRequestSender : AFHTTPRequestOperationManager

@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, strong) NSDictionary *requestParamDictionary;
@property (nonatomic, weak) id requestDelegate;
@property (nonatomic) SEL completeSelector;
@property (nonatomic) SEL errorSelector;
@property (nonatomic) SEL progressSelector;
@property (nonatomic, assign) BOOL usePost;
@property (nonatomic, assign)NSURLRequestCachePolicy cachePolicy;

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *filePath;
@property (nonatomic, strong)NSString *timesp;

+ (id)requestSenderWithURL:(NSString *)url
                   usePost:(BOOL)isPost
                     param:(NSDictionary *)requestParams
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)requestDelegate
          completeSelector:(SEL)completeSelector
             errorSelector:(SEL)errorSelector
          selectorArgument:(id)selectorArgument;

- (void)send;
- (void)uploadData:(UploadType)type;
+ (instancetype)currentClient;
@end
