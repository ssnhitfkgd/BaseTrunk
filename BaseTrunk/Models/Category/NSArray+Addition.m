//
//  NSArray+Addition.m
//  YKiPad
//
//  Created by flexih on 1/9/12.
//  Copyright (c) 2012 Lebo.com. All rights reserved.
//

#import "NSArray+Addition.h"

@implementation NSArray (Addition)

- (id)firstObject
{
    if ([self count] > 0)
    {
        return [self objectAtIndex:0];
    }
    else {
        return nil;
    }
}


- (id)lastObject
{
    if ([self count] > 0)
    {
        return [self objectAtIndex:([self count]-1)];
    }
    else {
        return nil;
    }
}

- (id)randomObject
{
    if ([self count] > 0)
    {
        return [self objectAtIndex:arc4random()%[self count]];
    }
    else {
        return nil;
    }

}

- (NSArray *)reverse
{
    NSInteger count = self.count;
    NSMutableArray * array = [NSMutableArray arrayWithArray:self];
    for(int i=0 ;i<count/2; ++i)
    {
        [array exchangeObjectAtIndex:i withObjectAtIndex:count-1-i];
    }
    return [NSArray arrayWithArray:array];
}

- (BOOL)hasIndex:(int)index
{
    if(self.count > index)
        return YES;
    else
        return NO;
}
@end

@implementation NSMutableArray (Addition)

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx
{
    [self insertObject:object atIndex:idx];
}

@end
