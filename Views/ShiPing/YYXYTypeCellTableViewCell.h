//
//  YYXYTypeCellTableViewCell.h
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYXYTypeCellTableViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *item;

+ (YYXYTypeCellTableViewCell*)cell;

@end
