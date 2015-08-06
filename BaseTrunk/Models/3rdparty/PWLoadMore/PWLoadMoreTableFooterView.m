//
//  PWLoadMoreTableFooter.m
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import "PWLoadMoreTableFooterView.h"

@interface PWLoadMoreTableFooterView (Private)

@end

@implementation PWLoadMoreTableFooterView

@synthesize delegate = _delegate;

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)]) {
        
        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
		self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20.0f)];
		self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.statusLabel.font = [UIFont systemFontOfSize:14.0f];
		self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textColor = [UIColor black50PercentColor];
		self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.centerX = self.width/2;
        self.statusLabel.centerY = self.height/2;
		[self addSubview:self.statusLabel];
		
		self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.centerX = self.width/2;
        self.activityView.centerY = self.height/2;
		[self addSubview:self.activityView];
		
		[self setPWState:PWLoadMoreNormal];
    }
	
    return self;
}

- (void)setPWState:(PWLoadMoreState)aState{
	
	switch (aState) {
		case PWLoadMoreNormal:
            self.height = 50;
            
            [self addTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@">点击加载更多<", @"Load More items");
            _statusLabel.textColor = [UIColor black75PercentColor];
			[_activityView stopAnimating];
			
			break;
		case PWLoadMoreLoading:
            self.height = 50;
            
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@" ", @"Loading items");
			[_activityView startAnimating];
			
			break;
		case PWLoadMoreDone:
            self.height = 0;
            
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@" ", @"There is no more item");
            _statusLabel.textColor = [UIColor black75PercentColor];
			[_activityView stopAnimating];
			
			break;
		default:
			break;
	}
	
	_pwState = aState;
}

- (void)pwLoadMoreTableDataSourceDidFinishedLoading {
    if ([self delegateIsAllLoaded]) {
        [self noMore];
    } else {
        [self canLoadMore];
    }
}

- (BOOL)delegateIsAllLoaded {
    BOOL _allLoaded = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(pwLoadMoreTableDataSourceAllLoaded)]) {
        _allLoaded = [_delegate pwLoadMoreTableDataSourceAllLoaded];
    }
    return _allLoaded;
}

- (void)resetLoadMore {
    if ([self delegateIsAllLoaded]) {
        [self noMore];
    } else
        [self canLoadMore];
}

- (void)canLoadMore {
    [self setPWState:PWLoadMoreNormal];
}

- (void)noMore {
    [self setPWState:PWLoadMoreDone];
}

- (void)realCallDelegateToLoadMore { //temporary
    if (_delegate && [_delegate respondsToSelector:@selector(pwLoadMore)]) {
        [_delegate pwLoadMore];
        [self setPWState:PWLoadMoreLoading];
    }
}

-(void) updateStatus:(NSTimer *)timer{
    if (_delegate && [_delegate respondsToSelector:@selector(pwLoadMoreTableDataSourceIsLoading)]) {
        if ([_delegate pwLoadMoreTableDataSourceIsLoading]) {
            //Do nothing
        } else {
            [timer invalidate];
            [self pwLoadMoreTableDataSourceDidFinishedLoading];
        }
    } else {
        //Do nothing
    }
}

- (void)callDelegateToLoadMore {
    if (_pwState == PWLoadMoreNormal) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pwLoadMoreTableDataSourceIsLoading)]) {
            if (![self.delegate pwLoadMoreTableDataSourceIsLoading]) {
                [self realCallDelegateToLoadMore];
            }
        }
    }
}

- (void)startLoadMore
{
    [self callDelegateToLoadMore];
}

#pragma mark -
#pragma mark Dealloc
- (void)dealloc {
	
	_delegate=nil;
}
@end
