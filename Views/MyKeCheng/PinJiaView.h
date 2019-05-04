//
//  PinJiaView.h
//  jsz
//
//  Created by 朱东勇 on 2018/4/26.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinJiaView : UIView
@property (nonatomic, copy) NSString *causeID;

+ (PinJiaView*)view;

- (void)showInView:(UIView*)view;
- (void)hidden;

@end
