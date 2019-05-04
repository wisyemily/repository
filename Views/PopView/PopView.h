//
//  PopView.h
//  DuoYiShan
//
//  Created by zhudongyong on 14/12/8.
//  Copyright (c) 2014年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIApplication+PresentedViewController.h"

typedef NS_ENUM(NSUInteger, PopViewDirect) {
    PopViewDirectDown,
    PopViewDirectUp,
    PopViewDirectLeft,
    PopViewDirectRight
};

@interface PopView : UIView
@property (nonatomic, readonly) BOOL            isShow;
@property (nonatomic, readonly) PopViewDirect   direction;

- (void)showInView:(UIView*)view;//Default is Right
- (void)showInView:(UIView *)view direction:(PopViewDirect)direction;

- (void)hidden;
- (void)hiddenToDirect:(PopViewDirect)direct;

@end
