//
//  YYXYView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "YYXYView.h"
#import "ImageCache.h"
#import "YYXYTypeCellTableViewCell.h"
#import "DataModel.h"

#import "YYXYListView.h"

#import <AVKit/AVKit.h>
#import "UIApplication+PresentedViewController.h"

@interface YYXYView ()<
AVPlayerViewControllerDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) YYXYListView *detailView;

@end

@implementation YYXYView

+ (YYXYView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"YYXYView" owner:nil options:nil].lastObject;
}

- (void)resetViews {
    [self.detailView removeFromSuperview];
    self.detailView = nil;
}

- (void)reloadDatas {
    [[DataModel model] fetchVideoTypesWithHander:^(NSDictionary *info, NSError *error) {
        if (error) {
            [self alert:@"获取视频类型失败！"];
        }else {
            self.items = info[@"data"];
            [self.listView reloadData];
        }
    }];
}

- (void)back {
    [self resetViews];
}

#pragma mark - Getter
- (BOOL)needBack {
    return self.detailView != nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYXYTypeCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYXYTypeCellTableViewCell"];
    if (!cell)
        cell = [YYXYTypeCellTableViewCell cell];
    
    cell.item = self.items[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __block YYXYView *weak_self = self;
    
    self.detailView = [YYXYListView view];
    self.detailView.frame = self.bounds;
    self.detailView.item = self.items[indexPath.row];
    self.detailView.action = ^(YYXYListView *view, NSDictionary *videoInfo) {
        [[DataModel model] playVideoWithParams:@{@"vid":videoInfo[@"vid"]?:@"",
                                                 @"user_id":[DataModel model].userInfo[@"id"]?:@"",
                                                 @"videoName":videoInfo[@"videoName"]?:@"",
                                                 @"description":videoInfo[@"description"]?:@"",
                                                 @"typeName":videoInfo[@"typeName"]?:@"",
                                                 @"origUrl":videoInfo[@"origUrl"]?:@"",
                                                 @"snapshotUrl_image":videoInfo[@"snapshotUrl"]?:@"",
                                                 }
                                        hander:^(NSDictionary *info, NSError *error)
        {
            if (error) {
                if (info[@"msg"])
                    [weak_self alert:info[@"msg"]];
                else
                    [weak_self alert:@"播放失败"];
            }else {
                NSString *videoString = nil;
                
                videoString = videoInfo[@"hdMp4Url"];
                if (videoString.length == 0)
                    videoString = videoInfo[@"origUrl"];
                
                AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:videoString]];
                AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
                controller.player = player;
                controller.delegate = weak_self;
                
                [[UIApplication presentedViewController] presentViewController:controller
                                                                      animated:YES
                                                                    completion:nil];
            }
        }];
    };
    [self addSubview:self.detailView];
    
    if (self.subViewHander)
        self.subViewHander(YES);
}

@end
