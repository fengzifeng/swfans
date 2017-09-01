//
//  HBCoreLabel.h
//  CoreTextMagazine
//
//  Created by weqia on 13-10-27.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchParser.h"

@class HBCoreLabel;
@protocol HBCoreLabelDelegate <NSObject>
@optional
-(void)coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr;
-(void)coreLabel:(HBCoreLabel *)coreLabel phoneClick:(NSString *)linkStr;
-(void)coreLabel:(HBCoreLabel *)coreLabel mobieClick:(NSString *)linkStr;
-(void)coreLabel:(HBCoreLabel *)coreLabel nameClick:(NSString *)linkStr range:(NSRange)range;
@end

@interface HBCoreLabel : UILabel
{
    MatchParser* _match;
    
    BOOL touch;
    
    NSString * _linkStr;
    
    NSString * _linkType;
    
    BOOL _copyEnableAlready;
    
    BOOL _attributed;
    
    NSRange rangeSelect;

}
@property(nonatomic,assign) BOOL chageBackGround;
@property(nonatomic,strong) MatchParser * match;
@property(nonatomic,assign) id<HBCoreLabelDelegate> delegate;
@property(nonatomic,assign) BOOL linesLimit;

-(void)setAttributedText:(NSString *)attributedText;

@end
