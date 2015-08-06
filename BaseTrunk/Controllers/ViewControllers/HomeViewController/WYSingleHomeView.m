//
//  WYSingleHomeView.m
//
//
//  Created by wangyong on 15/7/21.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYSingleHomeView.h"

@implementation WYSingleHomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createSubView];
    }
    
    return self;
}

- (void)createSubView
{
    self.backgroundColor = [UIColor icebergColor];
    self.autoresizesSubviews = YES;
    self.userInteractionEnabled = YES;
    
    
    self.posterImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_posterImageView setBackgroundColor:[UIColor blackColor]];
    _posterImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    _posterImageView.backgroundColor = [UIColor clearColor];
    _posterImageView.clipsToBounds = YES;
    [self addSubview:_posterImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, ScreenWidth/2, 20)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.numberOfLines = 0;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_nameLabel];

    self.tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _nameLabel.bottom + 10, ScreenWidth/2, 20)];
    _tagsLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _tagsLabel.backgroundColor = [UIColor clearColor];
    _tagsLabel.numberOfLines = 0;
    _tagsLabel.textAlignment = NSTextAlignmentLeft;
    _tagsLabel.textColor = [UIColor whiteColor];
    [self addSubview:_tagsLabel];
    
    self.peopleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 20)];
    _peopleCountLabel.right = self.width - 20;
    _peopleCountLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _peopleCountLabel.backgroundColor = [UIColor clearColor];
    _peopleCountLabel.numberOfLines = 0;
    _peopleCountLabel.textAlignment = NSTextAlignmentRight;
    _peopleCountLabel.textColor = [UIColor whiteColor];
    [self addSubview:_peopleCountLabel];
    
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 100;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        if(!self.homeDto)
        {
            self.homeDto = [WYHomeDto alloc];
        }
        
        
        if([_homeDto parseData:item])
        {
            
            if(_homeDto.state == 1)
            {
                [_nameLabel setBackgroundColor:[UIColor redColor]];
            }
            else
            {
                [_nameLabel setBackgroundColor:[UIColor black25PercentColor]];

            }
            [_nameLabel setText:_homeDto.nickName];
            [_tagsLabel setText:_homeDto.tags];
            [_peopleCountLabel setText:[NSString stringWithFormat:@"%ld",(unsigned long)_homeDto.online]];
            
            [_posterImageView sd_setImageWithURL:[NSURL URLWithString:_homeDto.mpic]
                          placeholderImage:nil
                                   options:SDWebImageRetryFailed|SDWebImageLowPriority
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];

        }
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if(_homeDto.state == 1)
    {
        [_nameLabel setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        [_nameLabel setBackgroundColor:[UIColor black25PercentColor]];
        
    }
    [self.posterImageView setFrame: self.bounds];

}
@end
