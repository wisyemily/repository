//
//  TimeItem.h
//  jsz
//
//  Created by 朱东勇 on 2018/3/30.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeItem;
typedef void(^TimeItemHander) (TimeItem *item);
@interface TimeItem : UIView
@property (nonatomic) BOOL selected;
@property (nonatomic, copy) NSString *string;

@property (nonatomic, copy) TimeItemHander hander;

+ (TimeItem*)item;

@end
