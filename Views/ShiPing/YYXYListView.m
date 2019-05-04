//
//  YYXYListView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "YYXYListView.h"
#import "DataModel.h"
#import "YYXYListViewCell.h"
#import "MJRefresh.h"

@interface YYXYListView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic) NSUInteger page;

@end

@implementation YYXYListView

+ (YYXYListView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"YYXYListView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    __block YYXYListView *weak_self = self;
    
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

#pragma mark - Setter
- (void)setItem:(NSDictionary *)item {
    _item = item;
    
    self.page = 0;
}

- (void)setPage:(NSUInteger)page {
    [[DataModel model] fetchVideoListWithParams:@{@"currentPage":@(page+1),
                                                  @"pageSize":@(20),
                                                  @"type":self.item[@"typeId"]?:@""
                                                  }
                                         hander:^(NSDictionary *info, NSError *error)
     {
         if (error) {
             [self alert:@"加载视频列表数据失败!"];
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
    YYXYListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYXYListViewCell"];
    if (!cell)
        cell = [YYXYListViewCell cell];
    
    cell.item = self.items[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.width / 320 * 160;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.action)
        self.action(self, self.items[indexPath.row]);
}

@end
