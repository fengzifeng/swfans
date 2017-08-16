//
//  USEditUserInfoViewController.m
//  USEvent
//
//  Created by FZF on 15/9/30.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USEditUserInfoViewController.h"
#import "USAuthViewController.h"
#import "USEditUserInfoCell.h"
#import "USActionSheet.h"
#import "MCEditViewController.h"

@interface USEditUserInfoViewController ()
{
    UIButton *headButton;
    NSArray *_titleArray;
    BOOL _hasBind;
    UIView *headView;
    UIControl *contro;
    NSArray *tempArray;
}

@end

@implementation USEditUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人资料";
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    _tableView.contentInset = UIEdgeInsetsMake(_topInset, 0, 0, 0);
    
    _titleArray = @[@"昵称",@"性别", @"签名",@"手机号"];
    [self setNavigationBackButtonDefault];
    
    [self createHeadView];
    [self createFootView];
    
    headButton.layer.cornerRadius = 81/2.0;
    headButton.layer.masksToBounds = YES;
    headButton.backgroundColor = [UIColor yellowColor];
    headButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    headButton.clipsToBounds = YES;
    headButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    headButton.contentVerticalAlignment =  UIControlContentVerticalAlignmentFill;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)createFootView
{
    float viewHeight = SCREEN_HEIGHT-_topInset-(tempArray.count+2)*57-13-190-50-8;
    if (viewHeight<=0) {
        viewHeight = 7;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
    _tableView.tableFooterView = view;
}

- (void)cancalKeyBoard
{
    if (!contro) {
        contro = [[UIControl alloc] init];
        [self.view addSubview:contro];
        [contro addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
        [contro autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }else{
        contro.hidden = NO;
    }
}

- (void)click
{
    [self.view endEditing:YES];
    contro.hidden = YES;
}

- (void)createHeadView
{
    if (!headView) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    }
    
    if (!headButton) {
        headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    headButton.frame = CGRectMake((SCREEN_WIDTH-81)/2.0, 57, 81, 81);
    [headButton addTarget:self action:@selector(chooseHeadImage) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:headButton];
    
    _tableView.tableHeaderView = headView;
}

- (void)chooseHeadImage
{
    if (![HLTool photoAlbumGranted]) {
        return;
    }
    
    USImagePickerController *pickerViewController = [[USImagePickerController alloc] init];
    pickerViewController.delegate = self;
    pickerViewController.allowsEditing = YES;
    
    [self presentViewController:pickerViewController animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"USEditUserInfoCell";
    USEditUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    
    [cell updateCell:_titleArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 ||indexPath.row == 2) {
        MCEditViewController *editVC = [[MCEditViewController alloc] initWithNibName:@"MCEditViewController" bundle:nil];
        editVC.title = _titleArray[indexPath.row];
//        editVC.dataTag = [dictIndex[text] intValue];
        [self.navigationController pushViewController:editVC animated:YES];
    } else if (indexPath.row == 1) {
        USActionSheet *sheet = [USActionSheet initWithOtherButtonTitles:@"男",@"女" ,nil];
        [sheet showWithCompletionBlock:^(NSInteger buttonIndex) {
            
            GENDER tempGender =  _loginUser.gender;
            if (buttonIndex == 1) {
                tempGender = GENDER_WOMEN;
            }else if (buttonIndex == 0){
                tempGender = GENDER_MAN;
            }
            
            if (tempGender == _loginUser.gender) {
                return ;
            }
            
            _loginUser.gender = tempGender;
            [_loginUser synchronize];
            
        }];


    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
    }
}


#pragma mark -imagePicker delegate
- (void)imagePickerController:(USImagePickerController *)picker didFinishPickingMediaWithImage:(UIImage *)mediaImage
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        UIImage *userHeadImage = mediaImage;
        [headButton setImage:userHeadImage forState:UIControlStateNormal];
    }];
}

#pragma mark 取消选择图片
- (void)imagePickerControllerDidCancel:(USImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
