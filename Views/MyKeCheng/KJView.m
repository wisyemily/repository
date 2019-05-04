//
//  DSKView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "KJView.h"
#import "DataModel.h"
#import "MJRefresh.h"

#import "KJViewCell.h"
#import <AVKit/AVKit.h>
#import "UIApplication+PresentedViewController.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import "DocumentPreVC.h"

#import "ShowDocView.h"

@interface KJView ()<
UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate
>
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic) NSUInteger page;

@end

@implementation KJView

+ (KJView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"KJView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    __block KJView *weak_self = self;
    
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
    [[DataModel model] fetchUserdocListWithParams:@{@"user_id":[DataModel model].userInfo[@"id"]?:@"",
                                                    @"doc_type":@(1),
                                                    @"offset":@(page * 10),
                                                    @"limit":@(10),
                                                    @"sort":@"createtime",
                                                    @"order":@"desc"
                                                    }
                                           hander:^(NSDictionary *info, NSError *error)
     {
        if (error) {
            if (info[@"msg"])
                [self alert:info[@"msg"]];
            else
                [self alert:@"获取课件数据失败!"];
            
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
    KJViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KJViewCell"];
    if (!cell) {
        cell = [KJViewCell cell];
        cell.action = ^(KJViewCell *cell, KJActionType type) {
            if (type == KJActionTypeEnter) {
                //播放视频
                DocumentPreVC *vc = [DocumentPreVC vc];
                vc.documentID = cell.item[@"nim_doc_id"];
                [[UIApplication presentedViewController] presentViewController:vc animated:YES completion:nil];
            }else if (type == KJActionTypereDelete){
                [[DataModel model] deleteUserdocWithID:cell.item[@"id"] hander:^(NSDictionary *info, NSError *error) {
                    if (!error &&
                        [info[@"code"] integerValue] == 1) {
                        NSMutableArray *items = [self.items mutableCopy];
                        [items removeObject:cell.item];
                        self.items = items;
                        
                        [tableView reloadData];
                    }else {
                        [self alert:info[@"msg"]];
                    }
                }];
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

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    ShowDocView *view = [ShowDocView view];
    [view showInView:[UIApplication rootView]];
    
    return NO;
}
@end
