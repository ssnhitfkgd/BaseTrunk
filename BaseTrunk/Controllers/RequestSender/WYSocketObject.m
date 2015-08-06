//
//  WYSocketObject.m
//  
//
//  Created by wangyong on 13-7-12.
//
//

#import "WYSocketObject.h"
#import "WYUserInfoDto.h"
#import "SBJson.h"

@interface GCDAsyncSocketPreBuffer : NSObject

- (id)initWithCapacity:(size_t)numBytes;

- (void)ensureCapacityForWrite:(size_t)numBytes;

- (size_t)availableBytes;
- (uint8_t *)readBuffer;

- (void)getReadBuffer:(uint8_t **)bufferPtr availableBytes:(size_t *)availableBytesPtr;

- (size_t)availableSpace;
- (uint8_t *)writeBuffer;

- (void)getWriteBuffer:(uint8_t **)bufferPtr availableSpace:(size_t *)availableSpacePtr;

- (void)didRead:(size_t)bytesRead;
- (void)didWrite:(size_t)bytesWritten;

- (void)reset;

@end


static const float TIME_OUT_INTERVAL = 30.0f;

@implementation WYSocketObject
@synthesize revDataArray;
@synthesize delegate;

static WYSocketObject* _sharedInstance = nil;

+ (WYSocketObject *)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
            _sharedInstance = [[WYSocketObject alloc] init];
    }
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
     
        self.revDataArray = [NSArray arrayWithObjects:[[NSMutableData alloc] init], [[NSMutableData alloc] init], [[NSMutableData alloc] init], [[NSMutableData alloc] init], nil];

        //[self initSocket];
    }
    return self;
}

- (void)initSocket
{
    disconnect = NO;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
	
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    //[socket setAutoDisconnectOnClosedReadStream:NO];
    
    
    host = [WYUserInfoDto sharedInstance].host;
    port = 9904;
    
    NSError *err = nil;
    if (![asyncSocket connectToHost:host onPort:port withTimeout:TIME_OUT_INTERVAL error:&err])
    {
        NSLog(@"socket error : %@",err);
    }
    
}

- (void)auth_rq
{
    
    NSString *auth_rq_string = [NSString stringWithFormat:@"{\"id\":\"%@\",\"type\":\"auth_rq\",\"token\":\"%@\"}\n",[WYUserInfoDto sharedInstance].user_id,[WYUserInfoDto sharedInstance].token];
    if(auth_rq_string)
    {
        NSData *data = [auth_rq_string dataUsingEncoding:NSUTF8StringEncoding];
        [asyncSocket writeData:data withTimeout:-1 tag:SOCKET_TAG_AUTH_RQ];
    }
    
}

- (void)hbt_rq:(NSString*)sock_id
{
    
    //AccountDTO * account= [AccountDTO sharedInstance];
    NSString *hbt_rq_string = [NSString stringWithFormat:@"{\"id\":\"%@\",\"type\":\"hbt_rq\"}\n",sock_id];
    if(hbt_rq_string)
    {
        NSData *data = [hbt_rq_string dataUsingEncoding:NSUTF8StringEncoding];
        [asyncSocket writeData:data withTimeout:-1 tag:SOCKET_TAG_HBT_RQ];
    }
    
    //NSLog(@"socket hbt rq request %@--%@",sock_id,[[NSDate date] description]);
    [self performSelector:@selector(hbt_rq:) withObject:sock_id afterDelay:20];
}

- (void)hbt_rp:(NSString*)sock_id
{
    //AccountDTO * account= [AccountDTO sharedInstance];
    NSString *hbt_rp_string = [NSString stringWithFormat:@"{\"id\":\"%@\",\"type\":\"hbt_rp\"}\n",sock_id];
    if(hbt_rp_string)
    {
        NSData *data = [hbt_rp_string dataUsingEncoding:NSUTF8StringEncoding];
        [asyncSocket writeData:data withTimeout:-1 tag:SOCKET_TAG_HBT_RQ];
    }
    
}

- (void)data_rq:(NSString*)data sock_id:(NSString*)sock_id
{
    
    NSString *data_rq_string = [NSString stringWithFormat:@"{\"id\":\"%@\",\"type\":\"data\",\"data\":\"%@\"}\n",sock_id,data];
    if(data_rq_string)
    {
        NSData *data = [data_rq_string dataUsingEncoding:NSUTF8StringEncoding];
        [asyncSocket writeData:data withTimeout:-1 tag:SOCKET_TAG_DATA_RQ];
    }
}

- (void)ack:(NSString*)sock_id
{
    //AccountDTO * account= [AccountDTO sharedInstance];
    
    NSString *ack_rq_string = [NSString stringWithFormat:@"{\"id\":\"%@\",\"type\":\"ack\"}\n", sock_id];
    if(ack_rq_string)
    {
        NSData *data = [ack_rq_string dataUsingEncoding:NSUTF8StringEncoding];
        [asyncSocket writeData:data withTimeout:-1 tag:SOCKET_TAG_COM];
    }
    
    
}

#pragma socket delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    disconnect = YES;

    
    NSDictionary *options =
    
    [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
    
    
    
    [sock startTLS:options];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    [asyncSocket readDataWithTimeout:-1 tag:0];
    [self auth_rq];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
    if(asyncSocket && asyncSocket.isDisconnected)
    {
        disconnect = NO;
        [self resume];
    }
  
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{

    [asyncSocket readDataWithTimeout:-1 tag:0];
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *httpResponseArray = [httpResponse componentsSeparatedByString:@"\n"];
    if(httpResponseArray && [httpResponseArray isKindOfClass:[NSArray class]])
    {
        if([httpResponseArray count] > 2)
        {
            for(NSString *string in httpResponseArray)
            {
                if(string.length == 0)
                {
                    return;
                }
                
                [self socket:sock didReadData:[[string stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding] withTag:tag];

            }
        }
    }
    
    //NSLog(@"socket:%p didReadData:%ld info:%@", sock, tag,httpResponse);
    
    if(![httpResponse rangeOfString:@"\n"].length)
    {
        [self.revDataArray[tag] appendData:data];
    }
    else
    {
        [self.revDataArray[tag] appendData:data];
        httpResponse = [[NSString alloc] initWithData:self.revDataArray[tag] encoding:NSUTF8StringEncoding];
        [self.revDataArray[tag] setData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
        if(httpResponse)
        {
            id obj = [httpResponse JSONValue];
            if(obj && [obj isKindOfClass:[NSDictionary class]])
            {
                id resID = [WYDataModelBase getStrValue:[obj objectForKey:@"id"]];//1408161430060
                //NSLog(@"socket_id:           %@",resID);
                id resType = [WYDataModelBase getStrValue:[obj objectForKey:@"type"]];
                
                if([resType isEqualToString:@"error"])
                {
                    [self dealError:resID];
                    return;
                }
                
                if(resID && resType)
                {
                    if([resType isEqualToString:@"auth_rp"])
                    {
                        [self performSelector:@selector(hbt_rq:) withObject:resID afterDelay:20];
                    }
                    else if([resType isEqualToString:@"hbt_rp"])
                    {
//                        if(resID && ![resID isEqualToString:socket_id])
//                        {
//                            [self dealError:resID];
//                            return;
//                        }
                        
                    }
                    else if(resType && [resType isEqualToString:@"data"])
                    {

                        [self ack:resID];
                        
                        id data = [obj objectForKey:@"data"];
                        if(data && [data isKindOfClass:[NSDictionary class]])
                        {
                            if(delegate && [delegate respondsToSelector:@selector(socketReceiveData:)])
                            {
                                [delegate performSelector:@selector(socketReceiveData:) withObject:data];
                            }
                            else
                            {
                                id userObj = [data objectForKey:@"user"];
                                if(userObj && [userObj isKindOfClass:[NSDictionary class]])
                                {
                                    id userID = [userObj objectForKey:@"id"];
                                    if(userID && [userID isKindOfClass:[NSString class]])
                                    {
                                        id userMsgCount = [[NSUserDefaults standardUserDefaults] objectForKey:userID];
                                        //if(userMsgCount)
                                        {
                                            //保存数据到本地 做列表消息数提示用
                                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",userMsgCount?([userMsgCount intValue]+1):1] forKey:userID];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                        }
                                    }
                                }
                                
//                                        userObj = [data objectForKey:@"user_message"];
//                                        if(userObj && [userObj isKindOfClass:[NSDictionary class]])
//                                        {
//                                            NSLog(@"userObj ==  %@",userObj);
//                                            WPDBModel *model = [[WPDBModel alloc] initWithJsonDictionary:userObj];
//                                            [[WPDataFactory shardDataFactory] insertToDB:model Classtype:CHAT_MSG_TYPE_TEXT];
//                                        }

                                
                            }
                        }
                        
                    }
                    else
                    {
                        [self resume];
                    }
                    
                    //socket_id = resID;
                }
            }
            
        }
    }
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];//可以成功取消全部
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    if(!disconnect)
    {
        int rand =  arc4random() % 10;
        if(rand < 2){
            rand = 2 + rand;
        }
        [self performSelector:@selector(resume) withObject:nil afterDelay:rand];
      
    }
}

//- (void)onSocket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err{
//    [[self class] cancelPreviousPerformRequestsWithTarget:self];//可以成功取消全部
//    //NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
//    [self performSelector:@selector(resume) withObject:nil afterDelay:5];
//}

- (void)dealError:(NSString*)resID
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];//可以成功取消全部
    if(asyncSocket.isDisconnected)
    {
        int rand =  arc4random() % 10;
        if(rand < 2){
            rand = 2 + rand;
        }
        [self performSelector:@selector(resume) withObject:nil afterDelay:rand];
    }
    else
    {
        [self performSelector:@selector(hbt_rq:) withObject:resID afterDelay:2];
    }
}

- (void)resume
{
    if(!asyncSocket || (asyncSocket && !asyncSocket.isConnected))
    {
        [self disconnect];
        [self initSocket];
    }
}

- (void)disconnect
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];//可以成功取消全部

    if(asyncSocket)
    {
        [asyncSocket disconnect];
        asyncSocket = nil;
    }
}

@end
