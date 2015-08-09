//
//  WYConfig.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface WYConfig : NSObject

- (NSString*)getServerApiUrl:(NSString*)api;
- (NSString*)getServerApiVersion:(NSString*)version Url:(NSString*)api;
@end
