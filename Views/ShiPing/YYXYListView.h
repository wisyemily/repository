//
//  YYXYListView.h
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYXYListView;
typedef void(^ListViewPlayAction) (YYXYListView *view, NSDictionary *videoItem);
@interface YYXYListView : UIView
@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, copy) ListViewPlayAction action;

+ (YYXYListView*)view;

@end
