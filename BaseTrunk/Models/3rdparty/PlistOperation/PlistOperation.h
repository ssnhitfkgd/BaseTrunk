//
//  PlistOperation.h
//  Whisper
//
//  Created by wangyong on 14/11/25.
//  Copyright (c) 2014年 Whisper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistOperation : NSObject

+ (NSMutableDictionary *)objectFromPlist;
+ (BOOL)containsObject:(NSString*)key;
//将数据写入plist文件中
+ (void)writeToPlist:(NSString*)key object:(BOOL)object;

@end
