//
//  WPUserInfoDto.h
//  Whisper
//
//  Created by wangyong on 14-3-8.
//  Copyright (c) 2014年 Whisper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYDataModelBase.h"
#import <MapKit/MapKit.h>

@interface WYUserInfoDto : WYDataModelBase

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *device_id;
@property (nonatomic, copy) NSString *push_token;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *host;


- (BOOL)parseUserInfo:(NSDictionary *)user_dict;

+ (instancetype)sharedInstance;
+ (void)saveUserInfo:(WYUserInfoDto *)loginUserInfo;
+ (void)cleanAccountDTO;
+ (void)activeLoginUserInfo;
+ (WYUserInfoDto *)loginUserInfo;
- (NSString*)getToken;
@end
