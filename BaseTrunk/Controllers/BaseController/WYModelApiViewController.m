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


@implementation WYModelApiViewController
@synthesize model;


- (id)init{
    self = [super init]; 
    if (self) {
        _loadMore = NO;
        _loading = NO;
    }
    return self;
}

// --- ---
- (NSURLRequestCachePolicy)getPolicy
{
    NSURLRequestCachePolicy getPolicy = NSURLRequestReloadRevalidatingCacheData;
    return getPolicy;
}

- (API_GET_TYPE)modelApi
{
    NSAssert(NO, @"the method \"modelApi\" Must be rewritten");
    return -1;
}

- (void)startLoadData:(NSNumber *)loadHeader
{
    BOOL loadMore = [loadHeader boolValue];
    
    [self loadData:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
              more:loadMore];
}

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    
    API_GET_TYPE api_type = [self modelApi];
    _loading = YES;
    
    WYFileClient *client = [WYFileClient sharedInstance];
    int pageSize = [self getPageSize];//MODEL_PAGE_SIZE;
    NSString *offset_id = more?_offsetID:@"";
    _loadMore = more;
    
    
    switch (api_type) {            
        case API_SEARCH_IMAGE_BAIDU_LIST:
            [client list_image_baidu:pageSize offsetId:more?((int)([self.model count])):0 text:@"haha" cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestDidError:)];
            break;
       
        default:
            break;
    }
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

#pragma mark -
- (void)reloadData {
    
    if (![self isLoading])
    {
        self.model = nil;
        [self loadData:NSURLRequestReloadIgnoringCacheData more:NO];
    }
}

- (BOOL)isLoading
{
    return _loading;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:[self getPageName]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSString*)getPageName
{
    API_GET_TYPE api_type = [self modelApi];
    NSString *pageName = @"未知";
        
    switch (api_type) {
          
        default:
            break;
    }
    
    return pageName;
}

- (void)relogin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AgainLoginNotification object:nil];
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
                self.model = nil;
            }
            
            [self didFinishLoad:obj];
        }
    }
}

- (void)didFailWithError:(NSError*)error
{
    
    
}

- (void)requestDidError:(NSError*)error
{
    _loading = NO;
    [self didFailWithError:error];
}

#pragma mark subclass override
- (int)getPageSize
{
    return MODEL_PAGE_SIZE;
}

- (NSString*)getOffsetID
{
    return _offsetID?_offsetID:@"";
}

- (void)setOffsetID:(NSString*)offset
{
    _offsetID = offset;
}


#pragma mark
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
