//
//  MCHomeViewController.h
//  MCFriends
//
//  Created by fengzifeng on 14-3-16.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCHomeViewController : MCViewController <UIGestureRecognizerDelegate>
{
    __weak IBOutlet UILabel *_tabLineLabel;
    __weak IBOutlet UIImageView *unreadPlate;
    __weak IBOutlet UIImageView *unreadActive;

}


@property (strong, nonatomic) IBOutlet UIView *tabBarView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tabButtonCollection;

@property (nonatomic, strong) MCViewController *currentViewController;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)swithchTapIndex:(NSInteger)index;
- (IBAction)tabButtonAction:(UIButton *)sender;


@end
