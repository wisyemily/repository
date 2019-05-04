//
//  MyKeChengView.h
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyKeChengView : UIView
@property (nonatomic, copy) void(^subViewHander) (BOOL needBack);
@property (nonatomic, readonly) BOOL needBack;

+ (MyKeChengView*)view;

- (void)resetViews;

- (void)reloadDatas;

- (void)back;

@end
