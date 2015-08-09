//
//  WYBaseTabbarViewController.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYBaseTabbarViewController : UITabBarController

- (id)viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image finishedSelectedImage:(UIImage*)finishedSelectedImage viewClass:(NSString*)viewClass;
- (UIViewController*)viewControllerWithSubClass:(NSString*)viewClass;
- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage callback:(SEL)selector;
@end
