//
//  SelectDockTableViewCell.m
//  jsz
//
//  Created by 朱东勇 on 2018/6/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "SelectDockTableViewCell.h"
#import "DocumentPreVC.h"
#import "UIApplication+PresentedViewController.h"

@interface SelectDockTableViewCell ()
@property (nonatomic, strong) IBOutlet UILabel  *titleLbl;
@property (nonatomic, strong) IBOutlet UIButton     *selectBtn;

@end

@implementation SelectDockTableViewCell

+ (SelectDockTableViewCell*)cell {
    return [[NSBundle mainBundle] loadNibNamed:@"SelectDockTableViewCell" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSMutableDictionary *)data {
    _data = data;
    
    self.titleLbl.text = _data[@"name"];
    
    self.select = [[_data valueForKey:@"select"] boolValue];
}


- (void)setSelect:(BOOL)select {
    _select = select;
    
    [_data setValue:@(_select) forKey:@"select"];
    self.selectBtn.selected = _select;
}

#pragma mark - IBAction
- (IBAction)selectAction:(id)sender {
    self.select = !self.select;
}

- (IBAction)showAction:(id)sender {
    DocumentPreVC *vc = [DocumentPreVC vc];
    vc.documentID = self.data[@"nim_doc_id"];
    [[UIApplication presentedViewController] presentViewController:vc animated:YES completion:nil];
}

@end
