//
//  WYFileClient.m
//
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "WYFileClient.h"
#import "Reachability.h"
#import "DateUtil.h"
#import "Global.h"


@implementation WYFileClient

#pragma mark -
#pragma mark Client Functions


+ (instancetype)sharedInstance
{
    static WYFileClient *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Login

- (id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];

        
        [reach startNotifier];
    }
    
    return self;
}

- (int)getNetworkingType
{
    return nNetworkingType;
}

- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            nNetworkingType = 0;
            NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            nNetworkingType = 1;
            NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            nNetworkingType = 2;
            NSLog(@"正在使用wifi网络");
            break;
        default:
            nNetworkingType = 1;
            break;
    }
}

- (NSMutableDictionary*)getDefaultParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"iPhone" forKey:@"client_type"];
    [params setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"client_version"];
    return params;
}

/**
 *推送绑定
 
 *请求地址
 *push_token
 */
- (void)push_bind:(NSString*)push_token cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
//    NSString *token = [self getToken];
//    if(token)
    {
        NSMutableDictionary *params = [self getDefaultParams];
//        [params setObject:token forKey:@"token"];
        [params setObject:push_token forKey:@"push_token"];
        
        WYRequestSender *requestSender = [WYRequestSender requestSenderWithURL:[self getServerApiUrl:@"push_bind"]
                                                                       usePost:YES
                                                                         param:params
                                                                   cachePolicy:cholicy
                                                                      delegate:theDelegate
                                                              completeSelector:theSelector
                                                                 errorSelector:theSelectorError
                                                              selectorArgument:nil];
        [requestSender send];
    }
}


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
- (void)all_host:(int)limit offsetId:(NSString*)offset_id cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{

    NSMutableDictionary *params = [self getDefaultParams];
    [params setObject:[NSNumber numberWithInt:limit] forKey:@"limit"];
    [params setObject:offset_id forKey:@"offset_id"];
    NSTimeInterval since1970times = [[NSDate date] timeIntervalSince1970];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)since1970times] forKey:@"t"];
    
    
     id since = [[NSUserDefaults standardUserDefaults] objectForKey:@"since1970times"];
    if(since)
    {
        [params setObject:since forKey:@"t"];
    }
    WYRequestSender *requestSender = [WYRequestSender requestSenderWithURL:[self getServerApiUrl:@"all_host.json"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
    
}

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
- (void)live_host:(int)limit offsetId:(NSString*)offset_id cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    
    NSMutableDictionary *params = [self getDefaultParams];
    [params setObject:[NSNumber numberWithInt:limit] forKey:@"limit"];
    [params setObject:offset_id forKey:@"offset_id"];
    
    NSTimeInterval since1970times = [[NSDate date] timeIntervalSince1970];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)since1970times] forKey:@"t"];

    WYRequestSender *requestSender = [WYRequestSender requestSenderWithURL:[self getServerApiUrl:@"host_live.json"]
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
    
}

///////////////////////////////////////////////
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
