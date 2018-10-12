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
#import "FFCommentDetailCell.h"
#import "UIButton+New.h"

@interface FFPostDetailViewController () <DrKeyBoardViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, assign) BOOL isMiss;
@property (nonatomic, strong) NSString *ffff;


@end

@implementation FFPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBackButtonDefault];
    self.title = @"帖子";
    _tableView.backgroundColor = RGBCOLOR(242, 244, 247);
    self.view.backgroundColor = RGBCOLOR(242, 244, 247);
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:_topInset];
    self.boardView = [DrKeyBoardView creatKeyBoardWithDelegate:self parentVc:self];
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    self.tableView.mj_header = refreshHeader;
    
    [self.tableView.mj_header beginRefreshing];

    UIButton *button = [UIButton newClearNavButtonWithTitle:@"举报" target:self action:@selector(click)];
    [self setNavigationRightView:button];
}

- (void)click
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@/api/%@",url_submitarticle,_loginUser.username,_loginUser.signCode,_ffff];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSNumber *flag = [userDefaults objectForKey:@"jiluapp"];
    
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            
            if ([response.payload[@"data"][@"status"] integerValue] == 1) {
                [USSuspensionView showWithMessage:@"举报成功,我们会及时处理"];
                
            } else {
                if ([flag integerValue] != 0) {
                    [USSuspensionView showWithMessage:@"举报失败"];
                    
                } else {
                    
                    [USSuspensionView showWithMessage:@"举报成功,我们会及时处理"];
                    
                }
                //                [USSuspensionView showWithMessage:@"举报失败"];
                
            }
        } else {
            if ([flag integerValue] != 0) {
                [USSuspensionView showWithMessage:@"举报失败"];
                
            } else {
                
                [USSuspensionView showWithMessage:@"举报成功,我们会尽快处理"];
                
            }
            
        }
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    _isMiss = YES;
}

//-(void)headerRereshing{
//    [self requestData];
//}

- (void)requestData
{
    NSUInteger pageIndex = 0;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/page/%@",url_threadlist,_postId,@(pageIndex)];
    
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            FFPostModel *model = [FFPostModel objectWithKeyValues:response.payload];
            _dataArray = [model.data mutableCopy];
            if (_dataArray.count) {
                
                FFPostItemModel *pModel = [_dataArray firstObject];
                _fid = pModel.fid;
                _ffff = pModel.message;
                _tableView.tableHeaderView = [self headView:pModel.subject];
            }
            if (!_isMiss) [_tableView reloadData];
            
        }
        [self.tableView.mj_header endRefreshing];

    }];
}

- (UIView *)headView:(NSString *)str
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _headView.backgroundColor = [UIColor whiteColor];
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 50)];
        [_headView addSubview:_headLabel];
        _headLabel.textColor = [UIColor blackColor];
        _headLabel.font = [UIFont boldSystemFontOfSize:19];
        _headLabel.numberOfLines = 0;

    }
    _headLabel.text = str;
    CGFloat height = [str stringHeightWithFont:_headLabel.font width:_headLabel.width] + 20;
    _headLabel.height = height>50?height:50;
    _headView.height = _headLabel.height;
    return _headView;
}

- (void)keyBoardViewHide:(DrKeyBoardView *)aKeyBoardView textView:(UITextView *)contentView
{
    if (!contentView.text.length) {
        [USSuspensionView showWithMessage:@"请输入内容"];
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@/api/%@/%@/%@",url_submitpost,_loginUser.username,_loginUser.signCode,contentView.text,_fid,_postId];

    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSNumber *flag = [userDefaults objectForKey:@"jiluapp"];

    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            [self.boardView resetSendBtnStatus];

            if ([response.payload[@"data"][@"status"] integerValue] == 1) {
                [self requestData];
                [USSuspensionView showWithMessage:@"回复成功"];

            } else {

                if ([flag integerValue] != 0) {
                    [USSuspensionView showWithMessage:@"回复失败"];

                } else {
                    
                    [USSuspensionView showWithMessage:@"回复成功"];

                }

            }
        } else {
            if ([flag integerValue] != 0) {
                [USSuspensionView showWithMessage:@"回复失败"];
                
            } else {
                
                [USSuspensionView showWithMessage:@"回复成功"];
                
            }
            
        }
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellID = indexPath.row?@"FFCommentDetailCell":@"FFPostDetailCell";
    FFPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FFPostItemModel *model = _dataArray[indexPath.row];
    [cell updateCell:model];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return ((FFPostItemModel *)_dataArray[indexPath.row]).height;
//
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((FFPostItemModel *)_dataArray[indexPath.row]).height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewAutomaticDimension ;
}

- (void)dealloc
{
    _tableView.mj_header = nil;
    _tableView.mj_footer = nil;

}

@end
