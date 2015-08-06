//
//  WYHomeViewController.m
//  
//
//  Created by wangyong on 15/7/21.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

#import "WYHomeViewController.h"
#import "WYSingleHomeCell.h"
#import "WYFileClient.h"
#import "WYHomeDto.h"

@interface WYHomeViewController ()

@end

@implementation WYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self performSelector:@selector(loadLiveHost) withObject:nil afterDelay:0];
    
    
}

- (void)loadLiveHost
{
    [[WYFileClient sharedInstance] live_host:0 offsetId:@""  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData delegate:self selector:@selector(liveHostRequestDidFinishLoad:) selectorError:@selector(liveHostRequestError:)];
    
    [self performSelector:@selector(loadLiveHost) withObject:nil afterDelay:60];

}

- (void)liveHostRequestDidFinishLoad:(NSDictionary *)data
{

    if (data && [data isKindOfClass:[NSDictionary class]]) {
        id obj = [data objectForKey:@"rooms"];
        self.liveArray = obj;
        
    
        for(NSDictionary *dict1 in self.liveArray)
        {
            WYHomeDto *dto1 = [WYHomeDto new];
            if([dto1 parseData:dict1])
            {
                for(NSMutableDictionary *dict in [self.model copy])
                {
                    [dict setObject:@"0" forKey:@"state"];
                    WYHomeDto *dto = [WYHomeDto new];
                    if([dto parseData:dict])
                    {
                        if(dto.roomId == dto1.roomId)
                        {
                            [self.model removeObject:dict];
                        }
                    }
                }
            }
            
            
            [self.model insertObject:dict1 atIndex:0];
        }
        
        
        [self.tableView reloadData];
    }
}

- (void)liveHostRequestError:(NSError*)error
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (API_GET_TYPE)modelApi
{
    return API_ALL_HOST_LIST;
}

- (Class)cellClass
{
    return [WYSingleHomeCell class];
}
@end
