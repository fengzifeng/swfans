//
//  USAuthViewController.m
//  USEvent
//
//  Created by fengzifeng on 15/9/15.
//  Copyright (c) 2015年 fengzifeng. All rights reserved.
//

#import "USAuthViewController.h"
#import "FFLoginCell.h"

@interface USAuthViewController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) FFLoginUser *loginObj;

@end

@implementation USAuthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationBar.hidden = YES;
    
    if (_isLogin) {
        _titleArray = @[@"用户名",@"密码"];
    } else {
        _titleArray = @[@"用户名",@"邮箱地址",@"密码(不少于6位)"];
    }
    
    _tableView.tableHeaderView = [self getHeadView];
    _tableView.tableFooterView = [self getFootView];
    _loginObj = [[FFLoginUser alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.view setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
    }];

}

- (UIView *)getHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 148)/2.0, 42, 148, 51)];
    iconImageView.image = [UIImage imageNamed:@"login_logo"];
    [headView addSubview:iconImageView];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
    UIImage *image = [UIImage imageNamed:@"login_close"];
    [closeButton setImage:[image imageScaledToSize:CGSizeMake(20, 20)]  forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeButton];
    
    
    return headView;
}

- (UIView *)getFootView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 102)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = HexColor(0xaa2d1b);
    button.frame = CGRectMake(19, 22, SCREEN_WIDTH - 19*2, 42);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(0, CGRectGetMaxY(button.frame) + 16, SCREEN_WIDTH, 30);
    [downButton setTitleColor:HexColor(0x6a6a6a) forState:UIControlStateNormal];
    downButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [downButton addTarget:self action:@selector(clickSwitch) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:downButton];

    if (_isLogin) {
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [downButton setTitle:@"没有账号？立即注册" forState:UIControlStateNormal];

    } else {
        [button setTitle:@"注册" forState:UIControlStateNormal];
        [downButton setTitle:@"已有账号？立即登录" forState:UIControlStateNormal];
    }

    return view;
}

- (void)clickSwitch
{
    _isLogin = !_isLogin;
    if (_isLogin) {
        _titleArray = @[@"用户名",@"密码"];
    } else {
        _titleArray = @[@"用户名",@"邮箱",@"密码(不少于6位)"];
    }
    _loginObj = [[FFLoginUser alloc] init];

    _tableView.tableHeaderView = [self getHeadView];
    _tableView.tableFooterView = [self getFootView];
    [_tableView reloadData];
//    [self dismissViewControllerAnimated:NO completion:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginRegSwitch object:@(!_isLogin)];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"FFLoginCell";
    FFLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
        cell.loginObj = _loginObj;
        cell.isLogin = _isLogin;
    }
    
    [cell updateCell:_titleArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (void)clickClose
{
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@/%@",url_register,_loginObj.username,_loginObj.password,_loginObj.email];
    if (_isLogin) requestUrl = [NSString stringWithFormat:@"%@%@/%@",url_login,_loginObj.username,_loginObj.password];
    
    [[DrHttpManager defaultManager] getRequestToUrl:requestUrl params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            FFLoginUser *user = [FFLoginUser objectWithKeyValues:response.payload[@"data"]];
            NSString *str = response.payload[@"data"][@"message"];
            if (str.length) [USSuspensionView showWithMessage:str];
            
            if ([user.status integerValue] == 1) {
                if (!_isLogin) {
                    [self clickSwitch];
                } else {
                    [AuthData loginSuccess:@{@"uid":user.uid,@"username":user.username,@"signCode":user.signCode}];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                
                if (_isLogin && !str.length) [USSuspensionView showWithMessage:@"账号密码不匹配"];
//                NSString *str = response.payload[@"data"][@"message"];
//                if (str.length) [USSuspensionView showWithMessage:str];
            }
        } else {
            if (_isLogin) [USSuspensionView showWithMessage:@"账号密码不匹配"];
        }
    }];
    

    if (_isLogin) {
        
    } else {
    }
//    [AuthData loginSuccess:@{@"uid":@"1",@"nickname":@"深刻觉得脚九分裤"}];
    

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
