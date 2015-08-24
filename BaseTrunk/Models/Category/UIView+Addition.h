//
//  UIViewAdditions.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
- (UIBezierPath *)framePath;
@end

@interface UIView (Shadow)
- (void) makeInsetShadow;
- (void) makeInsetShadowWithRadius:(float)radius Alpha:(float)alpha;
- (void) makeInsetShadowWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions;
@end

@interface UIView (controller)
- (UIViewController*)viewController;
@end