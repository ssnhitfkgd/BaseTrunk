//
//  UIImage+Addition.h
//  
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (Blur)

// 0.0 to 1.0
- (UIImage*)blurredImage:(CGFloat)blurAmount;

- (UIImage *)imageWithGaussianBlur9;
@end


@interface UIImage (ImageWithColor)

- (UIImage *)imageWithColor:(UIColor *)color;

@end


@interface UIImage (Screenshot)

+ (UIImage *)screenshot;

@end

@interface UIImage (TransformUIView)

+ (UIImage *)imageWithUIView:(UIView *)view;
+ (UIImage *)imageWithUIViewAt2x:(UIView *)view;
+ (UIImage *)renderImageWithColor:(UIColor *)color inSize:(CGSize)size image:(UIImage*)src;
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;

@end

@interface UIImage (Center640Image)

- (UIImage*)scaleToFillWidth;
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)imageWithSquare:(CGFloat)square;

@end

@interface UIImage (wiRoundedRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
@end

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

@end