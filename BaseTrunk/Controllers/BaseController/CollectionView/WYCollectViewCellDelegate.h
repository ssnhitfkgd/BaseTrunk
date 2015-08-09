//
//  WYCollectViewCellDelegate.h
//  BaseTrunk
//
//  Created by wangyong on 15/8/8.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

@protocol WYCollectViewCellDelegate <NSObject>
- (void)setObject:(id)item;
@optional
- (void)setObject:(id)item type:(NSInteger)type;
@end
