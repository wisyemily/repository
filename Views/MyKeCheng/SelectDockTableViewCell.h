//
//  SelectDockTableViewCell.h
//  jsz
//
//  Created by 朱东勇 on 2018/6/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDockTableViewCell : UITableViewCell
@property (nonatomic) BOOL select;
@property (nonatomic, strong) NSMutableDictionary *data;

+ (SelectDockTableViewCell*)cell;

@end
