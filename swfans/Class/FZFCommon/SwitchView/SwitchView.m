//
//  DrGroupsControlView.m
//  DrSubjectScrollVC
//
//  Created by ffengzifeng on 16/5/17.
//  Copyright (c) 2015年 feng. All rights reserved.
//

#import "SwitchView.h"

#define ITEM_SPACE 25.f
#define ITEM_MARGIN 10.f

@implementation SwitchConfig

-(id)init
{
    self = [super init];
    if(self){
        
        _itemFont = [UIFont systemFontOfSize:14.f];
        _textColor = HexColor(0x565656);
        _selectedColor = HexColor(0x6bbd3d);
        _lineHieght = 1.5f;
        _tapAnimation = YES;
    }
    return self;
}

@end

@interface SwitchView ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIView *line;
@property(nonatomic, strong) UIImageView *leftView;
@property(nonatomic, strong) UIImageView *rightView;

@end

@implementation SwitchView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.itemScroll];
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
     }
    
    return self;
}

- (UIScrollView *)itemScroll{

    if (!_itemScroll) {
        _itemScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(ITEM_MARGIN, 0, self.frame.size.width - ITEM_MARGIN*2, self.frame.size.height)];
        _itemScroll.showsHorizontalScrollIndicator = NO;
        _itemScroll.showsVerticalScrollIndicator = NO;
        _itemScroll.scrollsToTop = NO;
        _itemScroll.delegate = self;
    }
    return _itemScroll;
}

-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    if(!_config) _config = [[SwitchConfig alloc]init];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat height = self.itemScroll.frame.size.height-0.5;
    
    for (int i=0; i<titleArray.count; i++) {
        
        CGFloat width = [_titleArray[i] stringWidthWithFont:kFont_16 height:20]+4;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
        btn.tag = 100+i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_config.textColor forState:UIControlStateNormal];
        btn.titleLabel.font = _config.itemFont;
        [btn addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemScroll addSubview:btn];
        
        x = CGRectGetMaxX(btn.frame)+ITEM_SPACE;
        
        if(i==0){
            
            [btn setTitleColor:_config.selectedColor forState:UIControlStateNormal];
            _currentIndex = 0;
            
            CGFloat lineWith = [_titleArray[i] stringWidthWithFont:kFont_16 height:20]+4;
            self.line = [[UIView alloc] initWithFrame:CGRectMake(0, height - _config.lineHieght, lineWith, _config.lineHieght)];
            self.line.center = CGPointMake(btn.center.x, self.line.center.y);
            _line.backgroundColor = _config.selectedColor;
            
            [self.itemScroll addSubview:_line];
        }
    }
    
    self.itemScroll.contentSize = CGSizeMake(x-ITEM_SPACE, height);
    
        self.leftView.hidden = YES;
    if (self.itemScroll.contentSize.width > SCREEN_WIDTH) {
        self.rightView.hidden = NO;
    }else{
        self.rightView.hidden = YES;
    }
}

#pragma mark - 

- (UIImageView *)leftView{

    if (!_leftView) {
        _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 5, self.frame.size.height)];
        _leftView.image = [UIImage imageNamed:@"cutoff_left"];
    }
    return _leftView;
}

- (UIImageView *)rightView{
    
    if (!_rightView) {
        _rightView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.itemScroll.frame), 0, 5, self.frame.size.height)];
        _rightView.image = [UIImage imageNamed:@"cutoff_right"];
    }
    return _rightView;
}

#pragma mark - 点击事件

-(void)itemButtonClicked:(UIButton*)btn
{
    //接入外部效果
    _currentIndex = btn.tag-100;
    
    if(_config.tapAnimation){
        
        //有动画，由call is scrollView 带动线条，改变颜色
        
    }else{
        //没有动画，需要手动瞬移线条，改变颜色
        [self changeItemColor:_currentIndex];
        [self changeLine:_currentIndex];
    }
    
    [self changeScrollOfSet:_currentIndex];
    [self endMoveToIndex:_currentIndex];

    if(self.tapItemWithIndex) _tapItemWithIndex(_currentIndex,_config.tapAnimation);
}


#pragma mark - Methods

//改变文字焦点
-(void)changeItemColor:(NSInteger)index
{
    for (int i=0; i<_titleArray.count; i++) {
        
        UIButton *btn = (UIButton*)[self viewWithTag:i+100];
        [btn setTitleColor:_config.textColor forState:UIControlStateNormal];
        if(btn.tag == index+100){
            [btn setTitleColor:_config.selectedColor forState:UIControlStateNormal];
        }
    }
}

//改变线条位置
-(void)changeLine:(NSInteger)index
{
    
    UIButton *btn = (UIButton*)[self viewWithTag:index+100];
    CGRect rect = _line.frame;
    rect.size.width = [_titleArray[index] stringWidthWithFont:kFont_16 height:20] + 4;
    CGPoint center = _line.center;
    
    [UIView animateWithDuration:0.25 animations:^{
        _line.frame = rect;
        _line.center = CGPointMake(btn.center.x, center.y);
    }];
}


//向上取整
- (NSInteger)changeProgressToInteger:(NSInteger)x
{
    
    CGFloat max = _titleArray.count;
    CGFloat min = 0;
    
    NSInteger index = 0;
    
    if(x< min+0.5){
        index = min;
        
    }else if(x >= max-0.5){
        index = max;
        
    }else{
        index = (x+0.5)/1;
    }
    
    return index;
}


//移动ScrollView
-(void)changeScrollOfSet:(NSInteger)index
{
    
    if (index == 0 || index == 1) {
        if (index == 0) {
        }else{
        }
    }

    UIButton *btn = (UIButton*)[self viewWithTag:index+100];
    
    CGFloat  halfWidth = CGRectGetWidth(self.itemScroll.frame)/2.0;
    CGFloat  scrollContentWidth = self.itemScroll.contentSize.width;
    
    CGFloat leftSpace = btn.frame.origin.x - halfWidth + btn.frame.size.width/2.0;
    
    if(leftSpace<= 0){
        leftSpace = 0;
        self.leftView.hidden = YES;
        if (self.itemScroll.contentSize.width > SCREEN_WIDTH) {
            self.rightView.hidden = NO;
        }else{
            self.rightView.hidden = YES;
        }
        
    } else if(leftSpace >= scrollContentWidth- 2*halfWidth){
        leftSpace = scrollContentWidth-2*halfWidth;
        self.rightView.hidden = YES;
        if (self.itemScroll.contentSize.width > SCREEN_WIDTH) {
            self.leftView.hidden = NO;
        }else{
            self.leftView.hidden = YES;
        }
        
    }else {
        if (self.itemScroll.contentSize.width > SCREEN_WIDTH) {
            self.leftView.hidden = NO;
            self.rightView.hidden = NO;
        }else{
            self.leftView.hidden = YES;
            self.rightView.hidden = YES;
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.itemScroll setContentOffset:CGPointMake(leftSpace, 0) animated:NO];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 在ScrollViewDelegate中回调
-(void)moveToIndex:(NSInteger)x
{
    [self changeLine:x];
    NSInteger tempIndex = [self changeProgressToInteger:x];
    if(tempIndex != _currentIndex){
        //保证在一个item内滑动，只执行一次
        [self changeItemColor:tempIndex];
    }
    _currentIndex = tempIndex;
}

-(void)endMoveToIndex:(NSInteger)x
{
    [self changeLine:x];
    [self changeItemColor:x];
    _currentIndex = x;
    
    [self changeScrollOfSet:x];
}

- (void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    UIBezierPath *line = [UIBezierPath bezierPath];
    line.lineWidth = 0.5f;
    [line moveToPoint:CGPointMake(0, self.frame.size.height-1)];
    [line addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - 0.5f)];
    [HexColor(0xe1e1e1) setStroke];
    [line stroke];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.itemScroll) {
        
        if (scrollView.contentOffset.x <= 0) {
            
            self.leftView.hidden = YES;
            
        } else if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)) {
            
            self.rightView.hidden = YES;
        }else{
            
            self.leftView.hidden = NO;
            self.rightView.hidden = NO;
        }
    }
}

@end
