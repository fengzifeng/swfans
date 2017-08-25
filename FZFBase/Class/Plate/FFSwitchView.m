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
@end

@implementation FFSwitchView

+ (instancetype)showSwitchView:(choose)choose
{
    
    FFSwitchView *view = [[FFSwitchView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 35)];
    view.choose = choose;
    NSArray *titleArray = @[@"最新帖",@"热门",@"精华"];
//    NSArray *picArray = @[];
    for (int i = 0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*SCREEN_WIDTH/3.0, 0, SCREEN_WIDTH/3.0, view.height);
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
    self.choose?self.choose(button.tag):nil;
}
@end
