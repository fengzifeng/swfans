//
//  MCSettingViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCSettingViewController.h"

@interface MCSettingViewController ()
{
    NSArray *_dataSource;

}
@end

@implementation MCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBackButtonDefault];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:_topInset];
    
    _dataSource = @[@"意见反馈",@"清除缓存",@"关于我们"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SettingTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = kFont_13;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = RGBCOLOR(68, 68, 68);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UILabel *downLine = [[UILabel alloc] init];
        downLine.backgroundColor = RGBCOLOR(200 , 199, 204);
        [cell.contentView addSubview:downLine];
        
        CGSize size = cell.bounds.size;
//        size.width  = SCREEN_WIDTH;
        downLine.frame = CGRectMake(0, size.height-0.5, size.width, 0.5);
        [cell.contentView bringSubviewToFront:downLine];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
//        MCFeedbackViewController *vc = [MCFeedbackViewController viewController];
//        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 1) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDate *date = [NSDate date];
//            float cacheSize = [NSFileManager folderSizeAtPath:[UIImage diskCacheDirectory]];
//            DLOG(@"统计文件夹大小：%.2fM   耗时：%.4f秒",cacheSize,[[NSDate date] timeIntervalSinceDate:date]);
//            
//            [userDefaults setObject:@(cacheSize) forKey:UserDefaultKey_imageCacheSize];
//            [userDefaults synchronize];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *desc = [NSString stringWithFormat:@"缓存文件大小：%.2fM",cacheSize];
////                [TCLoadingView removeLoadingView];
//                
//                USAlertView *alert = [USAlertView initWithMessage:desc cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
//                [alert showWithCompletionBlock: ^(NSInteger buttonIndex) {
//                    if (buttonIndex == 1) {
////                        [TCLoadingView showWithRequestClass:self text:@"正在清理…"];
//                        
//                        //清理内存中的缓存图片
//                        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:nil];
//                        
//                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                            
//                            NSFileManager *fileManger = [NSFileManager defaultManager];
//                            [fileManger removeItemAtPath:[UIImage diskCacheDirectory] error:nil];
//                            [[NSURLCache sharedURLCache] removeAllCachedResponses];
//                            
//                            dispatch_main_after(0.3, ^{
//                                [userDefaults setObject:@(0) forKey:UserDefaultKey_imageCacheSize];
//                                [userDefaults synchronize];
//                                
////                                [TCLoadingView removeLoadingView];
//                            });
//                        });
//                    }
//                }];
//            });
        });
    } else if (indexPath.row == 2) {
    }

}

@end
