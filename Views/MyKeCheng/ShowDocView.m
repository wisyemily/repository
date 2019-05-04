//
//  SelectDocView.m
//  jsz
//
//  Created by 朱东勇 on 2018/6/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "ShowDocView.h"
#import "KJViewCell1.h"
#import "DataModel.h"
#import "DocumentPreVC.h"
#import "UIApplication+PresentedViewController.h"

@interface ShowDocView ()
<
UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSMutableArray *items;


@end

@implementation ShowDocView

+ (ShowDocView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"ShowDocView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self searchWithString:nil];
}

- (void)searchWithString:(NSString*)text {
    if (text.length) {
        [[DataModel model] searchDocsWithString:text hander:^(NSDictionary *info, NSError *error) {
            if (!error) {
                self.items = info[@"data"];
                NSLog(@"items = %@",self.items);
                [self.listView reloadData];
            }else {
                [self alert:info[@"msg"]?:@"搜索文档失败!"];
            }
        }];
    }else {
        self.items = @[];
        [self.listView reloadData];
    }
}

- (void)showInView:(UIView *)view direction:(PopViewDirect)direction {
    [super showInView:view direction:direction];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - UISearchBarDelegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;                      // return NO to not become first responder
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;                     // called when text starts editing
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;                        // return NO to not resign first responder
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;                       // called when text ends editing
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0); // called before text changes

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchWithString:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    [self searchWithString:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self searchWithString:searchBar.text];
    [searchBar resignFirstResponder];
}

//- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED; // called when search results button pressed
//
//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope NS_AVAILABLE_IOS(3_0);


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KJViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"KJViewCell"];
    if (!cell) {
        cell = [KJViewCell1 cell];
        cell.action = ^(KJViewCell1 *cell, KJActionType1 type) {
            if (type == KJActionType1Enter) {
                //播放视频
                DocumentPreVC *vc = [DocumentPreVC vc];
                vc.documentID = cell.item[@"nim_doc_id"];
                
                [[UIApplication presentedViewController] presentViewController:vc animated:YES completion:nil];
            }else if (type == KJActionType1Bind){
                NSLog(@"cell.item = %@",cell.item);
               /* NSDictionary *params = @{@"user_id":[DataModel model].userInfo[@"id"]?:@"",
                                         @"nim_doc_id":cell.item[@"nim_doc_id"]?:@"",
                                         @"name":cell.item[@"name"]?:@"",
                                         @"nim_doc_pic_image":cell.item[@"nim_doc_pic_image"]?:@"",
                                         @"type":cell.item[@"type"]?:@"",
                                         @"doc_type":cell.item[@"doc_type"]?:@""
                                         };*/
                NSDictionary *params = @{@"user_id":[DataModel model].userInfo[@"id"]?:@"",
                                         @"imagedoc_id":cell.item[@"nim_doc_id"]?:@""
                                         
                                         };
                [[DataModel model] shareDocWithParams:params hander:^(NSDictionary *info, NSError *error) {
                    if (error) {
                        [self alert:info[@"msg"]?:@"选定课件失败！"];
                    }else {
                        [self alert:info[@"msg"]?:@"选定课件成功！"];
                    }
                }];
                
                
//                [[DataModel model] deleteUserdocWithID:cell.item[@"id"] hander:^(NSDictionary *info, NSError *error) {
//                    if (!error &&
//                        [info[@"code"] integerValue] == 1) {
//                        NSMutableArray *items = [self.items mutableCopy];
//                        [items removeObject:cell.item];
//                        self.items = items;
//
//                        [tableView reloadData];
//                    }else {
//                        [self alert:info[@"msg"]];
//                    }
//                }];
            }
        };
    }
    
    cell.item = self.items[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //播放视频
    
}

#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

@end
