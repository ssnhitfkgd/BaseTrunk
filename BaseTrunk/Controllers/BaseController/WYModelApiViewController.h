//
//  WYModelApiViewController.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#include "WYBaseController.h"

#define MODEL_PAGE_SIZE 30


/********************************添加api 以追加得方式 向下拓展 否则缓存数据会错乱**********************************/
typedef NS_ENUM(NSUInteger, API_GET_TYPE)
{
    API_SEARCH_IMAGE_BAIDU_LIST,

};
/********************************添加api 以追加得方式 向下拓展 否则缓存数据会错乱**********************************/



typedef NS_ENUM(NSUInteger, API_GET_CODE)
{
    ERROR_CODE_SUCCESS = 0,
    ERROR_CODE_NORMAL,
    ERROR_CODE_NEED_AUTH,
};



@interface WYModelApiViewController : WYBaseController  {
    NSString *_offsetID;
    BOOL _loadMore;
    BOOL _loading;
}

@property (nonatomic, strong) id model;

- (API_GET_TYPE)modelApi;
- (void)reloadData;

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more;
- (void)startLoadData:(NSNumber *)loadHeader;

- (void)didFinishLoad:(id)object;
- (void)didFailWithError:(NSError *)error;
- (void)requestDidFinishLoad:(NSData*)data;
- (void)requestDidError:(NSError*)error;

- (void)relogin;
// subclass to override
- (NSString*)getOffsetID;
- (void)setOffsetID:(NSString*)offset;
- (int)getPageSize;

@end
