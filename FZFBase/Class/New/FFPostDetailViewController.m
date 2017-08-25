//
//  FFPostDetailViewController.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/25.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPostDetailViewController.h"
#import "FFPostDetailCell.h"

@interface FFPostDetailViewController ()

@end

@implementation FFPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBackButtonDefault];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FFPostDetailCell";
    FFPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell updateCell];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FFPostDetailCell getCellHeight];

}


@end
