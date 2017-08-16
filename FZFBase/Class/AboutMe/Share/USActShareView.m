//
//  USActShareView.m
//  USEvent
//
//  Created by FZF on 15/9/24.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USActShareView.h"
#import "USAuthViewController.h"

@interface USActShareView()

{
    IBOutletCollection(UIView) NSArray *_shareViewArray;
    IBOutletCollection(UIButton) NSArray *_shareBtnArray;
    IBOutlet UIView *_shareBgViewUp;
    IBOutlet UIView *_shareBgViewDown;
    IBOutlet UILabel *_titleLabel;
    
    IBOutlet UIView *_shareBgView;
    
    UIView *_bgView;
    NSMutableArray *_shareResViewArray;
    NSLayoutConstraint *_bgViewBottomConstraint;
}


@property (assign, nonatomic) CGFloat totalHeight;


@end


@implementation USActShareView


+ (void)showShareApp
{
    USActShareView * shareView = [self actShareViewWithDelegate:nil withIsShare:YES];
    
    [shareView show];
}

+ (instancetype)actShareViewWithDelegate:(id)delegate withIsShare:(BOOL)isShare
{
    USActShareView * shareView = [[[NSBundle mainBundle] loadNibNamed:@"USActShareView" owner:self options:nil] firstObject];
    return shareView;
}

- (void)awakeFromNib
{
    _shareResViewArray = [NSMutableArray new];
    
    UIControl *contro = [[UIControl alloc] init];
    [self insertSubview:contro atIndex:0];
    [contro addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    [contro autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
    for (UIButton *shareBtn in _shareBtnArray) {
        shareBtn.layer.cornerRadius = 5;
        shareBtn.layer.masksToBounds = YES;
    }
    
    _bgView = [[UIView alloc]initForAutoLayout];
    _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    [self insertSubview:_bgView atIndex:0];
    [_bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)click
{
    [UIView animateWithDuration:KeyboardAnimationDuration delay:0.f options:KeyboardAnimationCurve animations:^{
        _bgView.alpha = 0.0;
        _bgViewBottomConstraint.constant = -_totalHeight;
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)show
{
//    [KeyWindow addSubview:self];
    [_applicationContext.rootViewController.view addSubview:self];
    
    [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self layoutShareView];
    [self layoutIfNeeded];
    
    _bgView.alpha = 0.0;
    [UIView animateWithDuration:KeyboardAnimationDuration delay:0.f options:KeyboardAnimationCurve animations:^{
        _bgViewBottomConstraint.constant = 0;
        _bgView.alpha = 1;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)layoutShareView
{
    [_shareViewArray[4] removeFromSuperview];
    [_shareViewArray[5] removeFromSuperview];
    [_shareViewArray[6] removeFromSuperview];

    
    for (int i = 0 ; i<_shareViewArray.count ; i++) {
        if (i == 5 || i == 6 || i == 4) {
            continue;
        }

        [_shareResViewArray addObject:_shareViewArray[i]];
    }
    
    [self layoutAuthSubview];
}

//适配各种情况
- (void)layoutAuthSubview
{
    if (_shareResViewArray.count < 5) {
        _bgViewBottomConstraint = [_shareBgView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-123];

        [_shareBgViewDown autoSetDimension:ALDimensionHeight toSize:0];
        [_shareBgViewDown autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shareBgViewUp withOffset:0];
        [_shareBgView autoSetDimension:ALDimensionHeight toSize:123];

    }
    else {
        _bgViewBottomConstraint = [_shareBgView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:330];

        [_shareBgView autoSetDimension:ALDimensionHeight toSize:-330];
    }
    
    _totalHeight = -_bgViewBottomConstraint.constant;
    
    for (int i = 0;i<_shareResViewArray.count;i++) {
        [_shareResViewArray[i] removeFromSuperview];
        UIView *view = _shareResViewArray[i];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        
        if (i < 4) {
            [_shareBgViewUp addSubview :view];
            
        }
        else {
            [_shareBgViewDown addSubview :_shareResViewArray[i]];
        }
    }
    
    for (int i = 0;i < _shareResViewArray.count;i++) {
        if (i < 4) {
            [_shareResViewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
            [_shareResViewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
            if ((i < 3) && (i < _shareResViewArray.count - 1)) {
                [_shareResViewArray[i] autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_shareResViewArray[i + 1]];
            }
            [_shareResViewArray[0] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        }
        else {
            [_shareResViewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
            [_shareResViewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
            
            if (i<_shareResViewArray.count-1) {
                [_shareResViewArray[i] autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_shareResViewArray[i+1]];
            }
            
            if (i == 4) {
                [_shareResViewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
                
            }
        }
        
        [_shareResViewArray autoSetViewsDimension:ALDimensionWidth toSize:(SCREEN_WIDTH - 28) / 4.0];
        
    }
    
    [_shareBgViewUp layoutIfNeeded];
    
    [_shareBgViewDown layoutIfNeeded];
    
}


- (IBAction)qqShareClick:(id)sender
{
    
 
}

- (IBAction)weiXinShareClick:(id)sender
{
}

- (IBAction)weiXinFrindShareClick:(id)sender
{
}

- (IBAction)weiBoShareClick:(id)sender
{
}


- (IBAction)zoneShareClick:(id)sender
{
}


@end
