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
#import "FRGWaterfallHeaderReusableView.h"

@interface WYCollectionHomeViewController ()
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation WYCollectionHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//     [self.collectionView registerClass:[FRGWaterfallHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
//    [self addSearchBar];
    
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

- (API_REQUEST_TYPE)modelApi
{
    return API_SEARCH_IMAGE_BAIDU_LIST;
}

- (Class)cellClass
{
    return [WYBaiduImageViewCell class];
}

- (UICollectionViewLayout*)layout
{
    static UICollectionViewLayout *itemlayout = nil;
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


//- (UICollectionViewFlowLayout *) layout{
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.headerReferenceSize = CGSizeMake(300.0f, 50.0f);  //设置head大小
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    flowLayout.minimumLineSpacing = 10;
//    flowLayout.minimumInteritemSpacing = 10;
//    return flowLayout;
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(300.0f, 50.0f);
//
//}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath{
//    
//    UICollectionReusableView *reusableview = nil;
//    
////    if (kind == UICollectionElementKindSectionHeader)
//    {
//        FRGWaterfallHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        
//        
//        reusableview = headerView;
//    }
//    [reusableview setBackgroundColor:[UIColor redColor]];
//    return reusableview;
//}
//
//- (CGFloat)getTempHeight
//{
//    return 44;
//}
//
//- (void)addSearchBar
//{
//    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.width, 44.0f)];
//    searchBar.placeholder = (@"搜索图片");
//    searchBar.delegate = self;
//    searchBar.showsCancelButton = YES;
//    searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    [self.view addSubview:searchBar];
//    self.searchBar = searchBar;
//}



@end
