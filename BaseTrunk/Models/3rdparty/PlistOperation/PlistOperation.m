//
//  PlistOperation.m
//  Whisper
//
//  Created by wangyong on 14/11/25.
//  Copyright (c) 2014年 Whisper. All rights reserved.
//

#import "PlistOperation.h"

@implementation PlistOperation


+ (NSMutableDictionary *)objectFromPlist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename = [plistPath1 stringByAppendingPathComponent:@"userinfo.plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    return dic;
}

+ (BOOL)containsObject:(NSString*)key
{
    NSMutableDictionary *dic = [self objectFromPlist];
    if(key && dic)
    {
        id obj = [dic objectForKey:key];
        if(obj && [obj integerValue] == 1)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (void)writeToPlist:(NSString*)key object:(BOOL)object
{
    //获取一个字典
    NSMutableDictionary *dic = [self objectFromPlist];
    if(!dic)
        dic = [[NSMutableDictionary alloc] init];
    [dic setObject:object?@"1":@"0" forKey:key];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename = [plistPath1 stringByAppendingPathComponent:@"userinfo.plist"];
    [dic writeToFile:filename atomically:NO];
}

@end
