//
//  MyDetailView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/17.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "MyDetailView.h"
#import "DataModel.h"
#import "MemberView.h"
#import "ForgetPasswordView.h"
#import "CustomDetailView.h"

@interface MyDetailView ()
@property (nonatomic, strong) IBOutlet UILabel  *accountLbl;
@property (nonatomic, strong) IBOutlet UILabel  *nicknameLbl;
@property (nonatomic, strong) IBOutlet UILabel  *ksLbl;
@property (nonatomic, strong) IBOutlet UILabel  *jfLbl;

@property (nonatomic, strong) IBOutlet UIButton  *czBtn;
@property (nonatomic, strong) IBOutlet UIButton  *zxBtn;

@end


@implementation MyDetailView

+ (MyDetailView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"MyDetailView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[DataModel model] fetchUserInfoWithHander:^(NSDictionary *info, NSError *error) {
        self.accountLbl.text = [[DataModel model].userInfo[@"username"]?:@"" description];
        self.nicknameLbl.text = [[DataModel model].userInfo[@"nickname"]?:@"" description];
        self.ksLbl.text = [[DataModel model].userInfo[@"course"]?:@"" description];
        self.jfLbl.text = [[DataModel model].userInfo[@"score"]?:@"" description];
    }];
}

- (void)showInView:(UIView*)view animated:(BOOL)animated {
    [view addSubview:self];
    
    self.frame = CGRectMake(view.frame.size.width,
                            0,
                            view.frame.size.width,
                            view.frame.size.height);
    [UIView animateWithDuration:animated?0.3:0 animations:^{
        self.frame = view.bounds;
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.size.width,
                                0,
                                self.frame.size.width,
                                self.frame.size.height);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - IBAction
- (IBAction)czAction:(id)sender {
    ForgetPasswordView *view = [ForgetPasswordView view];
    
    [self removeFromSuperview];
    [view showInView:[UIApplication rootView]];
}

- (IBAction)zxAction:(id)sender {
    [[DataModel model] logout];
    
    [self removeFromSuperview];
    [MemberView loginWithHander:^(BOOL didLogin, NSDictionary *userInfo) {
        
    }];
}

- (IBAction)backAction:(id)sender {
    [self hidden];
}

@end
