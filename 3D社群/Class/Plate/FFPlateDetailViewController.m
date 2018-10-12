//
//  FFPlateDetailViewController.m
//  FZFBase
//
//  Created by 冯子丰 on 2017/8/22.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPlateDetailViewController.h"
#import "FFPlateLeftCell.h"
#import "FFPlateRightCell.h"
#import "FFPlateModel.h"

@interface FFPlateDetailViewController ()

@end

@implementation FFPlateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBackButtonDefault];
    CGRect viewBounds = self.view.bounds;
    float navBarHeight = self.navigationController.navigationBar.frame.size.height + 20;
    viewBounds.size.height = ([[UIScreen mainScreen] bounds].size.height) - navBarHeight;
    self.view.bounds = viewBounds;
    
    [self leftTableView];
    [self rightTableView];
    [self requestData];

//    [_rightTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    
//    [_rightTableView headerBeginRefreshing];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    self.rightTableView.mj_header = refreshHeader;
    
    [self.rightTableView.mj_header beginRefreshing];
    
    _isRelate = YES;
}
//-(void)headerRereshing{
//    [self requestData];
//}

- (void)requestData
{
    [[DrHttpManager defaultManager] getRequestToUrl:url_structedgroups params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            _leftTableView.hidden = NO;
            _rightTableView.hidden = NO;
            [userDefaults setObject:response.payload forKey:UserDefaultKey_plateData];
            FFPlateModel *model = [FFPlateModel objectWithKeyValues:response.payload];
            _dataArray = model.data;
            [_leftTableView reloadData];
            [_rightTableView reloadData];
        }
        
        [self.rightTableView.mj_header endRefreshing];
        self.rightTableView.mj_header.hidden = YES;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.parentViewController setNavigationTitleView:nil];
    self.parentViewController.title = @"板块";
}

- (UITableView *)leftTableView {
    if (nil == _leftTableView){
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topInset, 100, SCREEN_HEIGHT - _topInset - 49)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.backgroundColor = RGBCOLOR(246, 246, 246);
//        _leftTableView.hidden = YES;
        [self.view addSubview:_leftTableView];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    if (nil == _rightTableView){
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, _topInset, SCREEN_WIDTH - 100, SCREEN_HEIGHT - _topInset - 49)];
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
//        _rightTableView.hidden = YES;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_rightTableView];
    }
    return _rightTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) {
        return 1;
    } else {
        return [_dataArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return _dataArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        static NSString *CellIdentifier = @"FFPlateLeftCell";
        FFPlateLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil][0];
            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
            selectedBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = selectedBackgroundView;
            
            UIView *liner = [[UIView alloc] initWithFrame: CGRectMake(0, (50 - 18)/2.0, 4, 18)];
            liner.backgroundColor = RGBCOLOR(170, 45, 27);
            [selectedBackgroundView addSubview:liner];
        }
        
        FFPlateSectionModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = model.name;
        return cell;
        
    } else {
        static NSString *CellIdentifier = @"FFPlateRightCell";
        FFPlateRightCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil][0];
        }
        FFPlateSectionModel *model = [_dataArray objectAtIndex:indexPath.section];

        [cell updateCell:model];

        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        return 50;
    } else {
        FFPlateSectionModel *model = [_dataArray objectAtIndex:indexPath.section];
        return [FFPlateRightCell getCellHeight:model];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return CGFLOAT_MIN;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return 0;
    } else {
        //重要,或者0.01
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.rightTableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];;
        
        UILabel *lable = [[UILabel alloc]initWithFrame:view.bounds];
        lable.font = [UIFont systemFontOfSize:12];
        FFPlateSectionModel *model = [_dataArray objectAtIndex:section];
        lable.text = [NSString stringWithFormat:@"   %@", model.name];
        [view addSubview:lable];
        return view;
        
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == self.rightTableView) {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == self.rightTableView) {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        _isRelate = NO;
        
        [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        [self.rightTableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isRelate = YES;
}
@end
