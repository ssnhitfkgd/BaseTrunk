//
//  UIImageView+Addition.m
//  BaseTrunk
//
//  Created by yong on 1/9/12.
//  Copyright (c) 2012 yong. All rights reserved.
//

#import "UIImageView+Addition.h"

@interface UIImageView ()

@end

@implementation UIImageView (Addition)

- (void)fillCircleLayer:(UIColor*)color
{
    NSInteger radius = (self.width)/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-2, -2, self.width+4, self.height+4) cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius) cornerRadius:radius];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];

    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = color.CGColor;
    fillLayer.opacity = 1;
    [self.layer addSublayer:fillLayer];
}

- (void)setHighlightedColor:(UIColor*)color
{
    CAShapeLayer *fillLayer = self.layer.sublayers[0];
    fillLayer.fillColor = color.CGColor;;
}
@end

