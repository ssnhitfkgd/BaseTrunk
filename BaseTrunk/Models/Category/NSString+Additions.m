//
//  NSStringAdditions.m
//  Wall
//
//  Created by 罗永兴 on 12-6-2.
//  Copyright (c) 2012年 草莓. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Addtion)


+ (NSString *)getMD5ForStr:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    const char *ptr = [str UTF8String];
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

- (NSString *)md5Value
{
    const char *ptr = [self UTF8String];
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

+ (NSInteger)countWeiboTextNum:(NSString *) str
{
    if(!str)
        return 0;
    int shortCharacter = 0,longCharacter = 0;
    for(int i=0;i<str.length;++i)
    {
        unichar character = [str characterAtIndex:i];
        if(isblank(character)||isascii(character))
            shortCharacter++;
        else
            longCharacter++;
    }
    return longCharacter+ceilf(shortCharacter/2.0);
}

- (NSString *)getWeiBoTextWithLength:(int)length
{
    float cuLength = 0;
    for(int i=0;i<self.length;++i)
    {
        float tempLength = cuLength;
        unichar character = [self characterAtIndex:i];
        if(isblank(character)||isascii(character))
            tempLength+=0.5;
        else
            tempLength++;
        if(tempLength>length)
            break;
        else if(tempLength < length)
        {
            cuLength = tempLength;
            continue;
        }
        else
        {
            cuLength = tempLength;
            break;
        }
    }
    return [self substringWithRange:NSMakeRange(0, floorf(cuLength))];
    
}
@end


@implementation NSString (EKBAdditons)

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width {
    return [self heightWithFont:font constrainedWidth:width lineBreakMode:NSLineBreakByTruncatingTail];
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width numberOfLines:(NSUInteger)numberOfLines{
    
    CGFloat lineHeight = font.lineHeight * numberOfLines;
    
    CGFloat realHeight = [self heightWithFont:font constrainedWidth:width lineBreakMode:NSLineBreakByTruncatingTail];
    
    return MIN(lineHeight, realHeight);
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return [self boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    
}

@end
