//
//  MCAboutMeViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/7.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCAboutMeViewController.h"
#import "MCAboutMeCell.h"
#import "USEditUserInfoViewController.h"
#import "MCSettingViewController.h"
#import "USActShareView.h"

@interface MCAboutMeViewController ()
{
    NSArray *_titleArray;

}
@end

@implementation MCAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBackButtonDefault];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:_topInset];
    _titleArray = @[@"个人信息",@"我的首页",@"推荐好友",@"我的收藏",@"设置"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"主页";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MCAboutMeCell";
    MCAboutMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    
    [cell updateCell:_titleArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        USEditUserInfoViewController *vc = [USEditUserInfoViewController viewController];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4) {
        MCSettingViewController *vc = [MCSettingViewController viewController];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        [USActShareView showShareApp];
    } else if (indexPath.row == 3) {
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;

}

@end
