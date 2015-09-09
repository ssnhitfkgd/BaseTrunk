//
//  WYModelApiViewController.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#include "WYBaseController.h"

#define MODEL_PAGE_SIZE 30

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
//- (void)updateTableView:(id)object;
- (void)didFailWithError:(NSError *)error;

- (void)requestDidFinishLoad:(NSData*)data;
- (void)requestDidError:(NSError*)error;

- (NSString*)getOffsetID;
- (void)setOffsetID:(NSString*)offset;
- (NSInteger)getPageSize;
- (NSString *)getCacheKey;

- (id)searchCache;
- (void)setCache:(id)cache;

// subclass to override
- (id)paramsObject:(BOOL)more;
//option
- (NSString*)getPageName;
@end
