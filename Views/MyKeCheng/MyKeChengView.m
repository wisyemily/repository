//
//  MyKeChengView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "MyKeChengView.h"

#import "DSKView.h"
#import "YSKView.h"
#import "KJView.h"



@interface MyKeChengView ()
@property (nonatomic, strong) IBOutlet UIView *menuView;
@property (nonatomic, strong) IBOutlet UIButton *menuItem01;
@property (nonatomic, strong) IBOutlet UIButton *menuItem02;
@property (nonatomic, strong) IBOutlet UIButton *menuItem03;
@property (nonatomic, strong) IBOutlet UIView *markView;
@property (nonatomic) NSUInteger type;

@property (nonatomic, strong) DSKView *view01;
@property (nonatomic, strong) YSKView *view02;
@property (nonatomic, strong) KJView *view03;

@property (nonatomic, strong) IBOutlet UIView *contentView;

@end

@implementation MyKeChengView

+ (MyKeChengView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"MyKeChengView" owner:nil options:nil].lastObject;
}

- (void)resetViews {
    
}

- (void)reloadDatas {
    self.type = 0;
}

- (void)back {
    
}

#pragma mark - Setter
- (BOOL)needBack {
    return NO;
}

- (void)setType:(NSUInteger)type {
    _type = type;
    
    for (int index = 0; index < 3; index++) {
        UIButton *button = @[self.menuItem01, self.menuItem02, self.menuItem03][index];
        
        button.selected = (_type == index);
    }
    
    UIButton *button = @[self.menuItem01, self.menuItem02, self.menuItem03][_type];
    self.markView.center = CGPointMake(button.center.x,
                                       self.markView.center.y);
    
    switch (_type) {
        case 0: {
            if (!self.view01) {
                self.view01 = [DSKView view];
                self.view01.frame = self.contentView.bounds;
                
                [self.contentView addSubview:self.view01];
            }
            
            [self.view01 reloadViews];
            break;
        }
        case 1: {
            if (!self.view02) {
                self.view02 = [YSKView view];
                self.view02.frame = self.contentView.bounds;
                
                [self.contentView addSubview:self.view02];
            }
            
            [self.view02 reloadViews];
            break;
        }
        case 2: {
            if (!self.view03) {
                self.view03 = [KJView view];
                self.view03.frame = self.contentView.bounds;
                
                [self.contentView addSubview:self.view03];
            }
            
            [self.view03 reloadViews];
            break;
        }
            
        default:
            break;
    }
    
    self.view01.hidden = _type != 0;
    self.view02.hidden = _type != 1;
    self.view03.hidden = _type != 2;
}

#pragma mark - IBAction
- (IBAction)itemAction:(id)sender {
    self.type = [@[self.menuItem01, self.menuItem02, self.menuItem03] indexOfObject:sender];
}

@end
