//
//  MyDetailView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/17.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "FanKuiView.h"
#import "DataModel.h"
#import "UIApplication+PresentedViewController.h"

@interface FanKuiView ()<UITextViewDelegate>
@property (nonatomic, strong) IBOutlet UITextView *tv;
@property (nonatomic, strong) IBOutlet UIButton *submitBtn;

@end


@implementation FanKuiView

+ (FanKuiView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"FanKuiView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
- (IBAction)backAction:(id)sender {
    [self hidden];
}

- (IBAction)submit:(id)sender {
    [self.tv resignFirstResponder];
    
    [[DataModel model] fankuiWithParams:@{@"user_id":[DataModel model].userInfo[@"id"]?:@"",
                                          @"content":self.tv.text?:@""
                                          }
                                 hander:^(NSDictionary *info, NSError *error)
    {
        if (error ||
            [info[@"code"] intValue] == 0) {
            [self alert:info[@"msg"]?:@"提交反馈失败！"];
        }else {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"感谢您的反馈!" preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self hidden];
            }]];
            [[UIApplication presentedViewController] presentViewController:controller animated:YES completion:nil];

        }
    }];
}

#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.tv resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    NSString *string = textView.text;
    string = [string stringByReplacingCharactersInRange:range withString:text];
    
    self.submitBtn.enabled = string.length;
    
    return YES;
}


@end
