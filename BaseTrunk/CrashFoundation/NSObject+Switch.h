//
//  NSObject+Switch.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
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
