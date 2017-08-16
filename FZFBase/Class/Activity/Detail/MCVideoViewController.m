//
//  MCVideoViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/21.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCVideoViewController.h"
#import "TBPlayer.h"
#import "MCNewsBaseViewController.h"
#import "MCNewsTableViewCell.h"

@interface MCVideoViewController ()
{
    TBPlayer *_player;

}
@end

@implementation MCVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = VIEW_BG_COLOR;
    self.title = @"视频";
    [self setNavigationBackButtonDefault];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:_topInset];
    _tableView.contentInset = UIEdgeInsetsMake(SCREEN_WIDTH*9/16.0, 0, 0, 0);
    
    _player = [[TBPlayer alloc] init];
    [self createHeadView:_player];
}

- (void)createHeadView:(TBPlayer *)player
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, _topInset, SCREEN_WIDTH, SCREEN_WIDTH*9/16.0)];
    headView.backgroundColor = [UIColor redColor];
    [self.view addSubview:headView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"204" ofType:@"mp4"];
    NSURL *localURL = [NSURL fileURLWithPath:path];
    
    [player playWithUrl:localURL showView:headView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MCNewsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil][1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)dealloc
{
    [[TBPlayer sharedInstance] stop];

}


@end
