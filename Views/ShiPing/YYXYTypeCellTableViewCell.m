//
//  YYXYTypeCellTableViewCell.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "YYXYTypeCellTableViewCell.h"
#import "ImageCache.h"

@interface YYXYTypeCellTableViewCell ()
@property (nonatomic, strong) IBOutlet UILabel  *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel  *descLbl;

@end

@implementation YYXYTypeCellTableViewCell

+ (YYXYTypeCellTableViewCell*)cell {
    return [[NSBundle mainBundle] loadNibNamed:@"YYXYTypeCellTableViewCell" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter
- (void)setItem:(NSDictionary *)item {
    _item = item;
    
    self.titleLbl.text = item[@"typeName"];
    self.descLbl.text = item[@"desc"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
