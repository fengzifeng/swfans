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
@property (nonatomic, assign) NSInteger page;
//@property (nonatomic, assign) BOOL isUp;
//@property (nonatomic, assign) BOOL isDown;

@end

@implementation FFNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackButtonDefault];
    self.title = @"主题";

    if (_forum_id.length) [_tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [_tableView headerBeginRefreshing];
}

-(void)headerRereshing{
    _page = 0;
    [self requestData];
}

- (void)footerRereshing
{
    _page++;
    [self requestData];
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
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];

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
        }
    }];
}
@end
