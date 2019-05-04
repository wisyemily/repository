//
//  SelectDocView.m
//  jsz
//
//  Created by 朱东勇 on 2018/6/29.
//  Copyright © 2018年 innovator. All rights reserved.
//

#import "SelectDocView.h"
#import "SelectDockTableViewCell.h"
#import "DataModel.h"

@interface SelectDocView ()
<
UISearchBarDelegate,
UITextViewDelegate,
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) IBOutlet UIView *descBordView;
@property (nonatomic, strong) IBOutlet UILabel *alertLbl;
@property (nonatomic, strong) IBOutlet UITextView *descTV;

@property (nonatomic, strong) IBOutlet UIView *contentView;


@end

@implementation SelectDocView

+ (SelectDocView*)view {
    return [[NSBundle mainBundle] loadNibNamed:@"SelectDocView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.descBordView.layer.cornerRadius = 5;
    self.descBordView.layer.borderColor = [UIColor redColor].CGColor;
    self.descBordView.layer.borderWidth = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardBegin:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardBegin:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showInView:(UIView *)view direction:(PopViewDirect)direction {
    [super showInView:view direction:direction];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Setter
- (void)setData:(NSDictionary *)data {
    _data = data;
    
    [self searchWithString:nil];
}

#pragma mark - IBAction
- (IBAction)submit:(id)sender {
    NSString *ids = @"";
    
    for (NSDictionary *dic in self.items) {
        if ([[dic valueForKey:@"select"] boolValue]) {
            if (ids.length == 0)
                ids = [ids stringByAppendingFormat:@"%@", dic[@"id"]];
            else
                ids = [ids stringByAppendingFormat:@",%@", dic[@"id"]];
        }
    }
    /*id int 是 当前课程id
     userdoc_id int 是 选择的文档id,多个用逗号隔开
     remark int 否 备注信息
     */
    /*NSDictionary *params = @{@"remark":self.descTV.text?:@"",
                             @"id":_data[@"id"]?:@"",
                             @"userdoc_id":ids
                             };
    */
    /*请求路径：/imagedoc/select
     
     请求方式：GET/POST
     
     参数名    类型    必选    描述
     user_id    int    是    当前用户ID
     offset    int    是    偏移量
     limit    int    是    分页大小
     sort    String    是    排序字段 可选字段有createtime 文档创建时间 其他有需要可以跟我说
     order    String    是    排序规则 asc desc*/
    
    /*用户选择文档，当用户点击选择按键时，调用该接口存储用户选择的文件
    
    请求路径：/imagedoc/share
    
    请求方式：GET/POST
    
    参数名    类型    必选    描述
    user_id    int    是    当前用户id
    imagedoc_id    String    是    文档id*/
    /*NSDictionary *params = @{@"remark":self.descTV.text?:@"",
                             @"id":_data[@"id"]?:@"",
                             @"userdoc_id":ids
                             };*/
    NSDictionary *params = @{@"user_id":[DataModel model].userInfo[@"id"],
                            // @"id":_data[@"id"]?:@"",
                             @"imagedoc_id":ids
                             };
    
    [[DataModel model] selectUserDocWithParams:params hander:^(NSDictionary *info, NSError *error) {
        if (error) {
            [self alert:info[@"msg"]?:@"绑定课件失败！"];
        }else {
            [self alert:info[@"msg"]?:@"绑定课件成功！"];
            
            [self hidden];
        }
    }];
}

- (void)searchWithString:(NSString*)text {
    if (text.length) {
        [[DataModel model] searchDocsWithString:text hander:^(NSDictionary *info, NSError *error) {
            if (!error) {
                NSMutableArray *items = [NSMutableArray array];
                NSLog(@"items searchWithString = %@",info[@"data"]);
                for (NSDictionary *dic in info[@"data"]) {
                    [items addObject:[dic mutableCopy]];
                }
                
                self.items = items;
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

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *txt = textView.text;
    txt = [txt stringByReplacingCharactersInRange:range withString:text];
    
//    self.alertLbl.hidden = txt.length;
    
    return YES;
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
    SelectDockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectDockTableViewCell"];
    if (!cell)
        cell = [SelectDockTableViewCell cell];
    
    cell.data = self.items[indexPath.row];
    
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
    [self.descTV resignFirstResponder];
}

#pragma mark - Notification
- (void)keyboardBegin:(NSNotification*)notifcation {
    CGRect frame = [[notifcation.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.contentView.frame = CGRectMake(0,
                                        66,
                                        self.frame.size.width,
                                        frame.origin.y - 66);
}

@end
