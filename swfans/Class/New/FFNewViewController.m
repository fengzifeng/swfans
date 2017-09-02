//
//  FFNewViewController.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/16.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFNewViewController.h"
#import "FFNewListCell.h"
#import "FFPlateDetailViewController.h"
#import "FFPostDetailViewController.h"
#import "FFNewListModel.h"

@interface FFNewViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FFNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackButtonDefault];
    self.title = @"主题";

    if (_forum_id.length) [_tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [_tableView headerBeginRefreshing];
    self.dataArray = [NSMutableArray new];
    
    [self requestData];
}

-(void)headerRereshing{
    [self requestData];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [_commentListView.commentTable reloadData];
//        // (最好在刷新表格后调用)调用headerEndRefreshing可以结束刷新状态
//        [_commentListView.commentTable headerEndRefreshing];
//    });
}

- (void)footerRereshing
{
    
    [self requestData];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [_commentListView.commentTable reloadData];
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [_commentListView.commentTable footerEndRefreshing];
//    });
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"最新";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFNewListItemModel *model = _dataArray[indexPath.row];
    
    return model.height;
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFPostDetailViewController *vc = [FFPostDetailViewController viewController];
    FFNewListItemModel *model = _dataArray[indexPath.row];
    vc.postId = model.tid;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestData
{
    NSUInteger pageIndex = 0;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",url_latestthreads,@(pageIndex)];
    if (_forum_id.length) {
        requestUrl = [NSString stringWithFormat:@"%@%@/page/%@/%@",url_threads,_forum_id,@(pageIndex),_type];
    }
    
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            FFNewListModel *model = [FFNewListModel objectWithKeyValues:response.payload];
            _dataArray = [model.data mutableCopy];
            [_tableView reloadData];
        }
    }];
}
@end
