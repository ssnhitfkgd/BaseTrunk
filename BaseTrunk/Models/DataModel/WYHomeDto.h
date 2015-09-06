//
//  WUEmojiDto.h
//
//
//  Created by wangyong on 15/7/19.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "WYItemParseBase.h"

@interface WYHomeDto : WYItemParseBase

@property (nonatomic, assign) NSInteger familyId;
@property (nonatomic, assign) NSInteger goodNum;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger maxUsers;
@property (nonatomic, assign) NSInteger mpicH;
@property (nonatomic, assign) NSInteger mpicW;
@property (nonatomic, assign) NSInteger picH;
@property (nonatomic, assign) NSInteger picW;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger showPriority;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger surfing;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger online;

@property (nonatomic, copy) NSString *mpic;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *tagNames;
@property (nonatomic, copy) NSString *tags;

@end
