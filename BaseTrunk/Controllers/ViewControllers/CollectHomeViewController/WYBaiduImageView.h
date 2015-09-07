//
//  WYBaiduImageView.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYBaiduImageInfoDto.h"

@interface WYBaiduImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WYBaiduImageInfoDto *baiduImageInfoDto;
@property (nonatomic, strong) UIButton *backButton;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;
@end
