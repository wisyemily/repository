//
//  DayItem.m
//  jsz
//
//  Created by 朱东勇 on 2018/3/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "DayItem.h"
#import "NSDate+Extend.h"

@interface DayItem ()
@property (nonatomic, strong) IBOutlet UILabel  *weakLbl;
@property (nonatomic, strong) IBOutlet UILabel  *dayLbl;

@end

@implementation DayItem

+ (DayItem*)item {
    return [[NSBundle mainBundle] loadNibNamed:@"DayItem" owner:nil options:nil].lastObject;
}

#pragma mark - Setter
- (void)setDate:(NSDate *)date {
    _date = date;
    
    if ([NSDate date].month == _date.month &&
        [NSDate date].day == _date.day)
        self.weakLbl.text = @"今天";
    else
        self.weakLbl.text = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四",
                              @"星期五", @"星期六"][date.weekday - 1];
    
    self.dayLbl.text = [NSString stringWithFormat:@"%02lu.%02lu", _date.month, _date.day];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    self.weakLbl.textColor = _selected?[UIColor whiteColor]:[UIColor darkGrayColor];
    self.dayLbl.textColor = _selected?[UIColor whiteColor]:[UIColor darkGrayColor];
    
    self.backgroundColor = _selected?[UIColor redColor]:[UIColor whiteColor];
}

#pragma mark - IBAction
- (IBAction)itemAction:(id)sender {
    if (self.hander)
        self.hander(self);
}

@end
