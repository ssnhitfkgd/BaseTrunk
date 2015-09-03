//
//  CustomSearchBar.m
//  Whisper
//
//  Created by wangyong on 14-3-2.
//  Copyright (c) 2014年 Whisper. All rights reserved.
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
} 

//- (void)drawRect:(CGRect)rect {
//    self.backgroundImage = nil;
//
////    [[[self subviews] objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
//////    //UIImage *image = [UIImage imageNamed: @"searchBar_background.png"];
////    CGSize imageSize = CGSizeMake(self.width, 44);
////    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
////    [[UIColor clearColor] set];
////    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
////    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    [pressedColorImg drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            //            [[view.subviews objectAtIndex:0] setBackgroundColor:[UIColor blackColor]];
            for(UIView *viewa in view.subviews)
            {
                if([viewa isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
                {
                    [viewa removeFromSuperview];
                    break;
                }
                
                if([viewa isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
                {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
                    [imageView setImage:[UIImage imageNamed:@"seach"]];
                    ((UITextField*)viewa).leftView = imageView;
                    viewa.clipsToBounds = YES;
                    viewa.layer.cornerRadius = viewa.height/2.f;
                }
                
                if([viewa isKindOfClass:NSClassFromString(@"UINavigationButton")])
                {
                    [((UIButton*) viewa) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    //[((UIButton*) viewa) setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
            break;
        }
    }
}

@end