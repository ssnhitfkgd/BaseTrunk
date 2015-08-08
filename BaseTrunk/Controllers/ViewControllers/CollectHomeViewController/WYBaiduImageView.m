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
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = self.bounds;
    [self.backButton addTarget:self action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self addSubview:_imageView];

    [self setUserInteractionEnabled:YES];
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
            [_imageView sd_setImageWithURL:[NSURL URLWithString:_baiduImageInfoDto.thumbUrl] completed:nil];
        }
    }
}

- (void)imageSelected:(id)sender
{
    if (_baiduImageInfoDto.largeTnImageUrl && ![_baiduImageInfoDto.largeTnImageUrl isEqualToString:@""]){
        [self performSelector:@selector(aa) withObject:nil];
    }
}

@end
