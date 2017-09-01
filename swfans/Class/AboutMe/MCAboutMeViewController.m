//
//  MCAboutMeViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/7.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCAboutMeViewController.h"
#import "FFAboutDownHeadView.h"
#import "FFAboutMeCell.h"
#import "USAuthViewController.h"

@interface MCAboutMeViewController ()
{
    NSArray *_titleArray;

}
@end

@implementation MCAboutMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:Notification_LoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRegSwitch:) name:Notification_LoginRegSwitch object:nil];
    }
    
    return self;
}

- (void)loginSuccess
{
    _titleArray = @[@[@"我的收藏",@"最近浏览"],@[@"联系代理商",@"投诉建议"]];
    _tableView.tableHeaderView = [self createHeadView];
    [_tableView reloadData];
}

- (void)loginRegSwitch:(NSNotification *)noti
{
    USAuthViewController *vc = [USAuthViewController viewController];
    vc.isLogin = [noti.object boolValue];
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
        [self setNavigationBackButtonDefault];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = HexColor(0xebecee);
    _tableView.tableHeaderView = [self createHeadView];
    self.view.backgroundColor = HexColor(0xebecee);
    
    if (_loginUser) _titleArray = @[@[@"我的收藏",@"最近浏览"],@[@"联系代理商",@"投诉建议"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = _loginUser?_loginUser.nickname:@"个人主页";
}

- (UIView *)getMidView:(NSString *)title image:(UIImage *)image
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 117)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, view.width, 14)];
    postLabel.text = title;
    postLabel.textAlignment = NSTextAlignmentCenter;
    postLabel.textColor = HexColor(0x5f5f5f);
    postLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:postLabel];
    UIButton *leftBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBUtton.frame = CGRectMake((view.width - 45)/2.0, CGRectGetMaxY(postLabel.frame) + 17, 45, 45);
    leftBUtton.backgroundColor = [UIColor grayColor];
    [leftBUtton setImage:image forState:UIControlStateNormal];
    [view addSubview:leftBUtton];

    return view;
}



- (UIView *)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 279)];
    UIView *upBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    upBgView.backgroundColor = HexColor(0xaa2d1b);
    [headView addSubview:upBgView];
    

    if (_loginUser) {
        upBgView.height = 110;
        UIButton *faceBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
        faceBUtton.frame = CGRectMake((SCREEN_WIDTH - 71)/2.0, (110 - 71)/2.0, 71, 71);
        faceBUtton.layer.masksToBounds = YES;
        faceBUtton.layer.cornerRadius = 71/2.0;
        faceBUtton.backgroundColor = [UIColor whiteColor];
        [headView addSubview:faceBUtton];

        UIView *midLeftView = [self getMidView:@"我的发帖" image:nil];
        midLeftView.origin = CGPointMake(0, CGRectGetMaxY(upBgView.frame));
        [headView addSubview:midLeftView];
        UIView *midRightView = [self getMidView:@"我的回帖" image:nil];
        midRightView.origin = CGPointMake(SCREEN_WIDTH/2.0, CGRectGetMaxY(upBgView.frame));
        [headView addSubview:midRightView];
        
        UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(midLeftView.frame) + 10, SCREEN_WIDTH, 117)];
        FFAboutDownHeadView *FFView = [[[NSBundle mainBundle] loadNibNamed:@"FFAboutDownHeadView" owner:self options:nil] firstObject];
        [downView addSubview:FFView];
        [FFView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [headView addSubview:downView];
        headView.height = 117 + 117 + 110 + 10;
    } else {
        upBgView.height = 224;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 15)];
        label.text = @"登录3D社群，体验更多功能";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [upBgView addSubview:label];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setTitle:@"注册/登录" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        loginButton.layer.masksToBounds = YES;
        loginButton.layer.cornerRadius = 5;
        loginButton.layer.borderWidth = 1;
        loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
        loginButton.frame = CGRectMake((SCREEN_WIDTH - 102)/2.0, CGRectGetMaxY(label.frame) + 24, 102, 38);
        [loginButton addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
        [upBgView addSubview:loginButton];
        
        UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        downButton.frame = CGRectMake(0, CGRectGetMaxY(upBgView.frame) + 11, SCREEN_WIDTH, 44);
        downButton.backgroundColor = [UIColor whiteColor];
        [headView addSubview:downButton];
        
        UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, 200, 44)];
        downLabel.text = @"联系代理商";
        downLabel.textColor = HexColor(0x5f5f5f);
        downLabel.font = [UIFont systemFontOfSize:13];
        [downButton addSubview:downLabel];
    }
    
    return headView;

}

- (void)clickLogin
{
    USAuthViewController *vc = [USAuthViewController viewController];
    vc.isLogin = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"FFAboutMeCell";
    FFAboutMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    
    [cell updateCell:_titleArray[indexPath.section][indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

@end
