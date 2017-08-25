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
    
    [self loadData];
    [self leftTableView];
    [self rightTableView];
    
    _isRelate = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"板块";
}

- (void)loadData {
    _dataArray = @[
                   @{@"title" : @"活动巡展区",
                     @"list" : @[@"Soldier"]
                     },
                   @{@"title" : @"技术交流区",
                     @"list" : @[@"Soldier"]
                     },
                   @{@"title" : @"产品讨论区",
                     @"list" : @[@"Soldier"]
                     },
                   @{@"title" : @"下载专区",
                     @"list" : @[@"Soldier"]
                     },
                   @{@"title" : @"综合讨论区",
                     @"list" : @[@"Soldier"]
                     }];
}

- (UITableView *)leftTableView {
    if (nil == _leftTableView){
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 100, SCREEN_HEIGHT - 64)];
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.backgroundColor = RGBCOLOR(217, 217, 217);
        
        [self.view addSubview:_leftTableView];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    if (nil == _rightTableView){
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 64, SCREEN_WIDTH - 100, SCREEN_HEIGHT - 64)];
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
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
    NSDictionary *item = [_dataArray objectAtIndex:section];
    if (tableView == self.leftTableView) {
        return [_dataArray count];
    } else {
        return [[item objectForKey:@"list"] count];
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
        
        cell.titleLabel.text = [_dataArray[indexPath.row] objectForKey:@"title"];
        return cell;
        
    } else {
        static NSString *CellIdentifier = @"FFPlateRightCell";
        FFPlateRightCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil][0];
        }
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        return 50;
    } else {
        return [FFPlateRightCell getCellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return 30;
    } else {
        return 30;
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
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        view.backgroundColor = RGBACOLOR(217, 217, 217, 0.7);
        
        UILabel *lable = [[UILabel alloc]initWithFrame:view.bounds];
        NSDictionary *item = [_dataArray objectAtIndex:section];
        NSString *title = [item objectForKey:@"title"];
        lable.text = [NSString stringWithFormat:@"   %@", title];
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
