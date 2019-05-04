//
//  MyDetailView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/17.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "CustomDetailView.h"
#import "DataModel.h"

@interface CustomDetailView ()
@property (nonatomic, strong) IBOutlet UILabel  *titleLbl;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end


@implementation CustomDetailView

+ (CustomDetailView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"CustomDetailView" owner:nil options:nil].lastObject;
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

#pragma mark - Setter
- (void)setName:(NSString *)name {
    _name = name;
    
    [[DataModel model] fetchConfigWithName:_name hander:^(NSDictionary *info, NSError *error) {
        if (error ||
            [info[@"code"] integerValue] == 0) {
            [self alert:info[@"msg"]];
        }else {
            [self.webView loadHTMLString:info[@"data"]
                                 baseURL:[NSURL URLWithString:@"http://47.104.92.211"]];
        }
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLbl.text = _title;
}

#pragma mark - IBAction
- (IBAction)backAction:(id)sender {
    [self hidden];
}

@end
