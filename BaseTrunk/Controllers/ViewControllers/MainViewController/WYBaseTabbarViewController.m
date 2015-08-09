//
//  WPBaseTabbarViewController
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYBaseTabbarViewController.h"
#import "WYNavigationController.h"

@implementation WYBaseTabbarViewController

- (id)viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image finishedSelectedImage:(UIImage*)finishedSelectedImage viewClass:(NSString*)viewClass
{
    Class viewControllerClass = NSClassFromString(viewClass);
    UIViewController* viewController = [[viewControllerClass alloc] init];
    viewController.title = title;
    [viewController.tabBarItem setSelectedImage:finishedSelectedImage];
    [viewController.tabBarItem setImage:image];
    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    [viewController.tabBarItem setTitle:nil];
    WYNavigationController *navigationController = [[WYNavigationController alloc] initWithRootViewController:viewController];
    
    //    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:1. green:102./225. blue:0 alpha:1.] forKey:NSForegroundColorAttributeName];
    //    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    return navigationController;
}

- (UIViewController*)viewControllerWithSubClass:(NSString*)viewClass
{   
    Class viewControllerClass = NSClassFromString(viewClass);
    UIViewController* viewController = [[viewControllerClass alloc] init];
    return viewController;
}

- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage callback:(SEL)selector
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];

    button.frame = CGRectMake(ScreenWidth/[self.viewControllers count], 0, ScreenWidth/[self.viewControllers count], self.tabBar.height);

    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchDown];
    [self.tabBar addSubview:button];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
