//
//  DSKViewCell.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "YSKViewCell.h"
#import "NSDate+Extend.h"

@interface YSKViewCell ()
@property (nonatomic, strong) IBOutlet UIButton *enterBtn;
@property (nonatomic, strong) IBOutlet UIButton *removeBtn;

@property (nonatomic, strong) IBOutlet UILabel  *dateLbl;

@end

@implementation YSKViewCell

+ (YSKViewCell*)cell {
    return [[NSBundle mainBundle] loadNibNamed:@"YSKViewCell" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.enterBtn.clipsToBounds = YES;
    self.enterBtn.layer.backgroundColor = [UIColor redColor].CGColor;
    self.enterBtn.layer.cornerRadius = self.enterBtn.frame.size.height/2;
    
    self.removeBtn.clipsToBounds = YES;
    self.removeBtn.layer.backgroundColor = [UIColor redColor].CGColor;
    self.removeBtn.layer.cornerRadius = self.removeBtn.frame.size.height/2;
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(NSDictionary *)item {
    _item = item;
    
    [self.enterBtn setTitle:[NSString stringWithFormat:@"%@ %@",
                             _item[@"instrument_type_text"],
                             _item[@"type_text"]]
                   forState:UIControlStateNormal];
    
    int timeType = [_item[@"time_type"] intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formatter dateFromString:_item[@"start_time"]];
    NSDate *endDate = [formatter dateFromString:_item[@"end_time"]];
    self.dateLbl.text = [NSString stringWithFormat:@"%lu年%lu月%lu日   %02lu:%02lu ~ %02lu:%02d",
                         startDate.year,
                         startDate.month, startDate.day,
                         startDate.hour, startDate.minute,
                         endDate.hour,endDate.minute];
}

#pragma mark - IBAction
- (IBAction)enterAction:(id)sender {
    if (self.action)
        self.action(self, YSKActionTypeEnter);
}

- (IBAction)zjAction:(id)sender {
    if (self.action)
        self.action(self, YSKActionTypePL);
}

- (IBAction)removeAction:(id)sender {
    if (self.action)
        self.action(self, YSKActionTypePreview);
}

@end
