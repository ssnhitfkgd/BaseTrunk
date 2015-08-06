//
//  WYSingleHomeView.h
//
//
//  Created by wangyong on 15/7/21.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYHomeDto.h"

@interface WYSingleHomeView : UIView

@property (nonatomic, strong) WYHomeDto *homeDto;
@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *peopleCountLabel;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UILabel *nameLabel;


+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;
@end
