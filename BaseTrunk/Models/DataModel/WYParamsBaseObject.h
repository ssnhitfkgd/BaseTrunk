//
//  WYParamsBaseObject.h
//  BaseTrunk
//
//  Created by wangyong on 15/9/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYParamsBaseObject : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *offset_id;
@property (nonatomic, copy) NSString *timesp;
@property (nonatomic, assign) NSInteger page_size;
@property (nonatomic, assign) BOOL post;
@property (nonatomic, copy) id file;

@end
