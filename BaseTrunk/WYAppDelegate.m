//
//  AppDelegate.m
//  
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYAppDelegate.h"
#import "iRate.h"
#import "WYMainAppViewController.h"
#import "UncaughtExceptionHandler.h"

@interface WYAppDelegate ()

@end

@implementation WYAppDelegate

+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    //enable preview mode，预览模式
    //    [iRate sharedInstance].previewMode = YES;
}

+ (WYAppDelegate*)shareInstance{
    
    return (WYAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    InstallUncaughtExceptionHandler();

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //读取本地用户信息
    WYMainAppViewController *mainViewController = [WYMainAppViewController new];
    [self.window setRootViewController:mainViewController];
    
    [self.window makeKeyAndVisible];
    [application setMinimumBackgroundFetchInterval:3600];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //
    //    if ([url.absoluteString rangeOfString:ID_Wechat].location != NSNotFound) {
    //
    //        return [WXApi handleOpenURL:url delegate:self];
    //
    //    }
    //    else if ([url.absoluteString rangeOfString:@"monstea"].location != NSNotFound){
    //    }
    //
    return YES;
}

- (NSDictionary*)infoFromOAuthRequestReturnString:(NSString*)string
{
    //先取道＃后面的东西
    NSRange range = [string rangeOfString:@"#"];
    
    if (range.length > 0) {
        string = [string substringFromIndex:range.location+1];
    }
    
    NSArray* stringArray = [string componentsSeparatedByString:@"&"];
    
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:10];
    for (NSString* divString in stringArray)
    {
        NSArray* array = [divString componentsSeparatedByString:@"="];
        if( [array count]!=2 )continue;
        [info setObject:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];
    }
    return [NSDictionary dictionaryWithDictionary:info];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    NSLog(@"%@",url.absoluteString);
    
    //    if ([url.absoluteString rangeOfString:ID_Wechat].location != NSNotFound) {
    //
    //        return [WXApi handleOpenURL:url delegate:self];
    //
    //    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    static UIBackgroundTaskIdentifier task;
    
    task = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:task];
        task = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task, preferably in chunks.
        [application endBackgroundTask:task];
        task = UIBackgroundTaskInvalid;
    });
    
    
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    //    //开始定位
    //    [[MapViewLocation shareInstance] startLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma get device token and bind
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    NSString *realDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    //    [[WPFileClient sharedInstance] push_bind:realDeviceToken cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData delegate:self selector:nil selectorError:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Register Remote Notifications error:{%@}",[error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

- (void)performDealPush:(NSDictionary *)remoteDict
{
    
}

//
//
//#pragma weixin delegate method
//- (void)onResp:(BaseResp*)resp
//{
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        NSInteger errCode = resp.errCode;
//
//        if(errCode != 0){
//            if(resp.errStr && resp.errStr.length > 0)
//            return;
//        }
//    
//}
//
//- (void)onReq:(BaseReq*)req
//{
//    
//}


@end
