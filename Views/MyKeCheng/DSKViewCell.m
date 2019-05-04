//
//  DSKViewCell.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "DSKViewCell.h"
#import "NSDate+Extend.h"

@interface DSKViewCell ()
@property (nonatomic, strong) IBOutlet UIButton *enterBtn;
@property (nonatomic, strong) IBOutlet UIButton *removeBtn;
@property (nonatomic, strong) IBOutlet UIButton *selectBtn;

@property (nonatomic, strong) IBOutlet UILabel  *dateLbl;

@end

@implementation DSKViewCell

+ (DSKViewCell*)cell {
    return [[NSBundle mainBundle] loadNibNamed:@"DSKViewCell" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.enterBtn.clipsToBounds = YES;
    self.enterBtn.layer.backgroundColor = [UIColor redColor].CGColor;
    self.enterBtn.layer.cornerRadius = self.enterBtn.frame.size.height/2;
    
    self.removeBtn.clipsToBounds = YES;
    self.removeBtn.layer.backgroundColor = [UIColor redColor].CGColor;
    self.removeBtn.layer.cornerRadius = self.removeBtn.frame.size.height/2;
    
    self.selectBtn.clipsToBounds = YES;
    self.selectBtn.layer.backgroundColor = [UIColor redColor].CGColor;
    self.selectBtn.layer.cornerRadius = self.selectBtn.frame.size.height/2;
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(NSDictionary *)item {
    _item = item;
    
    [self.enterBtn setTitle:[NSString stringWithFormat:@"%@ %@ | %@",
                             _item[@"instrument_type_text"],
                             _item[@"type_text"],
                             _item[@"teacher_text"]]
                   forState:UIControlStateNormal];
    
    int timeType = [_item[@"time_type"] intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formatter dateFromString:_item[@"start_time"]];
    NSDate *endDate = [formatter dateFromString:_item[@"end_time"]];
    self.dateLbl.text = [NSString stringWithFormat:@"%lu月%lu日   %02lu:%02lu ~ %02lu:%02d",
                         startDate.month, startDate.day,
                         startDate.hour, startDate.minute,
                         endDate.hour,endDate.minute];
}

#pragma mark - IBAction
- (IBAction)enterAction:(id)sender {
    if (self.action)
        self.action(self, DSKActionTypeEnter);
}

- (IBAction)removeAction:(id)sender {
    if (self.action)
        self.action(self, DSKActionTypeRemove);
}

- (IBAction)selectDoc:(id)sender {
    if (self.action)
        self.action(self, DSKActionTypeSelectDoc);
}

@end
