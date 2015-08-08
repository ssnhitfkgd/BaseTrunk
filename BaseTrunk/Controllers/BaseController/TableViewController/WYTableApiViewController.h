//
//  WYTableApiViewController.h
//
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYModelApiViewController.h"
#import "PWLoadMoreTableFooterView.h"

@interface WYTableApiViewController : WYModelApiViewController <UITableViewDelegate, UITableViewDataSource,PWLoadMoreTableFooterDelegate,WYTableCellDelegate>
{
    BOOL _headerLoading;
    BOOL _footerLoading;
    BOOL _reloading;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *errorImageView;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UILabel *errorDescriptionLabel;
@property (nonatomic, retain) UIView *errorView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) PWLoadMoreTableFooterView *tableFooterView;

@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;
@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, retain) NSNumber *loadmore;
@property (nonatomic, strong) UIRefreshControl *refresh;

- (void)createErrorView;

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





