//
//  BaiduImageModel.h
//  BaseTrunk
//
//  Created by wangyong on 15/9/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYParamsBaseObject.h"
#import "WYItemParseBase.h"

@interface WYBaiduImageObject : WYParamsBaseObject
@property (nonatomic, copy) NSString *tn;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSString *rn;
@property (nonatomic, copy) NSString *pn;
@property (nonatomic, copy) NSString *z;
@property (nonatomic, copy) NSString *ie;
@property (nonatomic, copy) NSString *oe;
@end



@interface WYBaiduImageInfoObject : WYItemParseBase
@property (nonatomic, copy) NSString *thumbUrl;
@property (nonatomic, copy) NSString *largeTnImageUrl;
@end
