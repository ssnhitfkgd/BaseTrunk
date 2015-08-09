//
//  WYMainAppViewController.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYMainAppViewController.h"
#import "WYUserInfoDto.h"
#import "WYDataModelBase.h"
#import "iRate.h"
#import "WYSocketObject.h"

@interface WYMainAppViewController()<WYSocketObjectDelegate>
@end

@implementation WYMainAppViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDelegate:self];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:(@"table frame") image:[UIImage imageNamed:@""] finishedSelectedImage:[UIImage imageNamed:@""] viewClass:@"WYTableHomeViewController"],
                            [self viewControllerWithTabTitle:@"collectionView frame" image:[UIImage imageNamed:@"tabbar_find.png"]  finishedSelectedImage:[UIImage imageNamed:@"tabbar_find_tape.png"] viewClass:@"WYCollectionHomeViewController"],
                            [self viewControllerWithTabTitle:(@"UIViewController") image:[UIImage imageNamed:@"tabBarContactsIcon"] finishedSelectedImage:[UIImage imageNamed:@"tabBarContactsIcon"]  viewClass:@"UIViewController"],
                            nil];
    
//    [self addCenterButtonWithImage:[[UIImage imageNamed:@"tabbar_whisper"] imageWithColor:[UIColor appleRedColor]] highlightImage:nil callback:@selector(addCenterButtonTouchDown:)];
    

    self.tabBar.tintColor = [UIColor appleRedColor];
    
    [self setSelectedViewController: self.viewControllers[0]];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"立即查看";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序

        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示
        [categorys setActions:@[action] forContext:(UIUserNotificationActionContextMinimal)];
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applocatopnDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applocatopnWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applocatopnWillTerminateNotification:) name:UIApplicationWillTerminateNotification object:nil];



}

- (void)addCenterButtonTouchDown:(id)sender
{
    NSLog(@"center button touch down");
}

- (void)applocatopnWillTerminateNotification:(NSNotification*)notification
{
    [WYUserInfoDto saveUserInfo:[WYUserInfoDto sharedInstance]];
}

- (void)applocatopnWillResignActiveNotification:(NSNotification*)notification
{
    
    //断开socket连接
    [self disSocketConnect];
    
    //存储用户信息
    [WYUserInfoDto saveUserInfo:[WYUserInfoDto sharedInstance]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:strDate forKey:@"applicationDidEnterBackground_time"];
}

- (void)applocatopnDidBecomeActiveNotification:(NSNotification*)notification
{
    //1.判断是否登录
    if([[WYUserInfoDto sharedInstance] getToken] && ![[[WYUserInfoDto sharedInstance] getToken] isEqualToString:@""])
    {
        [self resumeSocketConnect];
    }
}


//检测更新
- (void)appUpdate:(NSDictionary *)appUpdateInfo
{
    if (appUpdateInfo && [appUpdateInfo isKindOfClass:[NSDictionary class]]) {
        BOOL update = [WYDataModelBase getBoolValue:[appUpdateInfo objectForKey:@"update"]];
        if (update) {
            //need update
            NSString *update_version = [WYDataModelBase getStrValue:[appUpdateInfo objectForKey:@"version"]];
            BOOL reminded = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Reminded_version_%@",update_version]] boolValue];
            if (reminded == NO) {
                NSString *update_log = [WYDataModelBase getStrValue:[appUpdateInfo objectForKey:@"update_log"]];
                
                UIAlertView *updateAlert = [UIAlertView alertViewWithTitle:@"发现新版本"
                                                                   message:update_log
                                                         cancelButtonTitle:@"稍后再说"
                                                         otherButtonTitles:[NSArray arrayWithObject:@"立即更新"]
                                                                 onDismiss:^(int buttonIndex) {
                                                                     [[iRate sharedInstance] openRatingsPageInAppStore];
                                                                 } onCancel:^{
                                                                     
                                                                 }];
                [updateAlert show];
            }
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"Reminded_version_%@",update_version]];
            
        }
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)navigationController
{
    
}

- (void)startLocation
{
}

#pragma mark -
#pragma mark socketReceiveDataDelegate

- (void)socketReceiveData:(NSDictionary *)data
{
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *payload = [data objectForKey:@"payload"];
        
        if (payload && [payload isKindOfClass:[NSDictionary class]]) {
            
            NSString *type = [WYDataModelBase getStrValue:[payload objectForKey:@"type"]];
            if (type && ![type isEqualToString:@""]) {
                
                
            }
                //--user message end
        
            
        }
        
    }
    
}

- (void)markItemBadge:(NSInteger)index
{
    if (self.viewControllers && self.viewControllers.count > index) {
        UIViewController * tempController = self.viewControllers[index];
        tempController.tabBarItem.badgeValue = @"N";
    }
    
}

- (void)clearItemBadge:(NSInteger)index{
    
    if (self.viewControllers && self.viewControllers.count > index) {
        UIViewController * tempController = self.viewControllers[index];
        tempController.tabBarItem.badgeValue = nil;
    }
    
}

- (void)resumeSocketConnect
{
    [[WYSocketObject sharedInstance] setDelegate:self];
    
    [[WYSocketObject sharedInstance] resume];
}

- (void)disSocketConnect
{
    [[WYSocketObject sharedInstance] disconnect];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
