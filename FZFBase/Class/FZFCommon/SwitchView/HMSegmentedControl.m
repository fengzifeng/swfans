//
//  HMSegmentedControl.m
//  HMSegmentedControlExample
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "HMSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

#define label_tag 15000

@interface HMSegmentedControl ()

@property (nonatomic, strong)    CALayer *selectedSegmentLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic, strong)    UIView *selectedBGView;//background color: selected

@end

@implementation HMSegmentedControl

- (id)initWithSectionTitles:(NSArray *)sectiontitles {
    
    if (self = [super init]) {
        self.sectionTitles = sectiontitles;
        [self setDefaults];
        [self creatLabels:self.sectionTitles];
    }
    
    return self;
}

- (void)setDefaults {
    
    self.font = [UIFont systemFontOfSize:18];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionIndicatorColor = HexColor(0x58ad52);
    
    self.selectedIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.height = 36.0f;
    self.selectionIndicatorHeight = 1.5f;
    if (IS_IPHONE_6P)
        self.selectionIndicatorHeight = 1.5f * WindowZoomScale;
    self.selectionIndicatorMode = HMSelectionIndicatorResizesToStringWidth;
    
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self.layer addSublayer:self.selectedSegmentLayer];
    [self addSubview:self.selectedBGView];
    
    if (self.sectionTitles){
        [self updateSegmentsRects];
    }
}

- (void)creatLabels:(NSArray *)titles{
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UILabel  *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = self.font;
        label.tag = label_tag + i;
        [self addSubview:label];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSInteger idx = 0; idx < self.sectionTitles.count; idx++) {
        
        NSString *titleString = self.sectionTitles[idx];
        CGFloat stringHeight = [titleString stringHeightWithFont:self.font width:SCREEN_WIDTH];
        CGFloat y = ((self.height - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - stringHeight / 2);
        //title
        CGRect titleRect = CGRectMake(self.segmentWidth * idx, y, self.segmentWidth, stringHeight);
        
        UILabel  *label = (UILabel *)[self viewWithTag:label_tag+idx];
        [label setFrame:titleRect];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:titleString];
        if (HMSelectionIndicatorIconAndTitle == self.selectionIndicatorMode) {
            label.textAlignment = NSTextAlignmentLeft;
        }else{
            label.textAlignment = NSTextAlignmentCenter;
        }
        if(idx == self.selectedIndex){
            label.textColor = self.selectionIndicatorColor;
        }else{
            label.textColor = self.textColor;
        }
        
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        self.selectedSegmentLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
        
        //selected BG view:
        if (idx == self.selectedIndex) {
            CGRect selectedBGRect = CGRectMake(self.selectedSegmentLayer.frame.origin.x, 0, self.segmentWidth, self.frame.size.height);
            [self.selectedBGView setFrame: selectedBGRect];
            [self insertSubview: self.selectedBGView atIndex: 0];
        }
        
    }
    
}


#pragma mark - init

- (CALayer *)selectedSegmentLayer{
    
    if (!_selectedSegmentLayer) {
        _selectedSegmentLayer = [CALayer layer];
    }
    return _selectedSegmentLayer;
}

- (UIView *)selectedBGView{
    
    if (!_selectedBGView) {
        _selectedBGView = [[UIView alloc] init];
        [_selectedBGView setBackgroundColor: [UIColor clearColor]];
    }
    return _selectedBGView;
}

#pragma mark - select

- (void)setSelectedIndex:(NSInteger)index {
    [self setSelectedIndex:index animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    
    if (animated){
        // Restore CALayer animations
        self.selectedSegmentLayer.actions = nil;
        
        __typeof (&*self) __weak weakSelf = self;
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        [CATransaction setCompletionBlock:^{
            if (weakSelf.superview)
                [weakSelf sendActionsForControlEvents:UIControlEventValueChanged];
            
            if (weakSelf.indexChangeBlock)
                weakSelf.indexChangeBlock(index);
        }];
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        
        //selected BG view:
        CGRect selectedBGRect = CGRectMake(self.selectedSegmentLayer.frame.origin.x, 0, self.segmentWidth, self.frame.size.height);
        //reset frame of selected BG view:
        [self.selectedBGView setFrame: selectedBGRect];
        
        [CATransaction commit];
    }
    else {
        // Disable CALayer animations
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.selectedSegmentLayer.actions = newActions;
        
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        CGRect selectedBGRect = CGRectMake(self.selectedSegmentLayer.frame.origin.x, 0, self.segmentWidth, self.frame.size.height);
        //reset frame of selected BG view:
        [self.selectedBGView setFrame: selectedBGRect];
        
        if (self.superview)
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        if (self.indexChangeBlock)
            self.indexChangeBlock(index);
        
        newActions = nil;
    }
    
    for(int i = 0; i<[self.sectionTitles count];i ++){
        
        UILabel   *label = (UILabel *)[self viewWithTag:label_tag + i];
        label.textColor = self.textColor;
        if(label && i == index){
            label.textColor = self.selectionIndicatorColor;
        }
    }
    
}


- (void)updateSegmentsRects {
    // If there's no frame set, calculate the width of the control based on the number of segments and their size
    if (CGRectIsEmpty(self.frame)) {
        self.segmentWidth = 0;
        
        for (NSString *titleString in self.sectionTitles) {
            CGFloat stringWidth = [titleString stringWidthWithFont:self.font height:30] + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }
        
        self.bounds = CGRectMake(0, 0, self.segmentWidth * self.sectionTitles.count, self.height);
    } else {
        self.segmentWidth = self.frame.size.width / self.sectionTitles.count;
        self.height = self.frame.size.height;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    [self updateSegmentsRects];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = touchLocation.x / self.segmentWidth;
        
        if (segment != self.selectedIndex) {
            [self setSelectedIndex:segment animated:YES];
        }
    }
}

- (CGRect)frameForSelectionIndicator {
    CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedIndex] stringWidthWithFont:self.font height:30];
    
    if (self.selectionIndicatorMode == HMSelectionIndicatorResizesToStringWidth) {
        CGFloat widthTillEndOfSelectedIndex = (self.segmentWidth * self.selectedIndex) + self.segmentWidth;
        CGFloat widthTillBeforeSelectedIndex = (self.segmentWidth * self.selectedIndex);
        
        CGFloat x = ((widthTillEndOfSelectedIndex - widthTillBeforeSelectedIndex) / 2) + (widthTillBeforeSelectedIndex - stringWidth / 2);
        return CGRectMake(x, self.frame.size.height - self.selectionIndicatorHeight, stringWidth, self.selectionIndicatorHeight);
    } else {
        return CGRectMake(self.segmentWidth * self.selectedIndex, self.frame.size.height - self.selectionIndicatorHeight, self.segmentWidth, self.selectionIndicatorHeight);
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    [self.backgroundColor set];
    UIRectFill([self bounds]);
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = 0.5f;
    [linePath moveToPoint:CGPointMake(0, self.frame.size.height-0.5)];
    [linePath  addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-0.5)];
    [HexColor(0xe1e1e1) setStroke];
    [linePath stroke];
    
}

@end
