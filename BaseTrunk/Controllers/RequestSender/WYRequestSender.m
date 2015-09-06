//
//  WYRequestSender.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "WYRequestSender.h"
#import "AFHTTPRequestOperation.h"
#import "WYFileClient.h"
#import "SBJson.h"
#import "FMLogger.h"
#import "FileUtil.h"


static const float TIME_OUT_INTERVAL = 10.0f;


typedef enum
{
    ERROR_CODE_SUCCESS = 0,
    ERROR_CODE_NORMAL,
    ERROR_CODE_NEED_AUTH,
    ERROR_CODE_BLOCKED,

}API_GET_CODE;

@implementation WYRequestSender
@synthesize progressSelector;
@synthesize requestUrl;
@synthesize usePost;
@synthesize requestParamDictionary;
@synthesize requestDelegate;
@synthesize completeSelector;
@synthesize errorSelector;
@synthesize cachePolicy;
@synthesize filePath;

+ (instancetype)currentClient
{
    static WYRequestSender *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedInstance = [[WYRequestSender alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        [sharedInstance.operationQueue setMaxConcurrentOperationCount:1];
    });
    return sharedInstance;
}

+ (id)requestSenderWithURL:(NSString *)url
                   usePost:(BOOL)isPost
                     param:(NSDictionary *)requestParams
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)requestDelegate
          completeSelector:(SEL)completeSelector
             errorSelector:(SEL)errorSelector
          selectorArgument:(id)selectorArgument
{
    WYRequestSender *requestSender = [[WYRequestSender alloc] init];
    requestSender.requestUrl = url;
    requestSender.usePost = isPost;
    requestSender.requestParamDictionary = requestParams;
    requestSender.requestDelegate = requestDelegate;
    requestSender.completeSelector = completeSelector;
    requestSender.errorSelector = errorSelector;
    requestSender.cachePolicy = cholicy;
    NSLog(@"%@ \n %@", url, requestParams);
    return requestSender;
    
}

- (void)send
{
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    for (int i = 0; i < [requestParamDictionary count]; i++)
    {
        NSString *key = [requestParamDictionary allKeys][i];
        NSString *value = [requestParamDictionary allValues][i];
        
        if(value && [value isKindOfClass:[NSString class]])
        {
            NSString *encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef)value,
                                                                                                  NULL,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8);
            [bodyString appendFormat:@"&%@=%@", key, encodedValue];
            
        }
        else
        {
            [bodyString appendFormat:@"&%@=%@", key, value];
        }
    }
    
  
    if(!usePost)
    {
        self.requestUrl = [self.requestUrl stringByAppendingString:[NSString stringWithFormat:@"?%@",bodyString]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]
                                                           cachePolicy:self.cachePolicy//
                                                       timeoutInterval:TIME_OUT_INTERVAL];
    
    
    //百度搜图添加httpHeader
    if ([[self.requestUrl description] hasPrefix:URL_BAIDU_IMAGE]) {
        [request setValue:@"http://image.baidu.com/i?tn=baiduimage" forHTTPHeaderField:@"Referer"];
        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146" forHTTPHeaderField:@"User-Agent"];
    }
    
    
    
    [request setHTTPMethod:usePost?@"POST":@"GET"];
    if(usePost)
    {
        [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.securityPolicy.allowInvalidCertificates = YES;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(self.requestDelegate && self.completeSelector)
        {
            if([self.requestDelegate respondsToSelector:self.completeSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
         
                //去皮
                id object = [self transitionData:responseObject cache:NO];
                
                if (object) {
                    if ([object isKindOfClass:[NSError class]]) {
                        [self.requestDelegate performSelector:self.errorSelector withObject:(NSError *)object];
                    }else{
                        [self.requestDelegate performSelector:self.completeSelector withObject:object];
                    }
                }
                else if(self.errorSelector)
                {
                    [self.requestDelegate performSelector:self.errorSelector withObject:(NSError *)object];
                }
#pragma clang diagnostic pop
            }
        }
        
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if(self.requestDelegate && self.errorSelector)
        {
            if([self.requestDelegate respondsToSelector:self.errorSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if(self.timesp)
                {
                    NSMutableDictionary *reasonDict = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                    [reasonDict setObject:self.timesp forKey:@"timesp"];
                    
                    NSError *errorr = [NSError errorWithDomain:ERROR_DOMAIN code:error.code userInfo:[NSDictionary dictionaryWithObject:reasonDict forKey:@"reason"]];
                    [self.requestDelegate performSelector:self.errorSelector withObject:errorr];
                    
                }
                else
                {
                    [self.requestDelegate performSelector:self.errorSelector withObject:error];
                    
                }
#pragma clang diagnostic pop
                
            }
        }
        
	}];
	
	[operation start];
}

- (void)uploadData:(UploadType)type
{
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    for (int i = 0; i < [requestParamDictionary count]; ++i)
    {
        NSString *key = [requestParamDictionary allKeys][i];
        NSString *value = [requestParamDictionary allValues][i];
        
        if(value && [value isKindOfClass:[NSString class]])
        {
            NSString *encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef)value,
                                                                                                  NULL,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8);
            [bodyString appendFormat:@"&%@=%@", key, encodedValue];
            
        }
        else
        {
            [bodyString appendFormat:@"&%@=%@", key, value];
            
        }
        
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:[self.requestUrl stringByAppendingFormat:@"?%@",bodyString] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
            switch (type) {
                case UploadTypePicture:
                {
                    //悄悄话 图片压缩至100kb以内
                    NSData * data = UIImageJPEGRepresentation(self.image, 1.0);
                    for (float i = 1.0; [data length] > 102400 && i > 0.0; i = i-0.1) {
                        data = UIImageJPEGRepresentation(self.image, i);
                    }

                    [formData appendPartWithFileData:data name:@"photo" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                }
                 
                    break;
                default:
                    break;
            }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(self.requestDelegate && self.completeSelector)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            //去皮

            id object = [self transitionData:responseObject cache:NO];

            if (object) {
                if ([object isKindOfClass:[NSError class]]) {
                    [self.requestDelegate performSelector:self.errorSelector withObject:(NSError *)object];
                }else{
                    [self.requestDelegate performSelector:self.completeSelector withObject:object];
                }
            }
#pragma clang diagnostic pop
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error : %@",error);

        if(self.requestDelegate && self.errorSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

            if(self.timesp)
            {
                NSMutableDictionary *reasonDict = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                [reasonDict setObject:self.timesp forKey:@"timesp"];

                NSError *errorr = [NSError errorWithDomain:ERROR_DOMAIN code:error.code userInfo:[NSDictionary dictionaryWithObject:reasonDict forKey:@"reason"]];
                [self.requestDelegate performSelector:self.errorSelector withObject:errorr];

            }
            else
            {
                [self.requestDelegate performSelector:self.errorSelector withObject:error];

            }
            
            
#pragma clang diagnostic pop
        }
    }];
    

}

///////////////
- (id)transitionData:(NSData*)data cache:(BOOL)cache
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"%@", [jsonString JSONValue]);
    if(jsonString.length > 0)
    {
        if([[self.requestUrl description] hasPrefix:URL_BAIDU_IMAGE])
        {
            id responseObject = [[jsonString JSONValue] objectForKey:@"data"];
            return responseObject;
        }
        
        NSDictionary *dict = [jsonString JSONValue];
        
        NSString *code = [dict objectForKey:@"code"];
        if (code && ERROR_CODE_NEED_AUTH == [code intValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AgainLoginNotification object:nil];
        }else if ((code && ERROR_CODE_BLOCKED == [code intValue])) {
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_BLOCKED userInfo:[NSDictionary dictionaryWithObject:[dict objectForKey:@"data"] forKey:@"reason"]];
            
            return error;
        }else if (code && ERROR_CODE_NORMAL == [code intValue]) {
            
            if(self.timesp)
            {
                NSMutableDictionary *reasonDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
                if(self.timesp && reasonDictionary && [reasonDictionary isKindOfClass:[NSDictionary class]])
                {
                    [reasonDictionary setObject:self.timesp forKey:@"timesp"];
                }
                
                NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:[code intValue] userInfo:[NSDictionary dictionaryWithObject:reasonDictionary forKey:@"reason"]];

                return error;
            }
            
            
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:[code intValue] userInfo:[NSDictionary dictionaryWithObject:[dict objectForKey:@"data"] forKey:@"reason"]];
            
            return error;
        }else if (code && ERROR_CODE_SUCCESS == [code intValue]){
            id responseObject = [dict objectForKey:@"data"];
            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *reasonDictionary = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                if(self.timesp && reasonDictionary && [reasonDictionary isKindOfClass:[NSDictionary class]])
                {
                    [reasonDictionary setObject:self.timesp forKey:@"timesp"];
                }
                
                [reasonDictionary setObject:[NSNumber numberWithBool:cache] forKey:@"cache"];
                return reasonDictionary;
            }

            if(self.timesp && [self.timesp length] > 0)
            {
                if(responseObject && [responseObject isKindOfClass:[NSArray class]])
                {
                    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
                    {
                        [mutableDictionary setObject:self.timesp forKey:@"timesp"];
                        [mutableDictionary setObject:responseObject forKey:@"data"];

                    }
                    return mutableDictionary;
                    
                }
               
            }

            return responseObject;
        }else{
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:1024 userInfo:[NSDictionary dictionaryWithObject:jsonString forKey:@"reason"]];
            
            return error;
        }
    }
    
    return nil;
}

@end