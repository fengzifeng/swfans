//
//  FFLoginCell.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/24.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface FFLoginCell : UITableViewCell

{
    IBOutlet UITextField *_textFild;
    IBOutlet UILabel *_lineLabel;
}

@property (nonatomic, strong) FFLoginUser *loginObj;

- (void)updateCell:(NSString *)titleStr;

@end
