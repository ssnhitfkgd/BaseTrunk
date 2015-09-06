//
//  WYCollectionApiViewController.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/6.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYModelApiViewController.h"
#import "SVPullToRefresh.h"
#import "WYErrorView.h"

@protocol WYCollectionApiViewControllerDelegate<NSObject>

@optional
- (API_REQUEST_TYPE)modelApi;
- (Class)cellClass;
@end

@interface WYCollectionApiViewController : WYModelApiViewController<WYCollectionApiViewControllerDelegate>
{
    BOOL _headerLoading;
    BOOL _footerLoading;
    BOOL _reloading;
}


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) WYErrorView *errorView;
@property (nonatomic, strong) NSNumber *loadmore;


- (CGFloat)headerHeight;
- (Class)cellClass;
- (UICollectionViewLayout *)layout;
@end
