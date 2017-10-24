//
//  FFActiveChooseView.m
//  swfans
//
//  Created by fengzifeng on 2017/9/22.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFActiveChooseView.h"

@interface FFActiveChooseView ()

@property (nonatomic, copy) choose choose;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FFActiveChooseView

+ (FFActiveChooseView *)showActiveChooseView:(NSArray *)dataArray choose:(choose)choose
{
    if ([KeyWindow viewWithTag:890]) return [KeyWindow viewWithTag:890];
    
    FFActiveChooseView *view = [[[NSBundle mainBundle] loadNibNamed:@"FFActiveChooseView" owner:self options:nil] firstObject];
    view.dataArray = dataArray;
    view.tag = 890;
    view.choose = choose;
    view.backgroundColor = RGBACOLOR(0, 0, 0, .5);
    [KeyWindow addSubview:view];
    [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = ((FFPlateItemModel *)_dataArray[indexPath.row]).oriName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _choose?_choose(_dataArray[indexPath.row]):nil;
    [self clickCancel:nil];

}

- (IBAction)clickCancel:(id)sender
{
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
