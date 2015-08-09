//
//  Global.m
//  Whisper
//
//  Created by wangyong on 14-2-27.
//  Copyright (c) 2014年 Whisper. All rights reserved.
//

#import "Global.h"

NSString *const AgainLoginNotification = @"com.again.login";


@implementation Global

UINavigationController *selected_navigation_controller()
{
    UINavigationController *selectedNavi = nil;
    
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        selectedNavi = (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
    }
    
    return selectedNavi;
}
@end
