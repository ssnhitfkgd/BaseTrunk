//
//  WYBaiduImageView.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYBaiduImageView.h"
#import "UIImageView+WebCache.h"

@implementation WYBaiduImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{    
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
 

    [self addSubview:_imageView];

}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 100.;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        if (!self.baiduImageInfoDto) {
            self.baiduImageInfoDto = [[WYBaiduImageInfoDto alloc] init];
        }
        
        if([_baiduImageInfoDto parseData:item])
        {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:_baiduImageInfoDto.thumbUrl] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority completed:nil];
        }
    }
}

- (void)imageSelected:(id)sender
{
}

@end
