//
//  YuyueView.m
//  jsz
//
//  Created by 朱东勇 on 2018/3/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "YuyueView.h"

#import "YuekeView.h"

@interface YuyueView ()
@property (nonatomic, strong) YuekeView *view;

@property (nonatomic, strong) IBOutlet UIButton *item01Btn;
@property (nonatomic, strong) IBOutlet UIButton *item02Btn;

@end

@implementation YuyueView

+ (YuyueView*)view {
    static YuyueView *__yuyueView = nil;
    if (!__yuyueView)
        __yuyueView = [[NSBundle mainBundle] loadNibNamed:@"YuyueView" owner:nil options:nil].lastObject;
    
    return __yuyueView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self reloadDatas];
}

#pragma mark -
- (void)resetViews {
    [self.view removeFromSuperview];
    self.view = nil;
}

- (void)reloadDatas {
    
}

- (void)back {
    [self resetViews];
}

#pragma mark - Getter
- (BOOL)needBack {
    return self.view != nil;
}

#pragma mark - IBAction
- (IBAction)yuyueAction:(id)sender {
    YuekeView *view = [YuekeView view];
    view.type = [@[self.item01Btn, self.item02Btn] indexOfObject:sender];
    
    view.frame = self.bounds;
    self.view = view;
    [self addSubview:self.view];
    
    if (self.subViewHander)
        self.subViewHander(YES);
}

@end
