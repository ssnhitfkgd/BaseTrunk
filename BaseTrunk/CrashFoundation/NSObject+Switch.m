//
//  NSObject+Switch.m
//  
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "NSObject+Switch.h"
#import <objc/runtime.h>


@implementation NSObject(Swizzle)

+ (void)switchMethod:(SEL)srcSel tarSel:(SEL)tarSel
{
    Class clazz = [self class];
    [self switchMethod:clazz srcSel:srcSel tarClass:clazz tarSel:tarSel];
}

+ (void)switchMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel
{
    if (!tarClassName)
    {
        return;
    }
    
    Class srcClass = [self class];
    Class tarClass = NSClassFromString(tarClassName);
    [self switchMethod:srcClass srcSel:srcSel tarClass:tarClass tarSel:tarSel];
}

+ (void)switchMethod:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel
{
    if (!srcClass)
    {
        return;
    }
    
    if (!srcSel)
    {
        return;
    }
    if (!tarClass)
    {
        return;
    }
    
    if (!tarSel)
    {
        return;
    }
    
    @try {
        Method srcMethod = class_getInstanceMethod(srcClass,srcSel);
        Method tarMethod = class_getInstanceMethod(tarClass,tarSel);
        method_exchangeImplementations(srcMethod, tarMethod);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
