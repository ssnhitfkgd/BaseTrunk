//
//  NSMutableDictionary+SafeKit.m
//  
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "NSMutableDictionary+SafeKit.h"
#import "NSObject+Switch.h"

@implementation NSMutableDictionary(SafeKit)

- (void)_removeObjectForKey:(id)sKey
{
    if (!sKey)
    {
        FMLoggerError(@"sKey is nil");

        return;
    }
    
    [self _removeObjectForKey:sKey];
}

- (void)_setObject:(id)sObject forKey:(id <NSCopying>)sKey
{
    if (!sObject)
    {
        FMLoggerError(@"sObject is nil");
        return;
    }
    
    if (!sKey)
    {
        FMLoggerError(@"sKey is nil");
        return;
    }
    
    [self _setObject:sObject forKey:sKey];
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self switchMethod:@selector(_removeObjectForKey:) tarClass:@"__NSDictionaryM" tarSel:@selector(removeObjectForKey:)];
        [self switchMethod:@selector(_setObject:forKey:) tarClass:@"__NSDictionaryM" tarSel:@selector(setObject:forKey:)];
    });
}
@end
