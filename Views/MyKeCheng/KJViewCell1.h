//
//  DSKViewCell.h
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KJActionType1Enter,
    KJActionType1Bind
}KJActionType1;

@interface KJViewCell1 : UITableViewCell
@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, copy) void(^action)(KJViewCell1 *cell, KJActionType1 type);

+ (KJViewCell1*)cell;

@end
