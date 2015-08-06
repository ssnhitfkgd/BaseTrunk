//
//  NSArray+Addition.h
//  YKiPad
//
//  Created by flexih on 1/9/12.
//  Copyright (c) 2012 Lebo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Addition)
- (id)firstObject;
- (id)randomObject;
- (NSArray *)reverse;
- (BOOL)hasIndex:(int)index;
- (id)lastObject;
@end

#pragma mark - 实现下标修改
@interface NSMutableArray (Addition)

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx;

@end
