//
//  DateUtil.h
//
//  Created by wangyong on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format;
+ (NSString *)getFormatTime:(NSDate *)date;
+ (NSDate *)convertTime:(NSString *)time;
+ (NSDate *)convertTime:(NSString *)time format:(NSString *)format;
+ (NSDate *)convertTimeFromNumber:(NSNumber *)time;
// 矫正时区问题
+ (NSDate *)convertTimeFromNumber2:(NSNumber *)time;
+ (NSString *)convertToDay:(NSDate *)date;
+ (NSNumber *)convertNumberFromTime:(NSDate *)time;
+ (NSString *)getDisplayTime:(NSString *)date;
+ (NSDateComponents *)getComponenet:(NSDate *)date;

+ (NSInteger)getSinceNowHours:(NSString *)dateString;

@end
