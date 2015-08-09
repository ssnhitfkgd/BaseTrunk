//
//  WYFileClient.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "WYFileClient.h"
#import "Reachability.h"


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



- (void)list_image_baidu:(int)limit offsetId:(int)offset_id text:(NSString*)text cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"baiduimagejson" forKey:@"tn"];
    [params setObject:text forKey:@"word"];
    [params setObject:[NSNumber numberWithInt:limit]  forKey:@"rn"];
    [params setObject:[NSNumber numberWithInt:offset_id]  forKey:@"pn"];
    
    //Wi-Fi下请求大尺寸
    if ([self getNetworkingType] ==2) {
        [params setObject:@"3" forKey:@"z"];
    }else {
        [params setObject:@"2" forKey:@"z"];//中尺寸
    }
    
    [params setObject:@"utf-8" forKey:@"ie"];//input utf-8
    [params setObject:@"utf-8" forKey:@"oe"];//oe=utf-8
    
    //[params setObject:@"iPhone" forKey:@"client_type"];
    
    WYRequestSender *requestSender = [WYRequestSender requestSenderWithURL:@"http://image.baidu.com/i"
                                                                   usePost:NO
                                                                     param:params
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
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
