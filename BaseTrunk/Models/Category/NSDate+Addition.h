//
//  NSDate+Addition.h
//
//
//  Created by wangyong on 13-3-25.
//  Copyright (c) 2013年 wangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Addition)


struct SDateInformation {
    NSInteger day;
    NSInteger month;
    NSInteger year;
    
    NSInteger weekday;
    
    NSInteger minute;
    NSInteger hour;
    NSInteger second;
    
};
typedef struct SDateInformation DateInformation;

- (DateInformation) dateInformation;
- (DateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(DateInformation)info;
+ (NSDate*) dateFromDateInformation:(DateInformation)info timeZone:(NSTimeZone*)tz;





@property (readonly,nonatomic) NSString *month;
@property (readonly,nonatomic) NSString *year;
@property (readonly,nonatomic) NSInteger weekdayWithMondayFirst;
@property (readonly,nonatomic) BOOL isToday;


- (BOOL) isSameDay:(NSDate*)anotherDate;
- (NSInteger) differenceInDaysTo:(NSDate *)toDate;
- (NSInteger) differenceInMonthsTo:(NSDate *)toDate;
- (NSInteger) daysBetweenDate:(NSDate*)d;


- (NSString*) dateDescription;
- (NSDate *) dateByAddingDays:(NSUInteger)days;
+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime;


+ (NSDate*) yesterday;

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format;
+ (NSString *)getFormatTime:(NSDate *)date;
+ (NSDate *)convertTime:(NSString *)time;
+ (NSDate *)convertTime:(NSString *)time format:(NSString *)format;
+ (NSDate *)convertTimeFromNumber:(NSNumber *)time;
// 矫正时区问题
+ (NSDate *)convertTimeFromNumber2:(NSNumber *)time;
+ (NSString *)convertToDay:(NSDate *)date;
+ (NSNumber *)convertNumberFromTime:(NSDate *)time;
+ (NSString *)getDisplayTime:(NSDate *)date;
+ (NSDateComponents *)getComponenet:(NSDate *)date;

@end
