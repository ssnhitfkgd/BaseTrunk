//
//  Global.h
//  Whisper
//
//  Created by wangyong on 14-2-27.
//  Copyright (c) 2014年 Whisper. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UIView+Addition.h"
#import "NSArray+Addition.h"
#import "UIAlertView+Addition.h"
#import "NSString+Additions.h"
#import "NSDate+Addition.h"
#import "UIImage+Addition.h"
#import "Colours.h"
#import "WYNavigationController.h"
#import "SVProgressHUD.h"
#import "DateUtil.h"
#import "UINavigationBar+Addition.h"
#import "UITabBarController+hidable.h"
#import "UINavigationController+TRVSNavigationControllerTransition.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Addition.h"
#import "UIActionSheet+Addtions.h"

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif



#define iPhone5_down  (([UIScreen mainScreen].bounds.size.height <= 568)?YES: NO)


//域名
#define ERROR_DOMAIN @"com.***"

#define URL_BAIDU_IMAGE @"http://image.baidu.com/i"


#define USER_DEFAULTS_SYSTEM_USER @"USER_DEFAULTS_SYSTEM_USER"


extern NSString*  const AgainLoginNotification;
@interface Global : NSObject
UINavigationController *selected_navigation_controller();

@end

