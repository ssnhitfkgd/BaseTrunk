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




#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5_down  (([UIScreen mainScreen].bounds.size.height <= 568)?YES: NO)


#define WhisperLocalized(key)\
NSLocalizedStringFromTable(key,@"whisper", nil)

//平台账号
#define ID_Umeng @"5562906f67e58ed8c60017ad"  //V
#define ID_Wechat @"wx3cb44f59e30d5ce8"
#define ID_Wechat_AppSecret @"f7c421ec55d3e443740b0be471efcac6"


//参数配置

//用户 是否允许定位标示 “0”或“1”
#define USER_ALLOW_LOCATION @"user_allow_location"

//用户标示 存储用户信息
#define USER_DEFAULTS_SYSTEM_USER @"user_default_system_user"

//用户升级
#define USER_DEFAULTS_NORMAL_CURRENT_VERSION @"normal_current_version"

//强制升级
#define USER_DEFAULTS_FORCED_CURRENT_VERSION @"forced_current_version"

//域名
#define ERROR_DOMAIN @"com.71ao"

#define URL_BAIDU_IMAGE @"http://image.baidu.com/i"


//微信openid
#define URL_WEIXIN_OPENID @"https://api.weixin.qq.com/sns/oauth2/access_token"

//任务
#define TASK_SHARE_TYPE @"task_share_type"
#define TASK_SHARE_TYPE_WEIXIN_SESSION @"task_share_type_weixin_session"
#define TASK_SHARE_TYPE_WEIXIN_TIMELINE @"task_share_type_weixin_timeline"


#define NOTIFICATION_SOCKET_RECEIVE_CHAT_DATA @"notification_socket_receive_chat_data"
#define NOTIFICATION_SOCKET_RECEIVE_CHAT_DATA_UPDATE @"NOTIFICATION_SOCKET_RECEIVE_CHAT_DATA_UPDATE"

#define NOTIFICATION_DELETE_USER_MESSAGE @"NOTIFICATION_DELETE_USER_MESSAGE"
#define NOTIFICATION_MARK_CHAT_USER_MESSAGE @"NOTIFICATION_MARK_CHAT_USER_MESSAGE"
#define NOTIFICATION_MARK_MESSAGE_USER_MESSAGE @"NOTIFICATION_MARK_MESSAGE_USER_MESSAGE"

#define NOTIFACATION_TASK_SHARE @"notifacation_task_share"


//************************************
//管理员设置
#define ADMIN_NEED_LOCATION @"ADMIN_NEED_LOCATION"
#define ADMIN_SIMULATE_LIKE @"ADMIN_SIMULATE_LIKE"


//************************************


//#define FISH_GUIDE_NEWFEATURE       [NSString stringWithFormat:@"fish_guide_newfeature_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]




#define KEYCHAIN_SERVICE_NAME       @"839545774.com.monstea.yoyo"
#define KEYCHAIN_ACCOUNT_UUID       @"keychain_account_uuid.com.monstea.yoyo"

//消息页面是否需要刷新
#define MESSAGE_VIEW_NEED_RES   @"MESSAGE_VIEW_NEED_RES"
#define CONTACTS_VIEW_NEED_RES   @"CONTACTS_VIEW_NEED_RES"

//statusbar 使用状态
#define USER_INPUT_STATUS_STYLE @"USER_INPUT_STATUS_STYLE"

#define BATCH_POST_DONE  @"BATCH_POST_DONE"
#define BATCH_RE_POST_DONE  @"BATCH_RE_POST_DONE"
#define BATCH_REDELETE_POST_DONE  @"BATCH_REDELETE_POST_DONE"
#define NEW_SETTING_VOICE_OPEN  @"NEW_SETTING_VOICE_OPEN"
#define NEW_SETTING_MUTE_OPEN  @"NEW_SETTING_MUTE_OPEN"

#define SHOW_IMAGE_VIEW 1010

#define NOTIFICATION_SELECTED_PEOPLE @"NOTIFICATION_SELECTED_PEOPLE" 
#define NOTIFICATION_UPDATE_MESSAGE_STATUS @"NOTIFICATION_UPDATE_MESSAGE_STATUS"

//************************************
//#progma system manager

/*通过user信息用户规则 识别登陆者身份*/
#define IS_ADMIN [[WPUserInfoDto sharedInstance].role isEqualToString:@"admin"]
//************************************

#define keyboard_height  (([UIScreen mainScreen].bounds.size.height <= 568)?216: 226)




extern NSString*  const AgainLoginNotification;
@interface Global : NSObject
UINavigationController *selected_navigation_controller();
NSInteger fit_size(NSInteger size);
NSString* GetAstroWithMonth(int m, int d);
void setNewsSettingVoiceOn(BOOL on);
void setNewsSettingMuteOn(BOOL on);
BOOL getNewsSettingVoiceOn();
BOOL getNewsSettingMuteOn();

@end

@interface UIColor (RGB)
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;
@end
