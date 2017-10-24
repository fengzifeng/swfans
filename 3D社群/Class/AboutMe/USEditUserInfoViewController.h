//
//  USEditUserInfoViewController.h
//  USEvent
//
//  Created by FZF on 15/9/30.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "MCViewController.h"

@interface USEditUserInfoViewController : MCViewController<USImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) IBOutlet UITableView *tableView;

- (void)cancalKeyBoard;
- (void)createHeadView;

@end
