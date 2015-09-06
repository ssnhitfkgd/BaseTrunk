//
//  WYTableApiViewController.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYModelApiViewController.h"
#import "PWLoadMoreTableFooterView.h"
#import "WYTableCellDelegate.h"
#import "WYErrorView.h"

@interface WYTableApiViewController : WYModelApiViewController <UITableViewDelegate, UITableViewDataSource,PWLoadMoreTableFooterDelegate>
{
    BOOL _headerLoading;
    BOOL _footerLoading;
    BOOL _reloading;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WYErrorView *errorView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) PWLoadMoreTableFooterView *tableFooterView;

@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;
@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, strong) NSNumber *loadmore;
@property (nonatomic, strong) UIRefreshControl *refresh;


- (Class)cellClass;
- (void)setSeparatorClear;
- (void)setupSubviews;

- (void)didFinishLoad:(id)array;
- (void)didFailWithError:(NSError *)error;
- (void)activityIndicatorAnimal:(BOOL)animal;

//OVERRIDE
- (void)activeRefresh;
- (void)reloadHeaderTableViewDataSource;
- (void)reloadFooterTableViewDataSource;
- (void)finishLoadHeaderTableViewDataSource;
- (void)finishLoadFooterTableViewDataSource;
- (void)setEnableFooter:(BOOL)tf;
- (void)dealFinishLoad:(id)array;
- (void)refreshTableView:(UIRefreshControl *)refresh;

- (void)setEnableHeader:(BOOL)tf;
- (void)setupData;
- (void)setupTableView;
- (UITableViewStyle)getTableViewStyle;

- (void)reloadWithCache:(id)cache;//使用缓存时，使用的reload方法 //有特殊需要的子类可以复写此方法，例如detailVC
- (NSString *)getCacheKey;//有特殊需要的子类可以复写此方法，例如detailVC
- (void)setDisplayCell:(id)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)addSubErrorView;
@end


@protocol RefreshTableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@optional

- (void)loadHeader;
- (void)loadFooter;
@end





