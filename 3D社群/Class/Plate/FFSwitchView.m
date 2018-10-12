//
//  FFSwitchView.m
//  FZFBase
//
//  Created by 冯子丰 on 2017/8/22.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFSwitchView.h"

@interface FFSwitchView ()

@property (nonatomic, copy) choose choose;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation FFSwitchView

+ (instancetype)showSwitchView:(choose)choose
{
    float aa = 64;
    if (IS_IPHONE_X) aa = 88;
    FFSwitchView *view = [[FFSwitchView alloc] initWithFrame:CGRectMake(0, aa, SCREEN_WIDTH, 35)];
    view.choose = choose;
    view.btnArray = [NSMutableArray new];
    
    NSArray *titleArray = @[@"最新帖",@"热门",@"精华"];
//    NSArray *picArray = @[];
    for (int i = 0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [view.btnArray addObject:button];
        if (i == 0) button.selected = YES;
        button.frame = CGRectMake(i*SCREEN_WIDTH/3.0, 0, SCREEN_WIDTH/3.0, view.height);
        [button setTitleColor:HexColor(0xaa2d1b) forState:UIControlStateSelected];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button addTarget:view action:@selector(clickChoose:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:HexColor(0x838486) forState:UIControlStateNormal];
        button.tag = i;
        [view addSubview:button];
        if (i != 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.width - 0.5, button.height/4.0, 0.5, button.height/2.0)];
            label.backgroundColor = HexColor(0x838486);
            [button addSubview:label];
        }
    }
    
    return view;
}

- (void)clickChoose:(UIButton *)button
{
    if (button.tag == self.index) return;
    
    self.index = button.tag;
    for (UIButton *item in self.btnArray) {
        if (button == item) {
            item.selected = YES;
        } else {
            item.selected = NO;
        }
    }
    
    self.choose?self.choose(button.tag):nil;
}
@end
