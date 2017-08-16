//
//  MCHomeViewController.h
//  MCFriends
//
//  Created by 马汝军 on 14-3-16.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCHomeViewController : MCViewController <UIGestureRecognizerDelegate>
{
    __weak IBOutlet UILabel *_tabLineLabel;
}


@property (strong, nonatomic) IBOutlet UIView *tabBarView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tabButtonCollection;

@property (nonatomic, strong) MCViewController *currentViewController;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)swithchTapIndex:(NSInteger)index;
- (IBAction)tabButtonAction:(UIButton *)sender;


@end
