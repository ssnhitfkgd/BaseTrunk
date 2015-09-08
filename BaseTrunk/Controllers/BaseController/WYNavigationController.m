//
//  WYNavigationController.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYNavigationController.h"

@implementation WYNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    
    if(self)
    {
        self.interactivePopGestureRecognizer.delegate = (id)self;

        self.delegate = (id)self;
        [self.navigationBar setTranslucent:NO];
        
//        self.navigationBar.barTintColor = [UIColor bRedColor];
//        self.navigationBar.tintColor = [UIColor whiteColor];
        
//        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];//:[NSArray arrayWithObjects:[UIColor whiteColor] ,[UIFont systemFontOfSizeFit:15], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
//        
//        self.navigationBar.titleTextAttributes = dict;
////        
//        self.navigationBar.translucent = NO;
//        [self.navigationBar setLayoutMargins:UIEdgeInsetsMake(20, 0, 0, 0) ];
    }
        
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // fix 'nested pop animation can result in corrupted navigation bar'
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
    
//    NSLog(@"%@",[NSString stringWithFormat:@"%ld  class %@",(long)self.tag,NSStringFromClass(viewController.class)]);

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
//    viewController.title = [NSString stringWithFormat:@"%ld  class %@",(long)self.tag,NSStringFromClass(self.topViewController.class)];
}

@end
