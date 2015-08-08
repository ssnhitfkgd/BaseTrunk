//
//  WYBaiduImageInfoDto.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYBaiduImageInfoDto.h"

@implementation WYBaiduImageInfoDto
@synthesize thumbUrl = _thumbUrl;
@synthesize largeTnImageUrl = _largeTnImageUrl;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)parseData:(NSDictionary *)result
{
    BOOL tf = YES;
    
    if ([result objectForKey:@"thumbURL"]) {
        self.thumbUrl = [self getStrValue:[result objectForKey:@"thumbURL"]];
    }else if ([result objectForKey:@"thumb_url"]){
        self.thumbUrl = [self getStrValue:[result objectForKey:@"thumb_url"]];
    }
    
    if ([result objectForKey:@"objURL"]) {
        self.largeTnImageUrl = [self getStrValue:[result objectForKey:@"objURL"]];
    }else if ([result objectForKey:@"image_url"]){
        self.largeTnImageUrl = [self getStrValue:[result objectForKey:@"image_url"]];
    }
    return tf;
}

@end
