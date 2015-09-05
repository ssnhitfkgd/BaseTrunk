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
@synthesize dictParam;
@synthesize delegate;
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

+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
                     param:(NSDictionary *)dictParam
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate
          completeSelector:(SEL)theCompleteSelector
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument
{
    WYRequestSender *requestSender = [[WYRequestSender alloc] init];
    requestSender.requestUrl = theUrl;
    requestSender.usePost = isPost;
    requestSender.dictParam = dictParam;
    requestSender.delegate = theDelegate;
    requestSender.completeSelector = theCompleteSelector;
    requestSender.errorSelector = theErrorSelector;
    requestSender.cachePolicy = cholicy;
    NSLog(@"%@ \n %@", theUrl, dictParam);
    return requestSender;
    
}

- (void)send
{
    NSMutableString *queryStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [dictParam count]; i++)
    {
        NSString *key = [dictParam allKeys][i];
        NSString *value = [dictParam allValues][i];
        
        if(value && [value isKindOfClass:[NSString class]])
        {
            NSString *encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef)value,
                                                                                                  NULL,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8);
            [queryStr appendFormat:@"&%@=%@", key, encodedValue];
            
        }
        else
        {
            [queryStr appendFormat:@"&%@=%@", key, value];
        }
    }
    
  
    if(!usePost)
    {
        self.requestUrl = [self.requestUrl stringByAppendingString:[NSString stringWithFormat:@"?%@",queryStr]];
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
        [request setHTTPBody:[queryStr dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.securityPolicy.allowInvalidCertificates = YES;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(self.delegate && self.completeSelector)
        {
            if([self.delegate respondsToSelector:self.completeSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
         
                //去皮
                id object = [self transitionData:responseObject cache:NO];
                
                if (object) {
                    if ([object isKindOfClass:[NSError class]]) {
                        [self.delegate performSelector:self.errorSelector withObject:(NSError *)object];
                    }else{
                        [self.delegate performSelector:self.completeSelector withObject:object];
                    }
                }
                else if(self.errorSelector)
                {
                    [self.delegate performSelector:self.errorSelector withObject:(NSError *)object];
                }
#pragma clang diagnostic pop
            }
        }
        
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if(self.delegate && self.errorSelector)
        {
            if([self.delegate respondsToSelector:self.errorSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if(self.timesp)
                {
                    NSMutableDictionary *reasonDict = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                    [reasonDict setObject:self.timesp forKey:@"timesp"];
                    
                    NSError *errorr = [NSError errorWithDomain:ERROR_DOMAIN code:error.code userInfo:[NSDictionary dictionaryWithObject:reasonDict forKey:@"reason"]];
                    [self.delegate performSelector:self.errorSelector withObject:errorr];
                    
                }
                else
                {
                    [self.delegate performSelector:self.errorSelector withObject:error];
                    
                }
#pragma clang diagnostic pop
                
            }
        }
        
	}];
	
	[operation start];
}

- (void)uploadData:(UploadType)type
{
    NSMutableString *queryStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [dictParam count]; ++i)
    {
        NSString *key = [dictParam allKeys][i];
        NSString *value = [dictParam allValues][i];
        
        if(value && [value isKindOfClass:[NSString class]])
        {
            NSString *encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef)value,
                                                                                                  NULL,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8);
            [queryStr appendFormat:@"&%@=%@", key, encodedValue];
            
        }
        else
        {
            [queryStr appendFormat:@"&%@=%@", key, value];
            
        }
        
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:[self.requestUrl stringByAppendingFormat:@"?%@",queryStr] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
        if(self.delegate && self.completeSelector)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            //去皮

            id object = [self transitionData:responseObject cache:NO];

            if (object) {
                if ([object isKindOfClass:[NSError class]]) {
                    [self.delegate performSelector:self.errorSelector withObject:(NSError *)object];
                }else{
                    [self.delegate performSelector:self.completeSelector withObject:object];
                }
            }
#pragma clang diagnostic pop
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error : %@",error);

        if(self.delegate && self.errorSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

            if(self.timesp)
            {
                NSMutableDictionary *reasonDict = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                [reasonDict setObject:self.timesp forKey:@"timesp"];

                NSError *errorr = [NSError errorWithDomain:ERROR_DOMAIN code:error.code userInfo:[NSDictionary dictionaryWithObject:reasonDict forKey:@"reason"]];
                [self.delegate performSelector:self.errorSelector withObject:errorr];

            }
            else
            {
                [self.delegate performSelector:self.errorSelector withObject:error];

            }
            
            
#pragma clang diagnostic pop
        }
    }];
    

}

///////////////
- (id)transitionData:(NSData*)data cache:(BOOL)cache
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"%@", [json_string JSONValue]);
    if(json_string.length > 0)
    {
        if([[self.requestUrl description] hasPrefix:URL_BAIDU_IMAGE])
        {
            id responseObject = [[json_string JSONValue] objectForKey:@"data"];
            return responseObject;
        }
        
        NSDictionary *dict = [json_string JSONValue];
        
        NSString *code = [dict objectForKey:@"code"];
        if (code && ERROR_CODE_NEED_AUTH == [code intValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AgainLoginNotification object:nil];
        }else if ((code && ERROR_CODE_BLOCKED == [code intValue])) {
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_BLOCKED userInfo:[NSDictionary dictionaryWithObject:[[json_string JSONValue] objectForKey:@"data"] forKey:@"reason"]];
            
            return error;
        }else if (code && ERROR_CODE_NORMAL == [code intValue]) {
            
            if(self.timesp)
            {
                NSMutableDictionary *reasonDict = [NSMutableDictionary dictionaryWithDictionary:[json_string JSONValue]];
                if(self.timesp && reasonDict && [reasonDict isKindOfClass:[NSDictionary class]])
                {
                    [reasonDict setObject:self.timesp forKey:@"timesp"];
                }
                
                NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:[code intValue] userInfo:[NSDictionary dictionaryWithObject:reasonDict forKey:@"reason"]];

                return error;
            }
            
            
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:[code intValue] userInfo:[NSDictionary dictionaryWithObject:[[json_string JSONValue] objectForKey:@"data"] forKey:@"reason"]];
            
            return error;
        }else if (code && ERROR_CODE_SUCCESS == [code intValue]){
            id responseObject = [[json_string JSONValue] objectForKey:@"data"];
            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *reasonDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                if(self.timesp && reasonDict && [reasonDict isKindOfClass:[NSDictionary class]])
                {
                    [reasonDict setObject:self.timesp forKey:@"timesp"];
                }
                
                [reasonDict setObject:[NSNumber numberWithBool:cache] forKey:@"cache"];
                return reasonDict;
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
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:1024 userInfo:[NSDictionary dictionaryWithObject:json_string forKey:@"reason"]];
            
            return error;
        }
    }
    
    return nil;
}

@end