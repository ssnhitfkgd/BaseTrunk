//
//  NSStringAdditions.h
//  Wall
//
//  Created by 罗永兴 on 12-6-2.
//  Copyright (c) 2012年 草莓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EKBAdditons)

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width;// Uses UILineBreakModeTailTruncation
- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width numberOfLines:(NSUInteger)numberOfLines;
- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end


@interface NSString(Addtion)

+ (NSString *)getMD5ForStr:(NSString *)str;

- (NSString *)md5Value;

+ (NSInteger)countWeiboTextNum:(NSString *) str;

- (NSString *)getWeiBoTextWithLength:(int)length;
@end