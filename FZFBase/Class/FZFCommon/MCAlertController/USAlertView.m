//
//  USAlertView.m
//  USEvent
//
//  Created by marujun on 15/10/23.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USAlertView.h"

@interface USAlertView ()
{
    UILabel *_bgView;
}

@property (nonatomic, copy) void (^completeBlock)(NSInteger buttonIndex);
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation USAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor =  [UIColor clearColor];
    _bgView = [[UILabel alloc] initForAutoLayout];
    _bgView.userInteractionEnabled = YES;
    _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    [self addSubview:_bgView];
    [_bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    _contentView = [[UIView alloc] initForAutoLayout];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;

    [_contentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_contentView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    _viewArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc] initForAutoLayout];
        [_viewArray addObject:view];
    }
    
    _titleLabel = [[UILabel alloc] initForAutoLayout];
    _titleLabel.textAlignment = NSTextAlignmentCenter;

    _messageLabel = [[UILabel alloc] initForAutoLayout];
    _messageLabel.numberOfLines = 2;
    
    if (IS_IPHONE_6P) {
        [_contentView autoSetDimensionsToSize:CGSizeMake(296, 197)];
        _messageLabel.font = kFont_15;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];

    }else{
        [_contentView autoSetDimensionsToSize:CGSizeMake(229*WindowZoomScale, 152*WindowZoomScale)];
        _messageLabel.font = kFont_13;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];

    }
    
    _btnView = [[UIView alloc] initForAutoLayout];
    
}

+ (instancetype)showWithMessage:(NSString *)message
{
    USAlertView *alertView = [self initWithTitle:nil message:message cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView showWithCompletionBlock:nil];

    return alertView;
}

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message
{
    USAlertView *alertView = [self initWithTitle:title message:message cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView showWithCompletionBlock:nil];
    
    return alertView;
}


+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
}

+ (instancetype)initWithMessage:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherTitleArray = [NSMutableArray array];
    va_list _arguments;
    va_start(_arguments, otherButtonTitles);
    for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
        [otherTitleArray addObject:key];
    }
    va_end(_arguments);
    
    return [self initWithTitle:nil message:message cancelButtonTitle:cancelButtonTitle otherButtonTitleArray:otherTitleArray];
}

+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherTitleArray = [NSMutableArray array];
    va_list _arguments;
    va_start(_arguments, otherButtonTitles);
    for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
        [otherTitleArray addObject:key];
    }
    va_end(_arguments);
    
    return [self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitleArray:otherTitleArray];
}

+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitleArray:(NSArray *)otherButtonTitleArray
{
    USAlertView *alerView = [[USAlertView alloc] init];
    UIView *titleBgView = ((UIView *)alerView.viewArray[0]);
    UIView *messageBgView = ((UIView *)alerView.viewArray[1]);
    UIView *btnBgView = ((UIView *)alerView.viewArray[2]);
        
    [alerView.contentView addSubview:titleBgView];
    [alerView.contentView addSubview:messageBgView];
    [alerView.contentView addSubview:btnBgView];
    
    [titleBgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [titleBgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:messageBgView withOffset:0];
    [messageBgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:btnBgView withOffset:0];

    [btnBgView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    [titleBgView addSubview:alerView.titleLabel];
    float contrast = 25*WindowZoomScale;
    if (IS_IPHONE_6P) {
        contrast = 34;
    }
    [titleBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:contrast];
    [titleBgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:contrast];

    [alerView.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [alerView.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [alerView.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [alerView.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//    [alerView.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [alerView.titleLabel autoSetDimension:ALDimensionHeight toSize:20];
    alerView.titleLabel.text = title;
    
    [messageBgView addSubview:alerView.messageLabel];
    [messageBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:contrast];
    [messageBgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:contrast];

    [alerView.messageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [alerView.messageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [alerView.messageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [alerView.messageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    [btnBgView addSubview:alerView.btnView];
    [btnBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [btnBgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];

    [alerView.btnView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [alerView.btnView autoAlignAxisToSuperviewAxis:ALAxisVertical];

    if (message) {
        float tempWidth = 229*WindowZoomScale - 25*WindowZoomScale*2;
        if (IS_IPHONE_6P) {
            tempWidth = 296 - 34*2;
        }

        float messHeight = [message stringHeightWithFont:IS_IPHONE_6P?kFont_15:kFont_13 width:tempWidth];
        float messageHeight = 25;
        float contrast1;
        float contrast2;

        if (title&&title.length) {
            if (messHeight < messageHeight) {
                if (IS_IPHONE_6P) {
                    contrast1 = -10;
                    contrast2 = 26;

                    [alerView.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal withOffset:-21];
                    [alerView.messageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal withOffset:18];
                }else{
                    contrast1 = 4*WindowZoomScale;
                    contrast2 = 14*WindowZoomScale;

                    [alerView.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal withOffset:-16*WindowZoomScale];
                    [alerView.messageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal withOffset:16*WindowZoomScale];
                }

                [titleBgView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:messageBgView withOffset:contrast1];
                [messageBgView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:btnBgView withOffset:contrast2];
            }else{
                messHeight = 40;
                
                if (IS_IPHONE_6P) {
                    contrast1 = -5;
                    contrast2 = 26;
                    [alerView.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal withOffset:-16];
                    [alerView.messageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal withOffset:16];
                    
                }else{
                    contrast1 = -12*WindowZoomScale;
                    contrast2 = 22*WindowZoomScale;
                    [alerView.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal withOffset:-13*WindowZoomScale];
                    [alerView.messageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal withOffset:12*WindowZoomScale];
                    
                }

                [titleBgView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:messageBgView withOffset:contrast1];
                [messageBgView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:btnBgView withOffset:contrast2];
            }
        }
        else {
            if (messHeight < messageHeight) {
                if (IS_IPHONE_6P) {
                    contrast1 = -84;
                    contrast2 = 39;
                    [alerView.contentView autoSetDimensionsToSize:CGSizeMake(296, 147)];

                }else{
                    contrast1 = -62*WindowZoomScale;
                    contrast2 = 27*WindowZoomScale;
                    [alerView.contentView autoSetDimensionsToSize:CGSizeMake(229*WindowZoomScale, 112*WindowZoomScale)];
                }
                
                [titleBgView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:messageBgView withOffset:contrast1];
                [messageBgView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:btnBgView withOffset:contrast2];
            }else{
                messHeight = 40;
                if (IS_IPHONE_6P) {
                    contrast1 = -114;
                    contrast2 = 66;
                    [alerView.contentView autoSetDimensionsToSize:CGSizeMake(296, 170)];

                }else{
                    contrast1 = -80*WindowZoomScale;
                    contrast2 = 45*WindowZoomScale;
                    [alerView.contentView autoSetDimensionsToSize:CGSizeMake(229*WindowZoomScale, 132*WindowZoomScale)];
                }
                
                [titleBgView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:messageBgView withOffset:contrast1];
                [messageBgView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:btnBgView withOffset:contrast2];

            }
        }
        
        NSMutableAttributedString *messAttr = [[NSMutableAttributedString alloc] initWithString:message];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        if (title) {
            
            if (IS_IPHONE_6P) {
                style.lineSpacing = 4;//行距
            }else{
                style.lineSpacing = 2*WindowZoomScale;//行距
            }
        }else{
            if (IS_IPHONE_6P) {
                style.lineSpacing = 6;//行距
            }else{
                style.lineSpacing = 4*WindowZoomScale;//行距
            }

        }
        style.alignment = NSTextAlignmentCenter;
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        [alerView.messageLabel autoSetDimension:ALDimensionHeight toSize:messHeight+4];
        [messAttr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, message.length)];
        
        alerView.messageLabel.attributedText = messAttr;
    }
    
    
    NSMutableArray *dataSource = [otherButtonTitleArray mutableCopy];
    if (!cancelButtonTitle||!cancelButtonTitle.length) {
        cancelButtonTitle = @"取消";
    }
    [dataSource insertObject:cancelButtonTitle atIndex:0];
    [alerView.btnView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [alerView.btnView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
 
    if (IS_IPHONE_6P) {
        [alerView.btnView autoSetDimension:ALDimensionHeight toSize:52];
    }else{
        [alerView.btnView autoSetDimension:ALDimensionHeight toSize:40*WindowZoomScale];
    }
    
    [alerView createButton:dataSource];

    return alerView;
}

- (void)createButton:(NSArray *)dataSource
{
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<dataSource.count; i++) {
        UIView *view = [[UIView alloc] initForAutoLayout];
        [self.btnView addSubview:view];
        
        NSString *btnStr = dataSource[dataSource.count-i-1];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = dataSource.count-i;
        [button addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:KY_TINT_COLOR forState:UIControlStateNormal];
        if (IS_IPHONE_6P) {
            button.titleLabel.font = kFont_15;
        }else{
            button.titleLabel.font = kFont_13;
        }
        [button setTitle:btnStr forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeColor:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(exchangeColor:) forControlEvents:UIControlEventTouchDown];

        [view addSubview:button];
        [button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        if (i != 0&&dataSource.count > 1) {
            UILabel *label = [[UILabel alloc] initForAutoLayout];
            [view addSubview:label];
            [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
            [label autoSetDimension:ALDimensionWidth toSize:0.5];
            label.backgroundColor = [UIColor blackColor];
            
        }

        [viewArray addObject:view];
    }
    
    for (int i = 0;i<viewArray.count;i++) {
        
        [viewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [viewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        if (i<viewArray.count-1) {
            [viewArray[i] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:viewArray[i+1]];
        }
    }
    
    [viewArray[0] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [viewArray[viewArray.count-1] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    
    if (viewArray.count>1) {
        [viewArray autoMatchViewsDimension:ALDimensionWidth];
    }
    
    UILabel *lineLabel = [[UILabel alloc] initForAutoLayout];
    lineLabel.backgroundColor = [UIColor blackColor];
    float bottom = 40*WindowZoomScale;
    if (IS_IPHONE_6P) {
        bottom = 52;
    }
    [self.btnView addSubview:lineLabel];
    [self.btnView bringSubviewToFront:lineLabel];
    [lineLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [lineLabel autoSetDimension:ALDimensionHeight toSize:0.5];
}

- (void)exchangeColor:(UIButton *)button{
    if (button.highlighted) {
        button.backgroundColor = HexColor(0xededed);
        [button setTitleColor:HexColor(0xe29a1d) forState:UIControlStateNormal];
//        button.layer.borderWidth = 1 ;
//        button.layer.borderColor = KY_TINT_COLOR.CGColor ;
    }
}

- (void)removeColor:(UIButton *)button{
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:KY_TINT_COLOR forState:UIControlStateNormal];
}

- (void)clickbtn:(UIButton *)button
{
    [self clickedIndex:button.tag-1];
}

- (void)clickedIndex:(NSInteger)index{
    _completeBlock?_completeBlock(index):nil;
    
    [UIView animateWithDuration:.25 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(.1, .1);
        _bgView.backgroundColor =  [UIColor clearColor];
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        _completeBlock = nil;
        [self removeFromSuperview];
    }];
}

- (void)showWithCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock
{
    _completeBlock = completionBlock;

    [[UIApplication topMostWindow] addSubview:self];
    [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.contentView.transform = CGAffineTransformMakeScale(.1, .1);
    _bgView.alpha = 0;
    self.contentView.alpha =  0.5;
    
    [UIView animateWithDuration:.25 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        self.contentView.alpha = 1;
        _bgView.alpha = 1;
    }];
}

- (void)dealloc
{
    DLOG(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
