//
//  MyView.h
//  jsz
//
//  Created by 朱东勇 on 2018/3/31.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView : UIView
@property (nonatomic, readonly) BOOL needBack;

+ (MyView*)view;

- (void)resetViews;

- (void)reloadDatas;

@end
