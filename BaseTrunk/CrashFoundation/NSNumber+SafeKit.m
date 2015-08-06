//
//  NSNumber+SafeKit.m
//  
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "NSNumber+SafeKit.h"
#import "NSObject+Switch.h"

@implementation NSNumber(SafeKit)
- (BOOL)_isEqualToNumber:(NSNumber *)sNumber
{
    if (!sNumber)
    {
        FMLoggerError(@"sNumber is nil");
        return NO;
    }
    return [self _isEqualToNumber:sNumber];
}

- (id)_tableView
{
    return @"";
}

- (id)objectForKeyedSubscript
{
    return @"";
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self switchMethod:@selector(_isEqualToNumber:) tarClass:@"__NSCFNumber" tarSel:@selector(isEqualToNumber:)];
    });
}

@end
