//
//  WYCollectionHomeViewController.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYCollectionHomeViewController.h"
#import "WYCollectionViewGridLayout.h"
#import "WYBaiduImageViewCell.h"

@interface WYCollectionHomeViewController ()
@end

@implementation WYCollectionHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)requestDidFinishLoad:(id)data
{
    if(data && [data isKindOfClass:[NSArray class]])
    {
        [self didFinishLoad:data];
        
        _loading = NO;
        
    }else if(data && [data isKindOfClass:[NSDictionary class]]) {
        [super requestDidFinishLoad:data];
        
    }else  {
        [self reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (API_GET_TYPE)modelApi
{
    return API_SEARCH_IMAGE_BAIDU_LIST;
}

- (Class)cellClass
{
    return [WYBaiduImageViewCell class];
}

- (UICollectionViewLayout*)layout
{
    static WYCollectionViewGridLayout *itemlayout = nil;
    if (!itemlayout) {
        WYCollectionViewGridLayout *layout = [[WYCollectionViewGridLayout alloc] init];
        layout.numberOfItemsPerLine = 3;
        layout.aspectRatio = 1;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.interitemSpacing = 10;
        layout.lineSpacing = 10;
        itemlayout = layout;
    }
    return itemlayout;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
