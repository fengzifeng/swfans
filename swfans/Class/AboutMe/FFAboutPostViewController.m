//
//  FFAboutPostViewController.m
//  swfans
//
//  Created by fengzifeng on 2017/9/21.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFAboutPostViewController.h"
#import "FFNewListCell.h"
#import "FFNewListModel.h"
#import "FFPostDetailViewController.h"

@interface FFAboutPostViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation FFAboutPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackButtonDefault];
    if (_isPost) {
        self.title = @"我的发帖";
    } else {
        self.title = @"我的回帖";
    }
    
    _tableView.backgroundColor = RGBCOLOR(242, 244, 247);
    self.view.backgroundColor = RGBCOLOR(242, 244, 247);
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [weakSelf requestData];
    }];
    self.tableView.mj_header = refreshHeader;
    
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        _page++;
//        [weakSelf requestData];
//    }];
//    footer.automaticallyHidden = YES;
//    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFNewListItemModel *model = _dataArray[indexPath.row];
    
    CGFloat tempHeight = [model.message stringHeightWithFont:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH - 18] + 14;
    tempHeight = tempHeight > 30?tempHeight:30;
    return tempHeight + 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FFNewListCell";
    FFNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FFNewListItemModel *model = _dataArray[indexPath.row];
    [cell updateCell:model];
    cell.upLabel.text = model.message;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFPostDetailViewController *vc = [FFPostDetailViewController viewController];
    FFNewListItemModel *model = _dataArray[indexPath.row];
    vc.postId = model.pid;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestData
{
    NSString *requestUrl;
    if (!_isPost) {
        requestUrl = [NSString stringWithFormat:@"%@%@/%@/%@",url_profile_posts,_loginUser.uid,_loginUser.signCode,@(_page)];
    } else {
        requestUrl = [NSString stringWithFormat:@"%@%@/%@/%@",url_profile_threads,_loginUser.uid,_loginUser.signCode,@(_page)];
    }
    
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        
        if (successed) {
            FFNewListModel *model = [FFNewListModel objectWithKeyValues:response.payload];
            if (model.data.count) {
                if (!_page) {
                    _dataArray = [model.data mutableCopy];
                } else {
                    [_dataArray addObjectsFromArray:model.data];
                }
                [_tableView reloadData];
                
            } else {
                if (_page) _page--;
            }
        } else {
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}


@end
