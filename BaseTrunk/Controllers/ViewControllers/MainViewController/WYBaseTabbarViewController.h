//
//  WPBaseTabbarViewController.h
//  Whisper
//
//  Created by wangyong on 14-2-26.
//  Copyright (c) 2014年 Whisper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYBaseTabbarViewController : UITabBarController

- (id)viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image finishedSelectedImage:(UIImage*)finishedSelectedImage viewClass:(NSString*)viewClass;
- (UIViewController*)viewControllerWithSubClass:(NSString*)viewClass;
- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage callback:(SEL)selector;
@end
