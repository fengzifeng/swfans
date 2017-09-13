//
//  MJRefreshUSHeader.m
//  USEvent
//
//  Created by marujun on 15/10/20.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "MJRefreshUSHeader.h"

@implementation MJRefreshUSHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 20; i++) {
        [idleImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"rotate_%02d.png",i]]];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [self setImages:@[[UIImage imageNamed:@"Indicator_0001.png"]] forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 42; i++) {
        [refreshingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Indicator_%04d.png",i]]];
    }
    for (int i = 42; i >= 1; i--) {
        [refreshingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Indicator_%04d.png",i]]];
    }
    for (int i = 0; i < 3; i++) {
        [refreshingImages addObject:[UIImage imageNamed:@"Indicator_0001.png"]];
    }
    [self setImages:refreshingImages duration:4.f forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    self.stateLabel.hidden = YES;
    
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    self.automaticallyChangeAlpha = YES;
}


@end
