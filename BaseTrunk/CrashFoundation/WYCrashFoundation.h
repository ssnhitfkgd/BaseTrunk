//
//  CrashFoundation.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface WYCrashFoundation : NSObject
+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod;
@end

@interface NSArray (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (id)_objectAtIndex:(NSUInteger)index;
@end


@interface NSMutableArray (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (id)_objectAtIndex:(NSUInteger)index;

- (void)_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end


@interface NSMutableDictionary (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (void)_setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)_removeObjectForKey:(id)sKey;
@end

@interface UIView (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (void)_addSubview:(UIView *)view;
@end

@interface NSNumber (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (BOOL)_isEqualToNumber:(NSNumber *)sNumber;
@end

@interface NSMutableString(Safe)

+ (Method)methodOfSelector:(SEL)selector;

- (void)_appendString:(NSString *)sString;
- (void)_appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (void)_setString:(NSString *)sString;
- (void)_insertString:(NSString *)sString atIndex:(NSUInteger)index;

@end
