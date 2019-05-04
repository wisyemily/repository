//
//  TimeItem.m
//  jsz
//
//  Created by 朱东勇 on 2018/3/30.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "TimeItem.h"


@interface TimeItem ()
@property (nonatomic, strong) IBOutlet UIButton *timeBtn;

@end

@implementation TimeItem

+ (TimeItem*)item {
    return [[NSBundle mainBundle] loadNibNamed:@"TimeItem" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1;
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    self.timeBtn.selected = _selected;
    self.timeBtn.backgroundColor = _selected?[UIColor redColor]:[UIColor clearColor];
}

- (void)setString:(NSString *)string {
    _string = string;
    
    [self.timeBtn setTitle:_string forState:UIControlStateNormal];
}

#pragma mark - IBAction
- (IBAction)itemAction:(id)sender {
    self.selected = !self.selected;
    
    if (self.hander)
        self.hander(self);
}

@end
