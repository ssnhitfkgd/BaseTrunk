//
//  JMStaticTableViewCell.m
//  YoYo
//
//  Created by wangyong on 15/6/1.
//  Copyright (c) 2015年 Whisper. All rights reserved.
//

#import "JMStaticTableViewCell.h"

@implementation JMStaticTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textLabel setLeft:10];
    [self.textLabel setTextAlignment:NSTextAlignmentRight];
    [self.textLabel setWidth:60];
    [self.textLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self.textLabel setTextColor:[UIColor grayColor]];
    
    [self.detailTextLabel setLeft:self.textLabel.right + 15];
    [self.detailTextLabel setTextAlignment:NSTextAlignmentLeft];
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self.detailTextLabel setTextColor:[UIColor black25PercentColor]];
    [self.detailTextLabel setHighlightedTextColor:[UIColor black25PercentColor]];

}
@end
