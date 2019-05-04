//
//  DSKViewCell.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "KJViewCell.h"
#import "NSDate+Extend.h"

@interface KJViewCell ()
@property (nonatomic, strong) IBOutlet UIImageView *headIV;
@property (nonatomic, strong) IBOutlet UILabel  *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel  *descLbl;

@property (nonatomic, strong) IBOutlet UIButton *enterBtn;
@property (nonatomic, strong) IBOutlet UILabel  *timeLbl;

@end

@implementation KJViewCell

+ (KJViewCell*)cell {
    return [[NSBundle mainBundle] loadNibNamed:@"KJViewCell" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.enterBtn.clipsToBounds = YES;
//    self.enterBtn.layer.backgroundColor = [UIColor redColor].CGColor;
//    self.enterBtn.layer.cornerRadius = self.enterBtn.frame.size.height/2;
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(NSDictionary *)item {
    _item = item;
    
//    {
//        createtime = 1523462923;
//        "doc_type" = 1;
//        "doc_type_text" = "Doc_Type 1";
//        id = 75;
//        name = "3ye.pptx";
//        "nim_doc_id" = "8ac2e480-e557-43f2-b252-cc811b1c9323";
//        "nim_doc_pic_image" = "";
//        type = 2;
//        "type_text" = "Type 2";
//        "user_id" = 13;
//        "user_text" = 15973122497;
//    }
    self.titleLbl.text = [_item[@"name"] description];
    self.descLbl.text = [_item[@"user_text"] description];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_item[@"createtime"] longLongValue]];
    self.timeLbl.text = [NSString stringWithFormat:@"%02d-%02d", date.month, date.day];
}

#pragma mark - IBAction
- (IBAction)enterAction:(id)sender {
    if (self.action)
        self.action(self, KJActionTypeEnter);
}

- (IBAction)deleteAction:(id)sender {
    if (self.action)
        self.action(self, KJActionTypereDelete);
}

@end
