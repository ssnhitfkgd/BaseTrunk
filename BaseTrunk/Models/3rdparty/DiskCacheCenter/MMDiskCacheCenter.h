//
//  MMCacheCenter.h
//  MoreMore
//
//  Created by Jagie on 1/12/14.
//  Copyright (c) 2014 Jagie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMDiskCacheCenter : NSObject
-(id)cacheForKey:(NSString *)key dataType:(Class)dataClass;
-(void)setCache:(id)cache forKey:(NSString *)key;
- (void)clearCache;
+ (id)sharedInstance;
@end
