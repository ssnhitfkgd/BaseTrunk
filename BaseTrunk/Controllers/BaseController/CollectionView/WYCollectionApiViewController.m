//
//  WYCollectionApiViewController.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/6.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYCollectionApiViewController.h"
#import "WYCollectionViewGridLayout.h"
#import "WYCollectViewCellDelegate.h"
#import "MMDiskCacheCenter.h"

@interface WYCollectionApiViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation WYCollectionApiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    [_collectionView registerClass:[self cellClass] forCellWithReuseIdentifier:NSStringFromClass([self cellClass])];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    [_collectionView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.view addSubview:_collectionView];
    
    [self setEnableHeader:YES];
    
    [self activityIndicatorAnimal:YES];
    [self setupData];

    
    [self createErrorView];
    
    // setup infinite scrolling
    __block typeof(self) block_self = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [block_self reloadFooterTableViewDataSource];
    }];

}


- (void)createErrorView
{
    self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
    
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 15)];
    [_errorLabel setCenterY:self.errorView.height/2.f+44];
    [_errorLabel setCenterX:self.errorView.width/2.f];
    [_errorLabel setFont:[UIFont systemFontOfSize:14.]];
    [_errorLabel setTextColor:[UIColor colorWithRed:155./255. green:155./255. blue:155./255. alpha:1.0]];
    [_errorLabel setTextAlignment:NSTextAlignmentCenter];
    [_errorLabel setBackgroundColor:[UIColor clearColor]];
    
    self.errorDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
    [_errorDescriptionLabel setTop:_errorLabel.bottom + 2];
    [_errorDescriptionLabel setCenterX:self.errorView.width/2];
    [_errorDescriptionLabel setFont:[UIFont systemFontOfSize:12.]];
    [_errorDescriptionLabel setTextColor:[UIColor black75PercentColor]];
    [_errorDescriptionLabel setTextAlignment:NSTextAlignmentCenter];
    [_errorDescriptionLabel setBackgroundColor:[UIColor clearColor]];
    [_errorDescriptionLabel setNumberOfLines:0];
    [_errorDescriptionLabel setClipsToBounds:NO];
    
    //[_errorView addSubview:_errorImageView];
    [_errorView addSubview:_errorLabel];
    [_errorView addSubview:_errorDescriptionLabel];
    [_errorView setBackgroundColor:_collectionView.backgroundColor];
    
    _activityIndicator.center = self.view.center;
    
}

- (void)setupData
{
    //取缓存
    id cache = [[MMDiskCacheCenter sharedInstance] cacheForKey:[self getCacheKey] dataType:[NSArray class]];
    
    if (cache && [cache isKindOfClass:[NSArray class]]) {
        //有缓存
        [self reloadWithCache:[[NSMutableArray alloc] initWithArray:cache]];
        
    }else {
        //无缓存
        [self reloadData];
    }
}


- (NSString *)getCacheKey
{
    return [NSString stringWithFormat:@"API_CACHE_%lu",(unsigned long)[self modelApi]];
}

- (void)reloadData
{
    self.loadmore = [NSNumber numberWithBool:NO];
    [super reloadData];
}

- (void)reloadWithCache:(id)cache
{
    [self didFinishLoad:cache];
    
    [self refreshTableView:nil];
    
    //    [self performSelector:@selector(activeRefresh) withObject:nil afterDelay:0.1];
}



- (void)activeRefresh
{
    [_collectionView setContentOffset:CGPointMake(0, -([_collectionView contentInset].top +60)) animated:NO];
    [self.refresh beginRefreshing];
    [self refreshTableView:self.refresh];
    _headerLoading = YES;
}

- (void)setEnableFooter:(BOOL)tf
{
    _enableFooter = tf;
    
    [_collectionView.infiniteScrollingView setEnabled:tf];

}

- (void)setEnableHeader:(BOOL)tf
{
    _enableHeader = tf;
    if (tf) {
        if (!self.refresh || !self.refresh.superview) {
            self.refresh = [UIRefreshControl new];
            [_refresh addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
            _refresh.tintColor = [UIColor black75PercentColor];
            [_collectionView addSubview:_refresh];
        }
    }else {
        if (self.refresh && self.refresh.superview) {
            [self.refresh removeFromSuperview];
        }
    }
}


- (void)refreshTableView:(UIRefreshControl *)refresh
{
    [self performSelector:@selector(reloadHeaderTableViewDataSource) withObject:nil afterDelay:0.0];
    //    [self reloadHeaderTableViewDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewLayout *)layout
{
    NSAssert(NO, @"the method \"layout\" Must be rewritten");
    return NULL;
}

- (Class)cellClass {
    NSAssert(NO, @"the method \"cellClass\" Must be rewritten");
    return NULL;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.model== nil)
        return 0;
    if([self.model isKindOfClass:[NSDictionary class]])
        return 1;
    
    return [(NSArray*)self.model count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor greenColor]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self cellClass]) forIndexPath:indexPath];
    
    [self setDisplayCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)setDisplayCell:(id)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setObject:)]) {
        if([(NSArray*)self.model count] > indexPath.row)
        {
            id item = nil;
            if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
                item = [self.model objectAtIndex:indexPath.row];
            else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
                item = self.model;
            
            [cell setObject:item];
        }
    }
}


#pragma mark LoadMoreDelegate

- (UIActivityIndicatorView*)activityIndicator
{
    if(!_activityIndicator)
    {
        // Do any additional setup after loading the view.
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [_activityIndicator setHidesWhenStopped:YES];
        _activityIndicator.center = self.view.center;
        [_collectionView addSubview:_activityIndicator];
        [self activityIndicatorAnimal:YES];
    }
    
    return _activityIndicator;
}

- (void)activityIndicatorAnimal:(BOOL)animal
{
    if(animal)
    {
        [self.activityIndicator startAnimating];
    }
    else
    {
        [self.activityIndicator stopAnimating];
    }
    
}


- (void)reloadHeaderTableViewDataSource
{
    if([self.activityIndicator isAnimating])
    {
        return;
    }
    _headerLoading = YES;
    
    self.loadmore = [NSNumber numberWithBool:NO];
    
    if ([self respondsToSelector:@selector(startLoadData:)] == YES) {
        [NSThread detachNewThreadSelector:@selector(startLoadData:)
                                 toTarget:self
                               withObject:self.loadmore];
    }
}

- (void)reloadFooterTableViewDataSource
{
    _footerLoading = YES;
    
    self.loadmore = [NSNumber numberWithBool:YES];
    
    if ([self respondsToSelector:@selector(startLoadData:)] == YES) {
        [NSThread detachNewThreadSelector:@selector(startLoadData:)
                                 toTarget:self
                               withObject:self.loadmore];
    }
    
}

- (void)finishLoadHeaderTableViewDataSource
{
    _headerLoading = NO;
    
    if([self.refresh respondsToSelector:@selector(endRefreshing)])
        [self.refresh performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
    
    [UIView animateWithDuration:0.25 animations:^{
        [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        
    }];
}



- (void)finishLoadFooterTableViewDataSource
{
    
    _footerLoading = NO;
    
    __weak typeof(self) weakSelf = self;
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
    });
    
}


- (void)didFinishLoad:(id)array
{
    [self dealFinishLoad:array];
    
    [super didFinishLoad:array];
    [_collectionView reloadData];
}



- (void)dealFinishLoad:(id)array
{
    //存储缓存
    if (self.loadmore == [NSNumber numberWithBool:NO]) {
        if (array) {
            [[MMDiskCacheCenter sharedInstance] setCache:array forKey:[self getCacheKey]];
        }
    }
    
    if(self.activityIndicator)
    {
        [self activityIndicatorAnimal:NO];
    }
    
    [_errorView removeFromSuperview];
    
    [self setEnableFooter:YES];
    
    if([(NSArray*)array count] == 0)
    {
        if(self.model == nil)
        {
            //list 为空
            
            [self addSubErrorView];
            [_collectionView reloadData];
            [self setEnableFooter:NO];
            
            if(_headerLoading)
            {
                self.model = nil;
                [self performSelector:@selector(finishLoadHeaderTableViewDataSource) withObject:nil afterDelay:0.01];
            }
            
            return;
        }
    }
    
    if ([(NSArray*)array count] < [self getPageSize]){
        self.hasMore = NO;
        //        [self.loadMoreFooterView setPWState:PWLoadMoreDone];
        [self setEnableFooter:NO];
        
    }else{
        self.hasMore = YES;
        [self.collectionView.infiniteScrollingView setHidden:NO];
        
    }
    
    if(_footerLoading)
    {
        [self performSelector:@selector(finishLoadFooterTableViewDataSource) withObject:nil afterDelay:0.01];
    }
    
    if(_headerLoading)
    {
        self.model = nil;
        [self performSelector:@selector(finishLoadHeaderTableViewDataSource) withObject:nil afterDelay:0.01];
    }
}

- (void)addSubErrorView
{
    API_GET_TYPE api_type = [self modelApi];
    switch (api_type) {
        default:
            [_errorLabel setText:WhisperLocalized(@"😥暂时没有数据")];
            break;
    }
    
    
    [_collectionView addSubview:_errorView];
}


- (void)startLoadData:(NSNumber *)loadHeader
{
    [super startLoadData:loadHeader];
}


@end
