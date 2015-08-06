//
//  NSArray+SafeKit.m
//  
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "NSArray+SafeKit.h"

@implementation NSArray(SafeKit)
- (id)_objectAtIndex:(NSUInteger)index
{
    if (index >= [self count])
    {
        FMLoggerError(@"%@",[NSString stringWithFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]);
        return nil;
    }
    
    return [self _objectAtIndex:index];
}

- (id)objectForKey:(NSString*)key
{
    return @"";
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self switchMethod:@selector(_objectAtIndex:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndex:)];
    });
}
@end
