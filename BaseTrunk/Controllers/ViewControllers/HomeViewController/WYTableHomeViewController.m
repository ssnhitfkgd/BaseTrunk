//
//  WYHomeViewController.m
//  BaseTrunk
//
//  Created by wangyong on 15/8/6.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYTableHomeViewController.h"
#import "WYSingleHomeCell.h"
#import "WYFileClient.h"
#import "WYHomeDto.h"

@interface WYTableHomeViewController ()

@end

@implementation WYTableHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (API_REQUEST_TYPE)modelApi
{
    return API_SEARCH_IMAGE_BAIDU_LIST;
}

- (Class)cellClass
{
    return [WYSingleHomeCell class];
}
@end
