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
#import "WYBaiduImageObject.h"

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

- (id)paramsObject:(BOOL)more
{
    
    WYBaiduImageObject *model = [WYBaiduImageObject new];
    model.url = URL_BAIDU_IMAGE;
    model.post = NO;
    model.version = @"1.0";
    model.tn = @"baiduimagejson";
    model.word = @"搞笑";
    model.z = @"3";
    model.ie = @"utf-8";
    model.oe = @"utf-8";
    model.rn = [NSString stringWithFormat:@"%ld",[self getPageSize]];
    model.pn = [NSString stringWithFormat:@"%ld",more?[self countOfArrangedObjects]:0];
    return model;
}

- (Class)cellClass
{
    return [WYSingleHomeCell class];
}
@end
