//
//  PinJiaView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/26.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "PinJiaView.h"
#import "DataModel.h"
#import "UIApplication+PresentedViewController.h"

@interface PinJiaView ()
@property (nonatomic, strong) IBOutlet UIImageView *teachPJIV;
@property (nonatomic, strong) IBOutlet UITextView *chiPJView;

@end

@implementation PinJiaView

+ (PinJiaView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"PinJiaView" owner:nil options:nil].lastObject;
}

- (void)showInView:(UIView*)view {
    self.frame = view.bounds;
    [view addSubview:self];
}

- (void)hidden {
    [self removeFromSuperview];
}

#pragma mark - Setter
- (void)setCauseID:(NSString *)causeID {
    _causeID = causeID;
    
    [[DataModel model] fetchPingJiaWithWithID:_causeID hander:^(NSDictionary *info, NSError *error) {
        if ([info[@"code"] integerValue] == 0) {
            if ([info[@"msg"] isEqualToString:@"该课程尚未评论"]) {
                UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    style = UIAlertControllerStyleAlert;
                
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"请给老师做评价" preferredStyle:style];
                [controller addAction:[UIAlertAction actionWithTitle:@"好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self commitPingJia:1];
                }]];
                [controller addAction:[UIAlertAction actionWithTitle:@"中评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self commitPingJia:2];
                }]];
                [controller addAction:[UIAlertAction actionWithTitle:@"差评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self commitPingJia:3];
                }]];
                [[UIApplication presentedViewController] presentViewController:controller animated:YES completion:nil];
            }else {
                [self alert:info[@"msg"]];
            }
        }else {
            NSArray *pjs = @[@"pingjia01", @"pingjia02", @"pingjia03"];
            
            self.teachPJIV.image = [UIImage imageNamed:pjs[[info[@"data"][@"teacher_pingjia"] integerValue] - 1]];
            self.chiPJView.text = [info[@"data"][@"stu_pingjia"] description];
            NSLog(@"%@", info);
        }
    }];
}

- (void)commitPingJia:(int)type {
    [[DataModel model] commitPingJiaWithParams:@{@"course_id":_causeID,
                                                 @"type":@"1",
                                                 @"content":@(type)
                                                 } hander:^(NSDictionary *info, NSError *error)
     {
         if (error || [info[@"code"] integerValue] == 0) {
             if (info[@"msg"])
                 [self alert:info[@"msg"]];
             else
                 [self alert:@"评论失败！"];
         }else {
             self.causeID = self.causeID;
         }
    }];
}

#pragma mark - IBAction
- (IBAction)backAction:(id)sender {
    [self hidden];
}

@end
