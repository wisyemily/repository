//
//  YuyueView.h
//  jsz
//
//  Created by 朱东勇 on 2018/3/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuyueView : UIView
@property (nonatomic, copy) void(^subViewHander) (BOOL needBack);
@property (nonatomic, readonly) BOOL needBack;

+ (YuyueView*)view;

- (void)resetViews;

- (void)reloadDatas;

- (void)back;

@end
