//
//  WYModelApiViewController.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//


#import "WYModelApiViewController.h"
#import "SBJson.h"
#import "WYFileClient.h"
#import "WYParamsBaseObject.h"
#import "MMDiskCacheCenter.h"


@interface WYModelApiViewController()
@property (nonatomic, strong) id model;
@end


@implementation WYModelApiViewController
@synthesize model;

- (NSString *)getPageName
{
    return self.title;
}

#pragma mark subclass override
- (id)paramsObject:(BOOL)more
{
    NSAssert(NO, @"the method \"getParamsBaseModel\" Must be rewritten");
    return nil;
}

- (id)init{
    self = [super init]; 
    if (self) {
        _loadMore = NO;
        _loading = NO;
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSString *pageName = [self getPageName];
    if(pageName)
    {
    //    [MobClick endLogPageView:[self getPageName]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark data handling methods
- (void)clearArrangedObjects
{
    self.model = nil;
}

- (id)arrangedObjects
{
    return self.model;
}

- (id)objectInArrangedObjectAtIndexPath:(NSIndexPath*)indexpath
{
    id item = nil;
    if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
    {
        item = [self.model objectAtIndex:indexpath.row];
    }
    else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
    {
        item = self.model;
    }
    
    return item;
}

- (NSInteger)countOfArrangedObjects
{
    if(self.model == nil)
    {
        return 0;
    }
    if([self.model isKindOfClass:[NSDictionary class]])
    {
        return 1;
    }
    
    return [self.model count];
}

#pragma mark request methods
- (NSURLRequestCachePolicy)getPolicy
{
    return NSURLRequestReloadRevalidatingCacheData;
}

- (void)reloadData {
    
    if (![self isLoading])
    {
        [self clearArrangedObjects];
        [self loadData:NSURLRequestReloadIgnoringCacheData more:NO];
    }
}

- (void)startLoadData:(NSNumber *)loadHeader
{
    BOOL loadMore = [loadHeader boolValue];
    
    [self loadData:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
              more:loadMore];
}

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    _loading = YES;
    
    NSInteger pageSize = [self getPageSize];//MODEL_PAGE_SIZE;
    NSString *offset_id = more?_offsetID:@"";
    _loadMore = more;
    
    WYParamsBaseObject *params = [self paramsObject:_loadMore];
    params.offset_id = offset_id;
    params.page_size = pageSize;
    
    
    WYFileClient *client = [WYFileClient sharedInstance];
    [client request_send:params cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestDidError:)];
}

- (void)requestDidFinishLoad:(id)data
{
    _loading = NO;
    if(data && [data isKindOfClass:[NSDictionary class]])
    {
        
        id obj = [data objectForKey:@"list"];
        if(obj && [obj isKindOfClass:[NSArray class]])
        {
            id offset_id = [data objectForKey:@"offset_id"];
            if(offset_id && [offset_id isKindOfClass:[NSString class]])
            {
                _offsetID = offset_id;
            }
            
            if([data objectForKey:@"cache"] && !_loadMore)
            {
                [self clearArrangedObjects];
            }
            
            [self didFinishLoad:obj];
        }
    }
}

- (void)requestDidError:(NSError*)error
{
    _loading = NO;
    [self didFailWithError:error];
}


- (void)didFailWithError:(NSError*)error
{

}

- (void)didFinishLoad:(id)object {
    
    if(object && [object isEqual: model])
    {
        return;
    }
    
    if (model) {
        // is loading more here
        [self.model addObjectsFromArray:object];
    } else {
        self.model = object;
    }
}

- (BOOL)isLoading
{
    return _loading;
}

- (NSInteger)getPageSize
{
    return MODEL_PAGE_SIZE;
}

- (NSString*)getOffsetID
{
    return _offsetID?:@"";
}

- (void)setOffsetID:(NSString*)offset
{
    _offsetID = offset;
}

- (NSString *)getCacheKey
{
    NSString *key = [NSStringFromClass([self class]) md5Value];
    return [NSString stringWithFormat:@"%@",key];
}

- (id)searchCache
{
    return [[MMDiskCacheCenter sharedInstance] cacheForKey:[self getCacheKey] dataType:[NSArray class]];
}

- (void)setCache:(id)cache
{
    [[MMDiskCacheCenter sharedInstance] setCache:cache forKey:[self getCacheKey]];
}

#pragma mark didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
