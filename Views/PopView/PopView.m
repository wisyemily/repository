//
//  PopView.m
//  DuoYiShan
//
//  Created by zhudongyong on 14/12/8.
//  Copyright (c) 2014年 innovator. All rights reserved.
//

#import "PopView.h"

@interface PopView ()
@property (nonatomic, readwrite) PopViewDirect   direction;

@end

@implementation PopView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(hidden)
//                                                     name:kOpenTagNotification
//                                                   object:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(hidden)
//                                                     name:kOpenTagNotification
//                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
- (void)showInView:(UIView*)view {
    [self showInView:view direction:PopViewDirectRight];
}

- (void)showInView:(UIView *)view direction:(PopViewDirect)direction {
    _direction = direction;
    
    if (view && !self.isShow) {
        self.frame = view.bounds;
        [view addSubview:self];
        
        switch (_direction) {
            case PopViewDirectLeft: {
                self.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                break;
            }
            case PopViewDirectDown: {
                self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                break;
            }
            case PopViewDirectUp: {
                self.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
                break;
            }
            case PopViewDirectRight:
            default: {
                self.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                break;
            }
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }];
    }
}

- (void)hidden {
    [self hiddenToDirect:self.direction];
}

- (void)hiddenToDirect:(PopViewDirect)direction {
    self.direction = direction;
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        switch (direction) {
            case PopViewDirectLeft: {
                self.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                break;
            }
            case PopViewDirectDown: {
                self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                break;
            }
            case PopViewDirectUp: {
                self.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
                break;
            }
            case PopViewDirectRight:
            default: {
                self.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                break;
            }
        }
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Setter
- (BOOL)isShow {
    return self.superview != nil;
}

#pragma mark -
- (IBAction)backAction:(id)sender {
    [self hidden];
}

@end
