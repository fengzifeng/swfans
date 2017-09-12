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
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *headLabel;

@end

@implementation FFPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBackButtonDefault];
    self.title = @"帖子";
    
    self.boardView = [DrKeyBoardView creatKeyBoardWithDelegate:self parentVc:self];
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView headerBeginRefreshing];
}

-(void)headerRereshing{
    [self requestData];
}

- (void)requestData
{
    NSUInteger pageIndex = 0;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/page/%@",url_threadlist,_postId,@(pageIndex)];
    
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        [_tableView headerEndRefreshing];
        if (successed) {
            FFPostModel *model = [FFPostModel objectWithKeyValues:response.payload];
            _dataArray = [model.data mutableCopy];
            if (_dataArray.count) {
                FFPostItemModel *pModel = [_dataArray firstObject];
                _fid = pModel.fid;
                _tableView.tableHeaderView = [self headView:pModel.subject];
            }

            [_tableView reloadData];
        }
    }];
}

- (UIView *)headView:(NSString *)str
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 50)];
        [_headView addSubview:_headLabel];
        _headLabel.textColor = [UIColor blackColor];
        _headLabel.font = [UIFont boldSystemFontOfSize:19];

    }
    _headLabel.text = str;
    CGFloat height = [str stringHeightWithFont:_headLabel.font width:_headLabel.width] + 10;
    _headLabel.height = height>50?height:50;
    _headView.height = _headLabel.height;
    return _headView;
}

- (void)keyBoardViewHide:(DrKeyBoardView *)aKeyBoardView textView:(UITextView *)contentView
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@/api/%@/%@/%@",url_submitpost,_loginUser.username,_loginUser.signCode,contentView.text,_fid,_postId];

    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            [self.boardView resetSendBtnStatus];

            if ([response.payload[@"data"][@"status"] integerValue] == 1) {
                [self requestData];
                [USSuspensionView showWithMessage:@"回复成功"];

            } else {
                [USSuspensionView showWithMessage:@"回复失败"];

            }
        } else {
            [USSuspensionView showWithMessage:@"回复失败"];
        }
    }];
    
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
