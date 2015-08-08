//
//  WYCollectionApiViewController.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/6.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYModelApiViewController.h"
#import "PWLoadMoreTableFooterView.h"
#import "SVPullToRefresh.h"
#import "WYTableCellDelegate.h"

@protocol WYCollectionApiViewControllerDelegate<NSObject>

@optional
- (API_GET_TYPE)modelApi;
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
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) UIImageView *errorImageView;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UILabel *errorDescriptionLabel;
@property (nonatomic, retain) UIView *errorView;
@property (nonatomic, retain) NSNumber *loadmore;

- (Class)cellClass;
- (UICollectionViewLayout *)layout;
@end
