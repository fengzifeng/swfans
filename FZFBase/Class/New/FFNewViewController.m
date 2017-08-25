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
    
    [self requestData];    
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
