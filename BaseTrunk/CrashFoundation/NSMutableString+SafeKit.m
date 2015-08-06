//
//  NSMutableString+SafeKit.m
//  
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "NSMutableString+SafeKit.h"
#import "NSObject+Switch.h"

@implementation NSMutableString(SafeKit)


- (void)_appendString:(NSString *)sString
{
    if (!sString)
    {
        FMLoggerError(@"sString is nil");

        return;
    }
    
    [self _appendString:sString];
}

- (void)_appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
    if (!format)
    {
        FMLoggerError(@"sString is nil");
        return;
    }
    
    va_list arguments;
    va_start(arguments, format);
    NSString *formatStr = [[NSString alloc]initWithFormat:format arguments:arguments];
    [self _appendFormat:@"%@",formatStr];
    va_end(arguments);
}

- (void)_setString:(NSString *)sString
{
    if (!sString)
    {
        FMLoggerError(@"sString is nil");
        return;
    }
    
    [self _setString:sString];
}

- (void)_insertString:(NSString *)sString atIndex:(NSUInteger)index
{
    if (index > [self length])
    {
        FMLoggerError(@"%@",[NSString stringWithFormat:@"index[%ld] > length[%ld]",(long)index ,(long)[self length]]);

        return;
    }
    
    if (!sString)
    {
        FMLoggerError(@"sString is nil");
        return;
    }
    
    [self _insertString:sString atIndex:index];
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self switchMethod:@selector(_appendString:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendString:)];
        [self switchMethod:@selector(_appendFormat:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendFormat:)];
        [self switchMethod:@selector(_setString:) tarClass:@"__NSCFConstantString" tarSel:@selector(setString:)];
        [self switchMethod:@selector(_insertString:atIndex:) tarClass:@"__NSCFConstantString" tarSel:@selector(insertString:atIndex:)];
    });
}
@end
