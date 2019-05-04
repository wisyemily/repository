//
//  DSKViewCell.h
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YSKActionTypeEnter,
    YSKActionTypePL,
    YSKActionTypePreview,
    YSKActionTypeSearch
}YSKActionType;

@interface YSKViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, copy) void(^action)(YSKViewCell *cell, YSKActionType type);

+ (YSKViewCell*)cell;

@end
