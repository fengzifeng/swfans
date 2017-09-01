//
//  MCFeedbackViewController.h
//  MCFriends
//
//  Created by fengzifeng on 14-8-19.
//  Copyright (c) 2014年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCFeedbackViewController : MCViewController
{
    __weak IBOutlet UIView *chatView;
    __weak IBOutlet UITextField *chatTextField;
    __weak IBOutlet UIButton *sendButton;
    
    __weak IBOutlet UITableView *_tableView;
}

- (IBAction)sendButtonAction:(UIButton *)sender;

@end
