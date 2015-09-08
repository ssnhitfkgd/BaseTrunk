//
//  WYItemParseBase.m
//
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "WYItemParseBase.h"
#import "SBJson.h"
#import <objc/runtime.h>


@implementation WYItemParseBase
//@synthesize dtoResult = _dtoResult;

- (id)init:(NSString *)str
{
    self = [super init];
    if (self) {
        NSDictionary *dict = [str JSONValue];
        BOOL tf = [self parseData:dict];
        if (tf == NO) {
            self = nil;
        }
    }
    return self;
}

+ (NSInteger)getIntValue:(NSNumber *)num
{
    NSInteger n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num intValue];
    }
    return n;
}

+ (float)getFloatValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num floatValue];
    }
    return n;
}

+ (double)getDoubleValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num doubleValue];
    }
    return n;
}

+ (BOOL)getBoolValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num boolValue];
    }
    return n;
}

+ (NSString *)getStrValue:(NSString *)str
{
    NSString *s = @"";
    if ((NSObject *)str != [NSNull null] && str != nil) {
        s = [NSString stringWithFormat:@"%@",str];
    }
    return s;
}
////////
- (NSInteger)getIntValue:(NSNumber *)num
{
    NSInteger n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num intValue];
    }
    return n;
}

- (long long )getLonglongValue:(NSNumber *)num
{
    long long  n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num longLongValue];
    }
    return n;
}

- (float)getFloatValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num floatValue];
    }
    return n;
}

- (double)getDoubleValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num doubleValue];
    }
    return n;
}

- (BOOL)getBoolValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num boolValue];
    }
    return n;
}

- (NSString *)getStrValue:(NSString *)str
{
    NSString *s = @"";
    if ((NSObject *)str != [NSNull null] && str != nil) {
        s = [NSString stringWithFormat:@"%@",str];
    }
    return s;
}

- (NSMutableDictionary*)dtoResult
{
    return resultDictnary;
}

- (void)setDtoResult:(NSDictionary*)result
{
    if([result isKindOfClass:[NSMutableDictionary class]])
    resultDictnary = (NSMutableDictionary*)result;
    else resultDictnary = [[NSMutableDictionary alloc] initWithDictionary:result];
}


- (BOOL)parseData:(NSDictionary *)result
{
    if (result && (NSObject *)result != [NSNull null]) {
        
        [self setDtoResult:result];
        unsigned int ptcnt = 0;
        Class cls = [self class];
        
        objc_property_t *propertys = class_copyPropertyList(cls, &ptcnt);
        
        for (const objc_property_t *p = propertys; p < propertys + ptcnt; ++p)
        {
            objc_property_t const property = *p;
            const char *name = property_getName(property);
            NSString *key = [NSString stringWithUTF8String:name];
            
            id value = [result objectForKey:key];
            
            if(value)
            {
                [self setValue:value forKey:key];
            }
            
        }
        
        free(propertys);
        
        return YES;
        
    }
    return NO;
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dictionaryFormat = [NSMutableDictionary dictionary];
    
    Class cls = [self class];
    
    unsigned int ivarsCnt = 0;
    objc_property_t *propertys = class_copyPropertyList(cls, &ivarsCnt);
    
    for (const objc_property_t *p = propertys; p < propertys + ivarsCnt; ++p)
    {
        objc_property_t const ivar = *p;
        
        NSString *key = [NSString stringWithUTF8String:property_getName(ivar)];
        id value = [self valueForKey:key];
        
        if (value)
        {
            [dictionaryFormat setObject:value forKey:key];
        }
    }
    return dictionaryFormat;
}

@end
