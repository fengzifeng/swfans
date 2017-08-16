//
//  MJRefreshUSFooter.m
//  USEvent
//
//  Created by jansti on 15/12/10.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "MJRefreshUSFooter.h"

@interface MJRefreshUSFooter()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) UILabel *pointsLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UIImageView *bottomLineImageV;

@end

@implementation MJRefreshUSFooter

- (UIImageView *)bottomLineImageV
{
    if (_bottomLineImageV == nil) {
        UIImageView *tempImageView = [[UIImageView alloc] init];
        tempImageView.image = [UIImage imageNamed:@"dynamic_dash_line"];
        [self addSubview:tempImageView];
        _bottomLineImageV = tempImageView;
    }
    
    return _bottomLineImageV;
}



- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeLabelText) userInfo:nil repeats:YES];
        self.pointsLabel.text = @"...";
        _index = 2;
    }
    return _timer;
}

- (UILabel *)pointsLabel
{
    if (_pointsLabel == nil) {
        UILabel *pointsLabel = [[UILabel alloc]init];
        [pointsLabel setFont:[UIFont boldSystemFontOfSize:12]];
        pointsLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:pointsLabel];
        self.pointsLabel = pointsLabel;
    }
    return _pointsLabel;
}

- (void)changeLabelText
{
    _index = ++_index % 3;
    switch (_index) {
        case 0:
            self.pointsLabel.text = @".";
            break;
        case 1:
            self.pointsLabel.text = @"..";
            break;
        case 2:
            self.pointsLabel.text = @"...";
            break;
        default:
            break;
    }
}

- (void)placeSubviews
{
    [super placeSubviews];
    NSString *refreshStr = self.stateTitles[@(MJRefreshStateRefreshing)];
    CGFloat width = [refreshStr stringWidthWithFont:[UIFont boldSystemFontOfSize:12] height:CGFLOAT_MAX];
    self.pointsLabel.left = SCREEN_WIDTH * 0.5 + width * 0.5 ;
    self.pointsLabel.width = SCREEN_WIDTH - self.pointsLabel.left;
    self.pointsLabel.height = self.height;
    self.pointsLabel.top = 0;
    
//    self.bottomLineImageV.height = 0.5;
//    self.bottomLineImageV.left = 0;
//    self.bottomLineImageV.top = self.height - 1;
//    self.bottomLineImageV.width = SCREEN_WIDTH;
    
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil && _timer) {
        [_timer invalidate];
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (self.isRefreshingTitleHidden && state == MJRefreshStateRefreshing) {
        self.stateLabel.text = nil;
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        self.pointsLabel.hidden = YES;
    } else if ( !self.isRefreshingTitleHidden && state == MJRefreshStateRefreshing){
        self.pointsLabel.hidden = NO;
        [self timer];
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        self.pointsLabel.hidden = YES;
    }
}


@end
