//
//  UIActionSheet+Addtions.h
//
//
//  Created by wangyong on 14/1/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIActionSheet (Addtions) <UIActionSheetDelegate>

+(UIActionSheet *)presentOnView: (UIView *)view
                      withTitle: (NSString *)title
                   otherButtons: (NSArray *)otherStrings
                       onCancel: (void (^)(UIActionSheet *))cancelBlock
                onClickedButton: (void (^)(UIActionSheet *, NSUInteger))clickBlock;


+(UIActionSheet *)presentOnView: (UIView *)view
                      withTitle: (NSString *)title
                   cancelButton: (NSString *)cancelString
              destructiveButton: (NSString *)destructiveString
                   otherButtons: (NSArray *)otherStrings
                       onCancel: (void (^)(UIActionSheet *))cancelBlock
                  onDestructive: (void (^)(UIActionSheet *))destroyBlock
                onClickedButton: (void (^)(UIActionSheet *, NSUInteger))clickBlock;
@end
