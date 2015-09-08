//
//  WYBaiduImageView.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYBaiduImageView.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
#import "UIImageView+Addition.h"

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelected:)]];
    self.imageView = imageView;
//    [imageView fillCircleLayer:[UIColor whiteColor] radius:imageView.height/2];

    [self addSubview:imageView];

}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 300.;
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
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    self.height = self.superview.height;
}

- (void)imageSelected:(UIGestureRecognizer*)sender
{
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

@end
