//
//  WYSingleHomeCell.m
//  
//
//  Created by wangyong on 15/7/21.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYSingleHomeCell.h"

@implementation WYSingleHomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.homeView = [[WYBaiduImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        
        [self.contentView addSubview:_homeView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item
{
    if(_homeView)
    {
        [_homeView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [WYBaiduImageView rowHeightForObject:item];
}
@end
