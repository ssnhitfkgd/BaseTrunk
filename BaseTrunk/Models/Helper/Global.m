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

NSString* GetAstroWithMonth(int m, int d){
    
    NSString *astroString = NSLocalizedString(@"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯", nil);
    
    NSString *astroFormat = NSLocalizedString(@"102123444543", nil);
    
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        return WhisperLocalized(@"错误日期格式!");
    }
    
    if(m==2 && d>29)
        
    {
        
        return WhisperLocalized(@"错误日期格式!!");
        
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            
            return WhisperLocalized(@"错误日期格式!!!");
            
        }
        
    }
    
    result=[NSString stringWithFormat:@"%@座",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
    
}

void setNewsSettingVoiceOn(BOOL on)
{
    [[NSUserDefaults standardUserDefaults] setObject:on?@"1":@"0" forKey:NEW_SETTING_VOICE_OPEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

void setNewsSettingMuteOn(BOOL on)
{
    [[NSUserDefaults standardUserDefaults] setObject:on?@"1":@"0" forKey:NEW_SETTING_MUTE_OPEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

BOOL getNewsSettingVoiceOn()
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:NEW_SETTING_VOICE_OPEN];
    if(obj)
    {
        return [obj boolValue];
    }
    
    return YES;
}
BOOL getNewsSettingMuteOn()
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:NEW_SETTING_MUTE_OPEN];
    if(obj)
    {
        return [obj boolValue];
    }
    
    return YES;
}


NSInteger fit_size(NSInteger size)
{
//    if(iPhone6Plus)
//    {
//        return size * 1.28;
//    }
//    
    return size;
}
@end

@implementation UIColor (RGB)
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b {
    return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.];
}
@end
