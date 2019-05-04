//
//  YYXYListViewCell.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "YYXYListViewCell.h"
#import "ImageCache.h"

@interface YYXYListViewCell ()
@property (nonatomic, strong) IBOutlet UIImageView *snapIV;
@property (nonatomic, strong) IBOutlet UILabel     *titleLbl;

@end

@implementation YYXYListViewCell

+ (YYXYListViewCell*)cell {
    return [[NSBundle mainBundle] loadNibNamed:@"YYXYListViewCell" owner:nil options:nil].lastObject;
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

- (void)setItem:(NSDictionary *)item {
    _item = item;
    
    self.titleLbl.text = _item[@"description"]?:_item[@"videoName"];
    
    __block NSString *imagePath = _item[@"snapshotUrl"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [ImageCache imageWithPath:imagePath];
        
        if (!image) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
            
            if (data)
                image = [UIImage imageWithData:data];
            if (image)
                [ImageCache writeImage:image withAppendName:imagePath];
        }
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.snapIV.image = image;
            });
        }
    });
}

@end
