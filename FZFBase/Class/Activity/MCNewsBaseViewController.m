//
//  MCNewsBaseViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCNewsBaseViewController.h"
#import "MCNewsTableViewCell.h"
#import "MCDetailPageViewController.h"
#import "MCVideoViewController.h"
#import "MCPictureBrowersViewController.h"
#import "FFNewsModel.h"

@interface MCNewsBaseViewController ()

@end

@implementation MCNewsBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.navigationBar.hidden = YES;
    self.title = @"我的收藏";
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MCNewsTableViewCell";
    FFNewsModel *model = _dataArray[indexPath.row];
//    NSInteger index = 0;
//    
//    if (indexPath.row%20 == 0) {
//        index = 3;
//    } else if (indexPath.row%20 == 6) {
//        index = 2;
//        
//    } else if (indexPath.row%20 == 12) {
//        index = 4;
//        
//    } else {
//        index = 1;
//        
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil][model.cell_type];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FFNewsModel *model = _dataArray[indexPath.row];
    if (model.cell_type == TOPVIDEO_CELL_TYPE) {
        MCVideoViewController *vc = [MCVideoViewController viewController];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.cell_type == TOPIMAGE_CELL_TYPE) {
        MCPictureBrowersViewController *vc = [[MCPictureBrowersViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        MCDetailPageViewController *vc = [[MCDetailPageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFNewsModel *model = _dataArray[indexPath.row];

    float height = 0;
    if (model.cell_type == TOPVIDEO_CELL_TYPE) {
        height = 245;
    } else if (model.cell_type == TOPIMAGE_CELL_TYPE) {
        height = 245;

    } else if (model.cell_type == BIGIMAGE_CELL_TYPE) {
        height = 170;

    } else if (model.cell_type == IMAGES_CELL_TYPE) {
        height = 130;
        
    } else {
        height = 80;

    }

    return height;
}


@end
