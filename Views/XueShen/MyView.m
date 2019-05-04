//
//  MyView.m
//  jsz
//
//  Created by 朱东勇 on 2018/3/31.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "MyView.h"
#import "MemberView.h"
#import "MyDetailView.h"
#import "CustomDetailView.h"
#import "FanKuiView.h"

#import "UIApplication+PresentedViewController.h"

@implementation MyView

+ (MyView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil].lastObject;
}

- (void)resetViews {
    
}

- (void)reloadDatas {
    
}

#pragma mark - IBAction
- (IBAction)logout:(id)sender {
    [[DataModel model] logout];
    
    MemberView *memberView = [MemberView memberView];
    if (!memberView.didLogin) {
        memberView.hander = ^(BOOL didLogin, NSDictionary *userInfo) {
            if (didLogin) {
                
            }
        };
        [memberView showInView:[UIApplication rootView] animated:NO];
    }
}

- (IBAction)detailAction:(id)sender {
    MyDetailView *view = [MyDetailView view];
    
    [view showInView:[UIApplication rootView] animated:YES];
}

- (IBAction)kcxzAction:(id)sender {
    CustomDetailView *view = [CustomDetailView view];
    view.title = @"课程介绍";
    view.name = @"course_node";
    [view showInView:[UIApplication rootView] animated:YES];
}

- (IBAction)xxjsAction:(id)sender {
    CustomDetailView *view = [CustomDetailView view];
    view.title = @"学校介绍";
    view.name = @"school_jieshao";
    [view showInView:[UIApplication rootView] animated:YES];
}

- (IBAction)xxlxfsAction:(id)sender {
    CustomDetailView *view = [CustomDetailView view];
    view.title = @"学校联系方式";
    view.name = @"school_phone";
    [view showInView:[UIApplication rootView] animated:YES];
}

- (IBAction)fanKuiAction:(id)sender {
    FanKuiView *view = [FanKuiView view];
    [view showInView:[UIApplication rootView] animated:YES];
}

- (IBAction)clearAction:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"清除缓存成功" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[UIApplication presentedViewController] presentViewController:controller animated:YES completion:nil];
}

@end
