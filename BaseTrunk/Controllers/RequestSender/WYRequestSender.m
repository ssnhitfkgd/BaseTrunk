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
#import <objc/runtime.h>


static const float TIME_OUT_INTERVAL = 10.0f;


typedef enum
{
    ERROR_CODE_SUCCESS = 0,
    ERROR_CODE_NORMAL,
    ERROR_CODE_NEED_AUTH,
    ERROR_CODE_BLOCKED,

}API_GET_CODE;

@implementation WYRequestSender
@synthesize argumentSelector;
@synthesize requestDelegate;
@synthesize completeSelector;
@synthesize errorSelector;
@synthesize cachePolicy;

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

+ (id)requestSenderWithParams:(id)params
                  cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                     delegate:(id)requestDelegate
             completeSelector:(SEL)completeSelector
                errorSelector:(SEL)errorSelector
             argumentSelector:(SEL)argumentSelector;
{
    WYRequestSender *requestSender = [[WYRequestSender alloc] init];
    requestSender.requestDelegate = requestDelegate;
    requestSender.completeSelector = completeSelector;
    requestSender.errorSelector = errorSelector;
    requestSender.argumentSelector = argumentSelector;
    requestSender.cachePolicy = cachePolicy;
    requestSender.paramsObject = params;
    return requestSender;
    
}

- (void)send
{
    NSString *bodyString = [self httpBodyString:self.paramsObject];
    NSString *url = self.paramsObject.url;
    
    if(!self.paramsObject.post)
    {
        url = [self.paramsObject.url stringByAppendingString:[NSString stringWithFormat:@"?%@",bodyString]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:self.cachePolicy//
                                                       timeoutInterval:TIME_OUT_INTERVAL];
    
    
    //百度搜图添加httpHeader
    if ([[url description] hasPrefix:URL_BAIDU_IMAGE]) {
        [request setValue:@"http://image.baidu.com/i?tn=baiduimage" forHTTPHeaderField:@"Referer"];
        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146" forHTTPHeaderField:@"User-Agent"];
    }
    
    
    
    [request setHTTPMethod:self.paramsObject.post?@"POST":@"GET"];
    if(self.paramsObject.post)
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
                if(self.paramsObject.timesp)
                {
                    NSMutableDictionary *reasonDict = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                    [reasonDict setObject:self.paramsObject.timesp forKey:@"timesp"];
                    
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
    NSString *bodyString = [self httpBodyString:self.paramsObject];
    NSString *url = self.paramsObject.url;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:[url stringByAppendingFormat:@"?%@",bodyString] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
            switch (type) {
                case UploadTypePicture:
                {
                    //悄悄话 图片压缩至100kb以内
                    NSData * data = UIImageJPEGRepresentation(self.paramsObject.file, 1.0);
                    for (float i = 1.0; [data length] > 102400 && i > 0.0; i = i-0.1) {
                        data = UIImageJPEGRepresentation(self.paramsObject.file, i);
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

            if(self.paramsObject.timesp)
            {
                NSMutableDictionary *reasonDict = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                [reasonDict setObject:self.paramsObject.timesp forKey:@"timesp"];

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
    jsonString = [self removeUnescapedCharacter:jsonString];
    NSLog(@"%@", [jsonString JSONValue]);
    if(jsonString.length > 0)
    {
        if([[self.paramsObject.url description] hasPrefix:URL_BAIDU_IMAGE])
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
            
            if(self.paramsObject.timesp)
            {
                NSMutableDictionary *reasonDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
                if(self.paramsObject.timesp && reasonDictionary && [reasonDictionary isKindOfClass:[NSDictionary class]])
                {
                    [reasonDictionary setObject:self.paramsObject.timesp forKey:@"timesp"];
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
                if(self.paramsObject.timesp && reasonDictionary && [reasonDictionary isKindOfClass:[NSDictionary class]])
                {
                    [reasonDictionary setObject:self.paramsObject.timesp forKey:@"timesp"];
                }
                
                [reasonDictionary setObject:[NSNumber numberWithBool:cache] forKey:@"cache"];
                return reasonDictionary;
            }

            if(self.paramsObject.timesp && [self.paramsObject.timesp length] > 0)
            {
                if(responseObject && [responseObject isKindOfClass:[NSArray class]])
                {
                    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
                    {
                        [mutableDictionary setObject:self.paramsObject.timesp forKey:@"timesp"];
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

//return http body
- (NSString *)httpBodyString:(id)params
{
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    
    Class cls = [params class];
    
    unsigned int ivarsCnt = 0;
    objc_property_t *propertys = class_copyPropertyList(cls, &ivarsCnt);
    
    for (const objc_property_t *p = propertys; p < propertys + ivarsCnt; ++p)
    {
        objc_property_t const ivar = *p;
        
        NSString *key = [NSString stringWithUTF8String:property_getName(ivar)];
        id value = [params valueForKey:key];
        
        if(value)
        {
            if(! [value isKindOfClass:[NSString class]])
            {
                value = [NSString stringWithFormat:@"%@",value];
            }
            
            NSString *encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef)value,
                                                                                                  NULL,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8);
            [bodyString appendFormat:@"&%@=%@", key, encodedValue];
            
        }
    }
    
    return bodyString;
}

- (NSString *)removeUnescapedCharacter:(NSString *)inputStr{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    //获取那些特殊字符
    NSRange range = [inputStr rangeOfCharacterFromSet:controlChars];
    //寻找字符串中有没有这些特殊字符
    if (range.location != NSNotFound)
    {
        NSMutableString *mutable = [NSMutableString stringWithString:inputStr];
        while (range.location != NSNotFound)
        {
            [mutable deleteCharactersInRange:range];
            //去掉这些特殊字符
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputStr;}
    
@end