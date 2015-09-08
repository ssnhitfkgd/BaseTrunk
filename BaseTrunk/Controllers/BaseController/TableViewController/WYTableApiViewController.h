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



- (Class)cellClass;
- (void)setSeparatorClear;



- (void)didFailWithError:(NSError *)error;
- (void)activityIndicatorAnimal:(BOOL)animal;

//OVERRIDE
- (void)activeRefresh;
- (void)setEnableHeader:(BOOL)tf;
- (void)setEnableFooter:(BOOL)tf;
- (void)dealFinishLoad:(id)array;

- (void)setupData;
- (UITableViewStyle)getTableViewStyle;

- (void)reloadWithCache:(id)cache;
- (void)setDisplayCell:(id)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateErrorDescription;
@end


@protocol RefreshTableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@optional

- (void)loadHeader;
- (void)loadFooter;
@end





