//
//  WYCollectViewCellDelegate.h
//  
//
//  Created by wangyong on 15/7/20.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

@protocol WYCollectViewCellDelegate <NSObject>
- (void)setObject:(id)item;
@optional
- (void)setObject:(id)item type:(NSInteger)type;
@end
