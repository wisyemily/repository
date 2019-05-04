//
//  DSKViewCell.h
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DSKActionTypeEnter,
    DSKActionTypeRemove,
    DSKActionTypeSelectDoc
}DSKActionType;

@interface DSKViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, copy) void(^action)(DSKViewCell *cell, DSKActionType type);

+ (DSKViewCell*)cell;

@end
