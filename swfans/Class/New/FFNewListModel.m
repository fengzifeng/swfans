//
//  FFNewListModel.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/17.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFNewListModel.h"

@implementation FFNewListModel

- (NSDictionary *)objectClassInArray
{
    return @{@"data" : [FFNewListItemModel class]};
}

@end

@implementation FFNewListItemModel

- (void)setSubject:(NSString *)subject
{
    _subject = subject;
    
    CGFloat tempHeight = [_subject stringHeightWithFont:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH - 18] + 14;
    tempHeight = tempHeight > 30?tempHeight:30;
    self.height = tempHeight + 70;
}

@end
