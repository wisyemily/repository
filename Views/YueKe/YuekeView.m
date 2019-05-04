//
//  YuekeView.m
//  jsz
//
//  Created by 朱东勇 on 2018/3/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "YuekeView.h"
#import "DayItem.h"
#import "TimeItem.h"

#import "DataModel.h"

#import "NSDate+Extend.h"

@interface YuekeView ()
@property (nonatomic, strong) IBOutlet UIView *dayContentView;
@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic) NSUInteger dayIndex;

@property (nonatomic, strong) IBOutlet UILabel  *yu_e_peilianLbl;
@property (nonatomic, strong) IBOutlet UILabel  *yu_e_jiaoxueLbl;

@property (nonatomic, strong) IBOutlet UIButton  *timeItem01;
@property (nonatomic, strong) IBOutlet UIButton  *timeItem02;
@property (nonatomic) NSUInteger timeType;

@property (nonatomic, strong) IBOutlet UIImageView *markIV;

@property (nonatomic, strong) IBOutlet UIView   *timeContentView;
@property (nonatomic, strong) IBOutlet UIView   *timeCV;
@property (nonatomic, strong) NSMutableArray *times;
//@property (nonatomic) NSUInteger timeIndex;

@end

@implementation YuekeView

- (void)layoutSubviews {
    for (int index = 0; index < self.days.count; index++) {
        DayItem *item = self.days[index];
        float width = MIN(self.dayContentView.frame.size.width/7, 60);
        item.frame = CGRectMake(index * width, 0,
                                width, self.dayContentView.frame.size.height);
    }
    
    NSInteger countPerRow = _timeType == 0?4:3;
    float width = MIN(self.timeCV.frame.size.width/countPerRow - 5, 100);
    NSUInteger pageForRow = self.timeCV.frame.size.width / width;
    float offset = (self.timeCV.frame.size.width - width * pageForRow)/pageForRow;
    for (int index = 0; index < self.times.count; index++) {
        TimeItem *item = self.times[index];
        
        item.frame = CGRectMake((index%pageForRow) * (width+offset) + offset/2,
                                (index/pageForRow) * 35 + offset/2,
                                width,
                                30);
    }
}

+ (YuekeView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"YuekeView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self updateKS];
    
    self.timeContentView.layer.cornerRadius = 5;
    
    self.timeItem01.clipsToBounds = YES;
    self.timeItem01.layer.borderColor = [UIColor redColor].CGColor;
    self.timeItem01.layer.borderWidth = 1;
    self.timeItem01.layer.cornerRadius = 5;
    self.timeItem02.clipsToBounds = YES;
    self.timeItem02.layer.borderColor = [UIColor redColor].CGColor;
    self.timeItem02.layer.borderWidth = 1;
    self.timeItem02.layer.cornerRadius = 5;
    
    
    self.days = [NSMutableArray array];
    for (int index = 0; index < 7; index++) {
        DayItem *item = [DayItem item];
        float width = MIN(self.dayContentView.frame.size.width/7, 60);
        item.frame = CGRectMake(index * width, 0,
                                width, self.dayContentView.frame.size.height);
        item.date = [NSDate dateWithTimeIntervalSinceNow:index * 24 * 3600];
        item.selected = NO;
        item.hander = ^(DayItem *rItem) {
            self.dayIndex = [self.days indexOfObject:rItem];
        };
        [self.days addObject:item];
        [self.dayContentView addSubview:item];
    }
    self.dayIndex = 0;
    
    self.timeType = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self layoutSubviews];
    });
}

- (void)setDayIndex:(NSUInteger)dayIndex {
    _dayIndex = dayIndex;
    
    for (int index = 0; index < 7; index++) {
        DayItem *item = self.days[index];
        
        item.selected = _dayIndex == index;
    }
}

- (void)setTimeType:(NSUInteger)timeType {
    _timeType = timeType;
    
    for (int index = 0; index < 2; index++) {
        UIButton *btn = @[self.timeItem01, self.timeItem02][index];
        
        btn.backgroundColor = (_timeType == index)?[UIColor redColor]:[UIColor clearColor];
        btn.selected = _timeType == index;
    }
    
    NSUInteger count = _timeType == 0?27:14;
    
    NSInteger countPerRow = _timeType == 0?4:3;
    float width = MIN(self.timeCV.frame.size.width/countPerRow - 5, 100);
    NSUInteger pageForRow = self.timeCV.frame.size.width / width;
    float offset = (self.timeCV.frame.size.width - width * pageForRow)/pageForRow;
    if (!self.times)
        self.times = [NSMutableArray array];
    while (count != self.times.count) {
        if (count > self.times.count) {
            TimeItem *item = [TimeItem item];
            
            item.frame = CGRectMake(0,
                                    0,
                                    width,
                                    30);
            item.selected = NO;
            item.hander = ^(TimeItem *rItem) {
                for (TimeItem *tItem in self.times) {
                    tItem.selected = (tItem == rItem);
                }
            };
            [self.times addObject:item];
            [self.timeCV addSubview:item];
        }else {
            [self.times.lastObject removeFromSuperview];
            [self.times removeLastObject];
        }
    }
    
    for (int index = 0; index < self.times.count; index++) {
        TimeItem *item = self.times[index];
        item.frame = CGRectMake((index%pageForRow) * (width+offset),
                                (index/pageForRow) * 35 + offset/2,
                                width,
                                30);
        
        if (index == self.times.count - 1) {
            item.string = @"其它时间";
        }else {
            if (_timeType == 0) {
                int hour = 9 + index/2;
                if (index %2 == 1) {
                    item.string = [NSString stringWithFormat:@"%02d:30~%02d:55",
                                   hour, hour];
                }else {
                    item.string = [NSString stringWithFormat:@"%02d:00~%02d:25",
                                   hour, hour];
                }
            }else {
                item.string = [NSString stringWithFormat:@"%02d:00~%02d:50",
                               9 + index, 9+index];
            }
        }
    }
}

#pragma mark -
- (void)updateKS {
    [[DataModel model] fetchUserInfoWithHander:^(NSDictionary *info, NSError *error) {
        self.yu_e_jiaoxueLbl.text = [NSString stringWithFormat:@"教学余额：%@",
                                     [[DataModel model].userInfo[@"course"]?:@"0" description]];
        self.yu_e_peilianLbl.text = [NSString stringWithFormat:@"陪练余额：%@",
                                     [[DataModel model].userInfo[@"score"]?:@"0" description]];

    }];
}

//- (void)setTimeIndex:(NSUInteger)timeIndex {
//    _timeIndex = timeIndex;
//
//    for (int index = 0; index < self.times.count; index++) {
//        TimeItem *item = self.times[index];
//
//        item.selected = _timeIndex == index;
//    }
//}

#pragma mark - IBAction
- (IBAction)timeAction:(id)sender {
    self.timeType = [@[self.timeItem01, self.timeItem02] indexOfObject:sender];
}

- (IBAction)peilianAction:(id)sender {
    [self yuyueForType:0];
}

- (IBAction)yuyueAction:(id)sender {
    [self yuyueForType:1];
}

#pragma mark - Send Data
- (void)yuyueForType:(NSUInteger)indexType {
    NSString *lbl = @"";
    for (int index = 0; index < self.times.count; index++) {
        TimeItem *item = self.times[index];
        if (item.selected) {
            if (lbl.length == 0)
                lbl = [lbl stringByAppendingFormat:@"%d", index];
            else
                lbl = [lbl stringByAppendingFormat:@",%d", index];
        }
    }
    NSDate *date = [self.days[self.dayIndex] date];
    [[DataModel model] yuyueWithParams:@{
                                         @"instrument_type":@(self.type+1),
                                         @"lable":lbl,
                                         @"time_type":@(self.timeType),
                                         @"type":@(indexType),
                                         @"yueke_date":[NSString stringWithFormat:@"%04lu-%02lu-%02lu", date.year, date.month, date.day],
                                         @"account_id":[DataModel model].userInfo[@"id"]?:@""
                                         } hander:^(NSDictionary *info, NSError *error)
    {
        if (info[@"msg"]) {
            [self alert:info[@"msg"]];
        }else {
            if (error) {
                [self alert:@"约课失败！"];
            }else {
                [self alert:@"约课成功！"];
            }
        }
        [self updateKS];
    }];
}

@end
