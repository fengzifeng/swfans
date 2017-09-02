//
//  FFPostModel.m
//  swfans
//
//  Created by fengzifeng on 2017/9/2.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPostModel.h"
#import "ZYPAttributeLabel.h"

@implementation FFPostModel

- (NSDictionary *)objectClassInArray
{
    return @{@"data" : [FFPostItemModel class]};
}

@end

@implementation FFPostItemModel

- (void)setSubject:(NSString *)subject
{
    _subject = subject;    
    
    if (_subject.length) {
        self.isComment = NO;
    } else {
        self.isComment = YES;
    }
    
    if (self.message.length) {
        CGFloat height = 70;
        ZYPAttributeLabel *label = [[ZYPAttributeLabel alloc] init];
        label.isHtml = YES;
        CGSize size;
        size = [label sizeWithWidth:SCREEN_WIDTH - 20 attstr:self.message textFont:[UIFont systemFontOfSize:14]];
        self.contentHeight = size.height;
        if (self.isComment) {
            height += size.height + 12;
        } else {
            height += size.height + 52;
        }
        
        self.height = height;
    }
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    
    if (self.message.length) {
        CGFloat height = 70;
        ZYPAttributeLabel *label = [[ZYPAttributeLabel alloc] init];
        label.isHtml = YES;
        CGSize size;
        size = [label sizeWithWidth:SCREEN_WIDTH - 20 attstr:self.message textFont:[UIFont systemFontOfSize:14]];
        self.contentHeight = size.height;
        if (self.isComment) {
            height += size.height + 12;
        } else {
            height += size.height + 52;
        }
        
        self.height = height;
    }

}


@end
