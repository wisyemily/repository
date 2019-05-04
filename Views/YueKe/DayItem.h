//
//  DayItem.h
//  jsz
//
//  Created by 朱东勇 on 2018/3/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DayItem;
typedef void(^DayItemHander) (DayItem *item);
@interface DayItem : UIView
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) BOOL selected;

@property (nonatomic, copy) DayItemHander hander;

+ (DayItem*)item;

@end
