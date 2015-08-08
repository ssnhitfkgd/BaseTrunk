//
//  WYCollectionViewBaseCell.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/6.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYBaiduImageViewCell.h"

@interface WYBaiduImageViewCell ()
@property (nonatomic,weak,readwrite) UIButton *keyButton;
@end

@implementation WYBaiduImageViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipview = [[WYBaiduImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_clipview];
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(setSelected:)]) {
            [obj setSelected:selected];
        }
    }];
}

- (void)setObject:(id)item
{
    if(_clipview)
    {
        [_clipview setObject:item];
    }
}

@end
