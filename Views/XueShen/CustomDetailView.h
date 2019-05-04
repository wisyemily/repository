//
//  MyDetailView.h
//  jsz
//
//  Created by 朱东勇 on 2018/4/17.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDetailView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;

+ (CustomDetailView*)view;

- (void)showInView:(UIView*)view animated:(BOOL)animated;

- (void)hidden;

@end
