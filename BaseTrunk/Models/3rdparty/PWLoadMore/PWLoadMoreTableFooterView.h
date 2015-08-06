//
//  PWLoadMoreTableFooter.h
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
	PWLoadMoreNormal = 0,
    PWLoadMoreLoading,
    PWLoadMoreDone,
} PWLoadMoreState;


@protocol PWLoadMoreTableFooterDelegate;
@interface PWLoadMoreTableFooterView : UIControl {
    id __unsafe_unretained delegate;
}

@property (nonatomic, unsafe_unretained) id <PWLoadMoreTableFooterDelegate> delegate;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) PWLoadMoreState pwState;

- (void)pwLoadMoreTableDataSourceDidFinishedLoading;
- (void)resetLoadMore;
- (void)setPWState:(PWLoadMoreState)aState;
- (void)startLoadMore;

@end

@protocol PWLoadMoreTableFooterDelegate <NSObject>
@required
- (void)pwLoadMore;
- (BOOL)pwLoadMoreTableDataSourceAllLoaded;
- (BOOL)pwLoadMoreTableDataSourceIsLoading; //optional temporary
@end