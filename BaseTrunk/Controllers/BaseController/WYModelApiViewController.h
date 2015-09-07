//
//  WYModelApiViewController.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#include "WYBaseController.h"

#define MODEL_PAGE_SIZE 100


/********************************添加api 以追加得方式 向下拓展 否则缓存数据会错乱**********************************/
typedef NS_ENUM(NSUInteger, API_REQUEST_TYPE)
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


- (void)clearArrangedObjects;
- (id)arrangedObjects;
- (id)objectInArrangedObjectAtIndexPath:(NSIndexPath*)indexpath;
- (NSInteger)countOfArrangedObjects;


- (void)reloadData;

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more;
- (void)startLoadData:(NSNumber *)loadHeader;

- (void)didFinishLoad:(id)object;
- (void)didFailWithError:(NSError *)error;

- (void)requestDidFinishLoad:(NSData*)data;
- (void)requestDidError:(NSError*)error;

- (NSString*)getOffsetID;
- (void)setOffsetID:(NSString*)offset;
- (NSInteger)getPageSize;

// subclass to override
- (API_REQUEST_TYPE)modelApi;
@end
