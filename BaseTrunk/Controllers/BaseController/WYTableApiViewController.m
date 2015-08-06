//
//  WYTableApiViewController.m
//
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYTableApiViewController.h"
#import "WYTableCellDelegate.h"
#import "WYFileClient.h"

#import "MMDiskCacheCenter.h"

#define IOS7 (__IPHONE_OS_VERSION_MIN_REQUIRED >= 70000)

@implementation WYTableApiViewController

- (Class)cellClass {
    NSAssert(NO, @"the method \"cellClass\" Must be rewritten");
    return NULL;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didFailWithError:(NSError *)error
{
    
    if(self.activityIndicator)
    {
        [self activityIndicatorAnimal:NO];
    }
    
    if(_footerLoading)
    {
        [self performSelector:@selector(finishLoadFooterTableViewDataSource) withObject:nil afterDelay:0.01];
    }
    
    if(_headerLoading)
    {
        [self performSelector:@selector(finishLoadHeaderTableViewDataSource) withObject:nil afterDelay:0.01];
    }
    
    [self setEnableFooter:NO];

    
    [_errorView removeFromSuperview];

    NSString *strFailText = WhisperLocalized(@"网络异常，请稍后重试");
    if ([error.domain isEqualToString:ERROR_DOMAIN]) {
        strFailText = [error.userInfo objectForKey:@"reason"];
    } else {
        if([[WYFileClient sharedInstance] getNetworkingType] == 0)
        {
            strFailText = WhisperLocalized(@"当前没有连接到网络");
        }
        else if(error.code == -1001){
            
            strFailText = WhisperLocalized(@"连接超时，请稍后重试");
        }
        else if(error.code == -1202)
        {
            //过滤https证书得错误
            strFailText = nil;
        }
        else if(error.localizedDescription)
        {
            strFailText = error.localizedDescription;
        }
    }
    
    
    if(self.model && [(NSArray*)self.model count] > 0)
    {
        if(strFailText)
        {
            [SVProgressHUD showErrorWithStatus:strFailText];
        }
    }
    else
    {
        [_errorDescriptionLabel setText:@""];
        [_errorLabel setText:strFailText?strFailText:WhisperLocalized(@"网络异常，请稍后重试")];
        [_errorImageView setImage:[UIImage imageNamed:@"dd"]];
        [_tableView addSubview:_errorView];
    }

    if (error.code == -1024){
        [_errorImageView setImage:[UIImage imageNamed:@"dd"]];
        [_errorLabel setText:WhisperLocalized(@"未获取到地理位置")];
        [_errorDescriptionLabel setText:WhisperLocalized(@"请前往iOS系统设置>隐私>定位服务，找到悄悄话，并打开定位服务: )")];
    }
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
            [_tableView reloadData];
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
        [self.tableFooterView setPWState:PWLoadMoreNormal];
        
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

- (void)didFinishLoad:(id)array
{
    [self dealFinishLoad:array];

    [super didFinishLoad:array];
    [_tableView reloadData];
}

- (void)addSubErrorView
{
    API_GET_TYPE api_type = [self modelApi];
    switch (api_type) {
        default:
            [_errorLabel setText:WhisperLocalized(@"😥暂时没有数据")];
            break;
    }
    
   
    [_tableView addSubview:_errorView];
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupData];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:[self getTableViewStyle]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    _tableView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:_tableView];
    
    self.tableFooterView = [PWLoadMoreTableFooterView new];
    self.tableFooterView.delegate = self;
    [self.tableFooterView setPWState:PWLoadMoreNormal];
    self.tableView.tableFooterView = self.tableFooterView;
    
    _headerLoading = NO;
    _footerLoading = NO;
    
    _hasMore = NO;
    
    // Do any additional setup after loading the view.
   
    [self activityIndicatorAnimal:YES];
    
    
    [self createErrorView];
    
    [self setEnableHeader:YES];
    [self setEnableFooter:NO];
}

- (UIActivityIndicatorView*)activityIndicator
{
    if(!_activityIndicator)
    {
        // Do any additional setup after loading the view.
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [_activityIndicator setHidesWhenStopped:YES];
        _activityIndicator.centerX = _tableView.width/2;
        _activityIndicator.centerY = _tableView.tableHeaderView.height + (_tableView.height - _tableView.tableHeaderView.height)/2 +  [self getTempHeight];
        [self.tableView addSubview:_activityIndicator];
        [self activityIndicatorAnimal:YES];
    }
    
    return _activityIndicator;
}

- (CGFloat)getTempHeight
{
    return -44;
}

- (void)setupSubviews {
    [self setupTableView];
}

- (void)refreshTableView:(UIRefreshControl *)refresh
{
    [self performSelector:@selector(reloadHeaderTableViewDataSource) withObject:nil afterDelay:0.0];
//    [self reloadHeaderTableViewDataSource];
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
    [_errorView setBackgroundColor:_tableView.backgroundColor];
    
    _activityIndicator.centerX = _tableView.width/2;
    _activityIndicator.centerY = _tableView.tableHeaderView.height + (_tableView.height - _tableView.tableHeaderView.height)/2 +  [self getTempHeight];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[self getTableView] reloadData]; //转移到didappear里了，by kevin
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

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

- (void)setSeparatorClear
{
    [_tableView setSeparatorColor:[UIColor clearColor]];
}

- (UITableViewStyle)getTableViewStyle
{
    return UITableViewStylePlain;
}

- (BOOL)getCacheWithRefresh
{
    return YES;
}

- (NSString *)getCacheKey
{
    return [NSString stringWithFormat:@"API_CACHE_%lu",(unsigned long)[self modelApi]];
}

#pragma mark -
#pragma mark UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.model== nil)
        return 0;
    if([self.model isKindOfClass:[NSDictionary class]])
        return 1;
    
    return [(NSArray*)self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class cls = [self cellClass];
    NSString *identifier = (indexPath.row/2==0)?@"Cell":@"CELL";
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = nil;
    if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
        item = [self.model objectAtIndex:indexPath.row];
    else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
        item = self.model;
    Class cls = [self cellClass];
    if ([cls respondsToSelector:@selector(rowHeightForObject:)]) {
        return [cls rowHeightForObject:item];
    }
    return tableView.rowHeight; // failover
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark refreshView Methods

- (void)activeRefresh
{
    [_tableView setContentOffset:CGPointMake(0, -([_tableView contentInset].top +60)) animated:NO];
    [self.refresh beginRefreshing];
    [self refreshTableView:self.refresh];
    _headerLoading = YES;
}

- (void)setEnableFooter:(BOOL)tf
{
    _enableFooter = tf;
    
    if (tf) {
        [self.tableFooterView setPWState:PWLoadMoreNormal];
        self.tableView.tableFooterView = self.tableFooterView;
    }else {
        self.tableView.tableFooterView = nil;
    }
}

- (void)setEnableHeader:(BOOL)tf
{
    _enableHeader = tf;
    if (tf) {
        if (!self.refresh || !self.refresh.superview) {
            self.refresh = [UIRefreshControl new];
            [_refresh addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
            _refresh.tintColor = [UIColor black75PercentColor];
            [_tableView addSubview:_refresh];
        }
    }else {
        if (self.refresh && self.refresh.superview) {
            [self.refresh removeFromSuperview];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([[WYFileClient sharedInstance] getNetworkingType] > 0) {
        
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 10;
        if(y > h + reload_distance) {
            if (self.enableFooter && !_footerLoading && self.hasMore) {
                {
                    [NSThread detachNewThreadSelector:@selector(startLoadMore) toTarget:self.tableFooterView withObject:nil];
                }
            }else {

            }
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //勿删
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //勿删
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //勿删
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //勿删
    return YES;
}

#pragma mark LoadMoreDelegate
- (void)pwLoadMore
{
    [self reloadFooterTableViewDataSource];
}

- (BOOL)pwLoadMoreTableDataSourceAllLoaded
{
    return !self.hasMore;
}

- (BOOL)pwLoadMoreTableDataSourceIsLoading
{
    return _footerLoading;
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
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];

    }];
}

- (void)finishLoadFooterTableViewDataSource
{
    _footerLoading = NO;
    if([self.tableFooterView respondsToSelector:@selector(pwLoadMoreTableDataSourceDidFinishedLoading)]){
    [self.tableFooterView performSelectorOnMainThread:@selector(pwLoadMoreTableDataSourceDidFinishedLoading) withObject:nil waitUntilDone:NO];
    }
}

- (void)startLoadData:(NSNumber *)loadHeader
{
    [super startLoadData:loadHeader];
}

- (void)dealloc
{
    self.tableFooterView.delegate = nil;
    self.tableFooterView = nil;
    
    self.errorImageView = nil;
    self.errorLabel = nil;
    self.errorDescriptionLabel = nil;
    self.errorView = nil;
    self.activityIndicator = nil;
    
    self.loadmore = nil;
    self.refresh = nil;

    [_tableView setDataSource:nil];
    [_tableView setDelegate:nil];
    _tableView = nil;
}

@end
