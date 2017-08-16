//
//  DrGroupsControlView.h
//  DrSubjectScrollVC
//
//  Created by fengzifeng on 16/5/17.
//  Copyright (c) 2016年 chēng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchConfig : NSObject

@property(nonatomic,strong)UIFont *itemFont;       //default is 16
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,strong)UIColor *selectedColor;
@property(nonatomic,assign)CGFloat lineHieght;
@property(nonatomic,assign)BOOL tapAnimation;//default is YES;

@end

typedef void (^DrGroupsControlViewTapBlock)(NSInteger index, BOOL animation);


@interface SwitchView : UIView

@property(nonatomic,strong)   UIScrollView   *itemScroll;
@property(nonatomic,strong)   SwitchConfig *config;
@property(nonatomic,strong)   NSArray        *titleArray;
@property(nonatomic,readonly) NSInteger      currentIndex;
@property(nonatomic,copy)     DrGroupsControlViewTapBlock tapItemWithIndex;
@property(nonatomic,assign)BOOL oneScreen;//default is YES;

-(void)moveToIndex:(NSInteger)index; //调用时机 scrollViewDidScroll
/*
 首次出现，需要高亮显示第二个元素,scroll: 是外部关联的scroll
 [self endMoveToIndex:2];
 [scroll scrollRectToVisible:CGRectMake(2*w, 0.0, w,h) animated:NO];
 */
-(void)endMoveToIndex:(NSInteger)index;  //调用时机 scrollViewDidEndDecelerating


@end
