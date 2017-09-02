//
//  FFPostDetailViewController.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/25.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPostDetailViewController.h"
#import "FFPostDetailCell.h"
#import "FFPostModel.h"

@interface FFPostDetailViewController () <DrKeyBoardViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FFPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBackButtonDefault];
    self.title = @"帖子";
    
    self.boardView = [DrKeyBoardView creatKeyBoardWithDelegate:self parentVc:self];
    [self requestData];

}
- (void)requestData
{
    NSUInteger pageIndex = 0;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/page/%@",url_threadlist,_postId,@(pageIndex)];
    
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            FFPostModel *model = [FFPostModel objectWithKeyValues:response.payload];
            _dataArray = [model.data mutableCopy];

            [_tableView reloadData];
        }
    }];
}

- (void)keyBoardViewHide:(DrKeyBoardView *)aKeyBoardView textView:(UITextView *)contentView
{
    [self.boardView resetSendBtnStatus];
//    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/page/%@",url_submitpost,_postId,@(pageIndex)];
//    
//    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
//        if (successed) {
//            FFPostModel *model = [FFPostModel objectWithKeyValues:response.payload];
//            _dataArray = [model.data mutableCopy];
//            
//            [_tableView reloadData];
//        }
//    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FFPostDetailCell";
    FFPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FFPostItemModel *model = _dataArray[indexPath.row];
    [cell updateCell:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((FFPostItemModel *)_dataArray[indexPath.row]).height;

}


@end
