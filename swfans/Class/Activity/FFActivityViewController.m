//
//  FFActivityViewController.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/16.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFActivityViewController.h"
#import "FFActivityListCell.h"
#import "FFActivityModel.h"
#import "FFPostDetailViewController.h"

@interface FFActivityViewController ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FFActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];

}

- (void)requestData
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",url_articles,@(_page)];
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            FFActivityModel *model = [FFActivityModel objectWithKeyValues:response.payload];
            _dataArray = [model.data mutableCopy];
            [_tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"活动";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FFActivityListCell";
    FFActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FFActivityItemModel *model = _dataArray[indexPath.row];
    [cell updateCell:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFPostDetailViewController *vc = [FFPostDetailViewController viewController];
    FFActivityItemModel *model = _dataArray[indexPath.row];
    vc.postId = model.tid;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
