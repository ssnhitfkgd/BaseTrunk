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
@property (nonatomic, copy) NSString *thumbURL;
@property (nonatomic, copy) NSString *largeTnImageUrl;
@property (nonatomic, assign) NSInteger adPicId;
@property (nonatomic, copy) NSString *bdFromPageTitlePrefix;
@property (nonatomic, copy) NSString *bdImgnewsDate;
@property (nonatomic, assign) NSInteger bdSetImgNum;
@property (nonatomic, copy) NSString *bdSourceName;
@property (nonatomic, copy) NSString *bdSrcType;
@property (nonatomic, copy) NSString *currentIndex;
@property (nonatomic, copy) NSString *di;
@property (nonatomic, copy) NSString *filesize;
@property (nonatomic, copy) NSString *fromPageTitle;
@property (nonatomic, copy) NSString *fromPageTitleEnc;
@property (nonatomic, copy) NSString *fromURL;
@property (nonatomic, copy) NSString *fromURLHost;
@property (nonatomic, copy) NSString *hasLarge;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *hoverURL;
@property (nonatomic, copy) NSString *is;
@property (nonatomic, copy) NSString *middleURL;
@property (nonatomic, copy) NSString *objURL ;
@end
