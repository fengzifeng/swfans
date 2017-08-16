//
//  FFNewsCollectionViewCell.m
//  FZFBase
//
//  Created by fengzifeng on 16/8/10.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "FFNewsCollectionViewCell.h"
#import "MCNewsTableViewCell.h"
#import "MCDetailPageViewController.h"
#import "MCVideoViewController.h"
#import "MCPictureBrowersViewController.h"
#import "FFNewsModel.h"

@interface FFNewsCollectionViewCell ()

{
    NSArray *_dataArray;
}

@end

@implementation FFNewsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)reloadView:(NSArray *)array
{
    if (array.count) {
        _dataArray = array;
        [_tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MCNewsTableViewCell";
    FFNewsModel *model = _dataArray[indexPath.row];
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
        [self.nearsetViewController.navigationController pushViewController:vc animated:YES];
    } else if (model.cell_type == TOPIMAGE_CELL_TYPE || model.cell_type == IMAGES_CELL_TYPE) {
        MCPictureBrowersViewController *vc = [[MCPictureBrowersViewController alloc] init];
        [self.nearsetViewController.navigationController pushViewController:vc animated:YES];
    }
    else {
        MCDetailPageViewController *vc = [[MCDetailPageViewController alloc] init];
        [self.nearsetViewController.navigationController pushViewController:vc animated:YES];
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
