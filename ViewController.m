//
//  ViewController.m
//  jsz
//
//  Created by 朱东勇 on 2018/3/27.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "ViewController.h"

#import "MemberView.h"

#import "MyKeChengView.h"
#import "YuyueView.h"
#import "YYXYView.h"
#import "MyView.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UIView *logoView;
@property (nonatomic, strong) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) IBOutlet UIButton *backBtn;

@property (nonatomic, strong) IBOutlet UIView *contentView;

@property (nonatomic, strong) IBOutlet UIButton     *menuItem01;
@property (nonatomic, strong) IBOutlet UIButton     *menuItem02;
@property (nonatomic, strong) IBOutlet UIButton     *menuItem03;
@property (nonatomic, strong) IBOutlet UIButton     *menuItem04;

@property (nonatomic, strong) MyKeChengView *item01;
@property (nonatomic, strong) YuyueView *item02;
@property (nonatomic, strong) YYXYView *item03;
@property (nonatomic, strong) MyView *item04;

@property (nonatomic) NSUInteger indexOfSelected;

@end

@implementation ViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MemberView *memberView = [MemberView memberView];
    if (!memberView.didLogin) {
        memberView.hander = ^(BOOL didLogin, NSDictionary *userInfo) {
            if (didLogin) {
                self.indexOfSelected = 0;
            }
        };
        [memberView showInView:self.view animated:NO];
    }else {
        self.indexOfSelected = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter & Getter
- (void)setIndexOfSelected:(NSUInteger)indexOfSelected {
    _indexOfSelected = indexOfSelected;
    
    self.titleLbl.text = @[@"我的课程",
                           @"约课中心",
                           @"视频学习",
                           @"学生中心"][_indexOfSelected];
    
    for (int index = 0; index < [self menuItems].count; index++) {
        UIButton *menuItem = [self menuItems][index];
        
        menuItem.selected = (_indexOfSelected == index);
    }
    
    [self.item01 resetViews];
    [self.item02 resetViews];
    [self.item03 resetViews];
    [self.item04 resetViews];
    
    self.backBtn.hidden = YES;
    self.titleLbl.hidden = self.backBtn.hidden;
    self.logoView.hidden = !self.backBtn.hidden;
    
    __block ViewController *weak_self = self;
    switch (_indexOfSelected) {
        case 0: {
            if (!self.item01) {
                self.item01 = [MyKeChengView view];
                self.item01.frame = self.contentView.bounds;
                self.item01.subViewHander = ^(BOOL needBack) {
                    weak_self.backBtn.hidden = !needBack;
                    weak_self.titleLbl.hidden = weak_self.backBtn.hidden;
                    weak_self.logoView.hidden = !weak_self.backBtn.hidden;
                };
                
                [self.contentView addSubview:self.item01];
            }
            [self.item01 reloadDatas];
            
            break;
        }
        case 1: {
            if (!self.item02) {
                self.item02 = [YuyueView view];
                self.item02.frame = self.contentView.bounds;
                self.item02.subViewHander = ^(BOOL needBack) {
                    weak_self.backBtn.hidden = !needBack;
                    weak_self.titleLbl.hidden = weak_self.backBtn.hidden;
                    weak_self.logoView.hidden = !weak_self.backBtn.hidden;
                };
                
                [self.contentView addSubview:self.item02];
            }
            
            [self.item02 reloadDatas];
            
            break;
        }
        case 2: {
            if (!self.item03) {
                self.item03 = [YYXYView view];
                self.item03.frame = self.contentView.bounds;
                self.item03.subViewHander = ^(BOOL needBack) {
                    weak_self.backBtn.hidden = !needBack;
                    weak_self.titleLbl.hidden = weak_self.backBtn.hidden;
                    weak_self.logoView.hidden = !weak_self.backBtn.hidden;
                };
                
                [self.contentView addSubview:self.item03];
            }
            
            [self.item03 reloadDatas];
            break;
        }
        case 3: {
            if (!self.item04) {
                self.item04 = [MyView view];
                self.item04.frame = self.contentView.bounds;
                
                [self.contentView addSubview:self.item04];
            }
            
            [self.item04 reloadDatas];
            break;
        }
            
        default:
            break;
    }
    
    self.item01.hidden = _indexOfSelected != 0;
    self.item02.hidden = _indexOfSelected != 1;
    self.item03.hidden = _indexOfSelected != 2;
    self.item04.hidden = _indexOfSelected != 3;
}

- (NSArray*)menuItems {
    return @[self.menuItem01, self.menuItem02,
             self.menuItem03, self.menuItem04];
}

#pragma mark - IBAction
- (IBAction)itemAction:(id)sender {
    self.indexOfSelected = [[self menuItems] indexOfObject:sender];
}

- (IBAction)backAction:(id)sender {
    switch (_indexOfSelected) {
        case 0: {
            [self.item01 back];
            self.backBtn.hidden = !self.item01.needBack;
            self.titleLbl.hidden = self.backBtn.hidden;
            self.logoView.hidden = !self.backBtn.hidden;
            break;
        }
        case 1: {
            [self.item02 back];
            self.backBtn.hidden = !self.item02.needBack;
            self.titleLbl.hidden = self.backBtn.hidden;
            self.logoView.hidden = !self.backBtn.hidden;
            break;
        }
        case 2: {
            [self.item03 back];
            self.backBtn.hidden = !self.item03.needBack;
            self.titleLbl.hidden = self.backBtn.hidden;
            self.logoView.hidden = !self.backBtn.hidden;
            break;
        }
        case 3: {
            break;
        }
            
        default:
            break;
    }
}

@end
