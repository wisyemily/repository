//
//  DSKView.m
//  jsz
//
//  Created by 朱东勇 on 2018/4/4.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "DSKView.h"
#import "DataModel.h"
#import "MJRefresh.h"

#import "DSKViewCell.h"

#import "UIView+Toast.h"
#import "NTESMeetingViewController.h"
#import "NTESMeetingManager.h"
#import "NTESMeetingRolesManager.h"

#import "UIApplication+PresentedViewController.h"

#import <NIMAVChat/NIMAVChat.h>
#import "NTESMeetingViewController.h"
#import "SVProgressHUD.h"

#import "SelectDocView.h"

//Agora
#import "VideoRoomViewController.h"

//White
#import "WhiteRoomViewController.h"

@interface DSKView ()<UITableViewDelegate, UITableViewDataSource,VideoRoomVCDelegate>
@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic) BOOL enteringChatroom;

@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic) NSUInteger page;

@end

@implementation DSKView

+ (DSKView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"DSKView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    __block DSKView *weak_self = self;
    
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
                                              @"status":@(1),
                                              @"offset":@(page * 10),
                                              @"limit":@(10),
                                              @"sort":@"start_time",
                                              @"order":@"asc"//@"desc"
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
    DSKViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DSKViewCell"];
    if (!cell) {
        cell = [DSKViewCell cell];
        cell.action = ^(DSKViewCell *cell, DSKActionType type) {
            if (type == DSKActionTypeRemove) {
                //移除
                [[DataModel model] modifyYuyueWithParams:@{@"id":cell.item[@"id"]?:@"",
                                                           @"status":@(4)
                                                           }
                                                  hander:^(NSDictionary *info, NSError *error)
                {
                    if (error) {
                        [self alert:info[@"msg"]?:@"取消预约失败!"];
                    }else {
                        self.page = 0;
                    }
                }];
            }else if (type == DSKActionTypeSelectDoc) {
                SelectDocView *view = [SelectDocView view];
                view.data = cell.item;
                [view showInView:[UIApplication rootView]];
            }else {
                //__weak typeof(self) wself = self;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *date = [formatter dateFromString:cell.item[@"start_time"]];
                if ([NSDate date].timeIntervalSince1970 + 300 <= date.timeIntervalSince1970
#if DEBUG
                    && 0
#endif
                    ) {
                    [self alert:@"还未到上课时间，请稍候！"];
                    return ;
                }
                
                //
                NSLog(@"item=%@",cell.item);
                NSString *roomName = [cell.item[@"id"] description];//[cell.item[@"teacher_room_id"] description];
                NSString *whiteUUId = [cell.item[@"white_uuid"] description];
                NSString *teachUID = [cell.item[@"teacher_id"] description];
                /*WhiteRoomViewController *vc = [[WhiteRoomViewController alloc] init];
                vc.roomUuid = whiteUUId;
                [[UIApplication presentedViewController] presentViewController:vc
                                                                      animated:NO
                                                                    completion:nil];*/
                VideoRoomViewController *roomVC = [[VideoRoomViewController alloc] init];
                [roomVC setRoomName:roomName];
                [roomVC setWhiteUUID:whiteUUId];
                [roomVC setTeachUID:teachUID];
                roomVC.delegate = self;
                [[UIApplication presentedViewController] presentViewController:roomVC
                                                                      animated:NO
                                                                    completion:nil];
                
                /*[SVProgressHUD show];
                    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
                    request.roomId = [cell.item[@"teacher_room_id"] description];
                    [[NSUserDefaults standardUserDefaults] setObject:request.roomId forKey:@"cachedRoom"];
                    [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError *error, NIMChatroom *chatroom, NIMChatroomMember *me) {
                        [SVProgressHUD dismiss];
                        if (!error) {
                            [[NTESMeetingManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
                            [[NTESMeetingRolesManager sharedInstance] startNewMeeting:me withChatroom:chatroom newCreated:NO];
                            //                        [[NTESMeetingManager sharedInstance] cacheMyInfo:me roomId:chatroom.roomId];
                            
                            __block NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithUser:cell.item[@"teacher_account"]
                                                                                                               room:chatroom];
                            
                            vc.complention = ^(UInt64 callID, BOOL finished) {
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                NSDate *endDate = [formatter dateFromString:cell.item[@"end_time"]];
                                
                                if (endDate.timeIntervalSince1970 - [NSDate date].timeIntervalSince1970 > 0) {
                                    [[DataModel model] modifyYuyueWithParams:@{@"channelid":@(callID),
                                                                               @"status":@(3),
                                                                               @"id":cell.item[@"id"]
                                                                               } hander:^(NSDictionary *info, NSError *error) {
                                                                                   vc.complention = NULL;
                                                                               }];
                                }else {
                                    vc.complention = NULL;
                                }
                            };
                            [[UIApplication presentedViewController] presentViewController:vc
                                                                                  animated:YES
                                                                                completion:nil];
                        }else {
                            //                        [self.view makeToast:@"进入房间失败，请确认ID是否正确" duration:2.0 position:CSToastPositionCenter];
                        }
                    }];*/

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
    
}


#pragma mark -VideoClose
- (void)roomVCNeedClose:(VideoRoomViewController *)roomVC {
   
   
    [[UIApplication presentedViewController] dismissViewControllerAnimated:YES completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
@end
