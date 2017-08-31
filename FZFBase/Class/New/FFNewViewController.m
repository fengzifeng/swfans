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

@interface FFNewViewController ()

@end

@implementation FFNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [_tableView headerBeginRefreshing];
    
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FFNewListCell";
    FFNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFPostDetailViewController *vc = [FFPostDetailViewController viewController];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)requestData
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://businessapitest.58v5.cn/jxbus/list"];
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:@{@"jxid":@"869846979897745408"} complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            
        } else {
        }
    }];
    
}
@end
