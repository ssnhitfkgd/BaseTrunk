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
typedef enum{
    
	UploadTypePicture = 0,

} UploadType;

@interface WYRequestSender : AFHTTPRequestOperationManager

@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, strong) NSDictionary *dictParam;
@property (nonatomic, weak) id delegate;
@property (nonatomic) SEL completeSelector;
@property (nonatomic) SEL errorSelector;
@property (nonatomic) SEL progressSelector;
@property (nonatomic, assign) BOOL usePost;
@property (nonatomic, assign)NSURLRequestCachePolicy cachePolicy;

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *filePath;
@property (nonatomic, strong)NSString *timesp;

+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
                     param:(NSDictionary *)dictParam
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate
          completeSelector:(SEL)theCompleteSelector
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument;

- (void)send;
- (void)uploadData:(UploadType)type;
+ (instancetype)currentClient;
@end
