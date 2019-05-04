//
//  DSKView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "YSKView.h"
#import "DataModel.h"
#import "MJRefresh.h"

#import "YSKViewCell.h"
#import <AVKit/AVKit.h>
#import "UIApplication+PresentedViewController.h"
#import "PinJiaView.h"

@interface YSKView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic) NSUInteger page;

@end

@implementation YSKView

+ (YSKView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"YSKView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    __block YSKView *weak_self = self;
    
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.listView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weak_self.page = 0;
    };
    
    self.footer = [MJRefreshFooterView footer];
    self.footer.scrollView = self.listView;
    self.footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weak_self.page += 1;
    };
    
    [self.header endRefreshing];
    [self.footer endRefreshing];
}

- (void)reloadViews {
    self.page = 0;
}

#pragma mark - Setter
- (void)setPage:(NSUInteger)page {
    [[DataModel model] fetchYuyueWithParams:@{@"account_id":[DataModel model].userInfo[@"id"]?:@"",
                                              @"status":@(3),
                                              @"offset":@(page * 10),
                                              @"limit":@(10),
                                              @"sort":@"start_time",
                                              @"order":@"desc"
                                              }
                                     hander:^(NSDictionary *info, NSError *error)
    {
        if (error) {
            if (info[@"msg"])
                [self alert:info[@"msg"]];
            else
                [self alert:@"加载列表数据失败!"];
            
            if (page == 0)
                self.items = @[];
            [self.listView reloadData];
        }else {
            if (page == 0) {
                self.items = info[@"data"];
            }else {
                NSMutableArray *items = [self.items mutableCopy];
                if ([info[@"data"] count])
                    [items addObjectsFromArray:info[@"data"]];
                
                self.items = items;
            }
            
            _page = page;
            [self.listView reloadData];
        }
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
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
    YSKViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSKViewCell"];
    if (!cell) {
        cell = [YSKViewCell cell];
        cell.action = ^(YSKViewCell *cell, YSKActionType type) {
            if (type == YSKActionTypePreview ||
                type == YSKActionTypeEnter) {
                //播放视频
                if ([cell.item[@"video_url"] length]) {
                    NSString *videoString = cell.item[@"video_url"];
                    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:videoString]];
                    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
                    controller.player = player;
                    
                    [[UIApplication presentedViewController] presentViewController:controller
                                                                          animated:YES
                                                                        completion:nil];
                }else {
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"视频不存在" preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [[UIApplication presentedViewController] presentViewController:controller animated:YES completion:nil];
                }
            }else {
                // 总结
                PinJiaView *view = [PinJiaView view];
                view.causeID = cell.item[@"id"];
                [view showInView:[UIApplication rootView]];
            }
        };
    }
    
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
    //播放视频
    
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                           editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSDictionary *item = self.items[indexPath.row];

        [[DataModel model] couseDeleteWithID:item[@"id"] hander:^(NSDictionary *info, NSError *error) {
            if (!error) {
                [self alert:info[@"msg"]?:@"删除成功！"];
                [self reloadViews];
            }else {
                [self alert:info[@"msg"]?:@"删除失败！"];
            }
        }];
    }]];
}

@end
