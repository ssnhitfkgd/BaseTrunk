//
//  WYErrorView.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/9.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYErrorView : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailLabel;
- (void)setText:(NSString*)text detail:(NSString*)detail;
@end
