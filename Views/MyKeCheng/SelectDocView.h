//
//  SelectDocView.h
//  jsz
//
//  Created by 朱东勇 on 2018/6/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopView.h"

@interface SelectDocView : PopView
@property (nonatomic, strong) NSDictionary *data;

+ (SelectDocView*)view;

@end
