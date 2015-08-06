//
//  NSObject+Switch.h
//  
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "FMLogger.h"

#define RTY(__target) \
@try {\
{__target}\
}\
@catch (NSException *exception) {\
FMLoggerError(exception.reason)\
}\
@finally {\
\
}




@interface NSObject(SwitchKit)

+ (void)switchMethod:(SEL)srcSel tarSel:(SEL)tarSel;

+ (void)switchMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel;

+ (void)switchMethod:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel;
@end
