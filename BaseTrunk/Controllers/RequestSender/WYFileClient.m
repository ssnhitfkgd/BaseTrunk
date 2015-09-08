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


- (void)request_send:(WYParamsBaseObject*)model cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    WYRequestSender *requestSender = [WYRequestSender requestSenderWithParams:model
                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          argumentSelector:nil];
    [requestSender send];
}
///////////////////////////////////////////////
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
