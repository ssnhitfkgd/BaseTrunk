
//
//  WYSocketObject.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYDataModelBase.h"
#import "GCDAsyncSocket.h"

typedef NS_ENUM(NSInteger, SOCKET_TAG)
{
    SOCKET_TAG_AUTH_RQ = 0,
    SOCKET_TAG_HBT_RQ,
    SOCKET_TAG_DATA_RQ,
    SOCKET_TAG_COM,
};

@protocol WYSocketObjectDelegate <NSObject>
- (void)socketReceiveData:(id)data;
@end


@interface WYSocketObject : NSObject
{
    GCDAsyncSocket *asyncSocket;
    NSString *host;
    uint16_t port;
    NSString *socket_id;
    BOOL disconnect;
}

@property (nonatomic, weak) id<WYSocketObjectDelegate>  delegate;
@property (nonatomic, strong) NSArray *revDataArray;

+ (WYSocketObject *)sharedInstance;

- (void)initSocket;

- (void)hbt_rq:(NSString*)sock_id;

- (void)hbt_rp:(NSString*)sock_id;

- (void)data_rq:(NSString*)data sock_id:(NSString*)sock_id;

- (void)ack:(NSString*)sock_id;

- (void)dealError:(NSString*)resID;

- (void)disconnect;

- (void)resume;
@end
