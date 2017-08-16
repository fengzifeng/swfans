  //
//  HBCoreLabel
//  CoreTextMagazine
//
//  Created by weqia on 13-10-27.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import "HBCoreLabel.h"

static NSMutableDictionary *faceImagesUtil;

@interface HBCoreLabel()

@end

@implementation HBCoreLabel
@synthesize match=_match,linesLimit;


#pragma -mark 接口方法

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self){
        _copyEnableAlready=NO;
    }
    return self;
}

-(void)setAttributedText:(NSString *)attributedText
{
    _attributed=YES;
    if(attributedText==nil||[attributedText length]==0)
    {
        self.match=nil;
        return;
    }
    MatchParser * parser=[[MatchParser alloc]init];
    parser.width=self.bounds.size.width;
    [parser match:attributedText];
    self.match=parser;
}

-(void)setText:(NSString *)text
{
    _attributed=NO;
    [super setText:text];
}

-(void)setMatch:(MatchParser *)match
{
    if(match==_match)
        return;
    _attributed=YES;
    _match=match;
    [self setNeedsDisplay];
    [super setText:match.source];
    
}

- (void)drawRect:(CGRect)rect
{
//    NSDate *date = [NSDate date];
    // Drawing code
    if(!_attributed){
        [super drawRect:rect];
        return;
    }
    if(self.match!=nil&&[self.match isKindOfClass:[MatchParser class]]){
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Flip the coordinate system
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, self.match.limitHeight);
        CGContextScaleCTM(context, 1.0, -1.0);
        if(self.match.numberOfLimitLines==0||!self.linesLimit){
            CGRect rect_1 = CGRectZero;
            if (self.match.backgroundColorBounds) {
                for (NSDictionary * dict in self.match.backgroundColorBounds) {
                    NSValue *values = [dict objectForKey:MatchParserRange];
                    NSRange range = [values rangeValue];
                    NSString * rect = [dict objectForKey:MatchParserRects];
                    if (rangeSelect.location == range.location&&rangeSelect.length == range.length) {
                        CGRect bounds = CGRectFromString(rect);
                        if (rect_1.size.height != 0.0f &&( rect_1.origin.y - bounds.origin.y >10)&&rect_1.size.width + bounds.size.width > self.match.width) {
                            bounds.size.height = rect_1.origin.y - bounds.origin.y;
                        }
                        CGContextSetFillColorWithColor(context, _chageBackGround? RGBACOLOR(0, 0, 0, 0.18 ).CGColor:[UIColor clearColor].CGColor);
                        CGContextFillRect(context, bounds);
                        rect_1 = bounds;
                    }
                }
            }
            
            CTFrameDraw((__bridge CTFrameRef)(self.match.ctFrame), context);
            for (NSDictionary* imageData in self.match.images) {
                
                NSString* img = [imageData objectForKey:MatchParserImage];
                NSValue * value=[imageData objectForKey:MatchParserRects];
                CGRect imgBounds = CGRectZero;
                if(![value isKindOfClass:[NSNull class]])
                {
                    imgBounds=[[imageData objectForKey:MatchParserRects] CGRectValue];
                }
                UIImage *image=[HBCoreLabel imageWithName:img fontSize:imgBounds.size.height];
                CGContextDrawImage(context, imgBounds, image.CGImage);
            }
        }
        else{
            NSArray *lines = (__bridge NSArray *)CTFrameGetLines((__bridge CTFrameRef)(self.match.ctFrame));
            CGPoint origins[[lines count]];
            CTFrameGetLineOrigins((__bridge CTFrameRef)(self.match.ctFrame), CFRangeMake(0, 0), origins); //2
            for(int lineIndex=0;lineIndex<self.match.numberOfLimitLines;lineIndex++){
                CTLineRef line=(__bridge CTLineRef)(lines[lineIndex]);
                CGContextSetTextPosition(context,origins[lineIndex].x,origins[lineIndex].y);
                CTLineDraw(line, context);
            }
            for (NSDictionary* imageData in self.match.images) {
                NSString* img = [imageData objectForKey:MatchParserImage];
                UIImage * image=[UIImage imageNamed:img];
                NSValue * value=[imageData objectForKey:MatchParserRects];
                CGRect imgBounds;
                if(![value isKindOfClass:[NSNull class]])
                {
                    imgBounds=[[imageData objectForKey:MatchParserRects] CGRectValue];
                    NSNumber * number=[imageData objectForKey:MatchParserLine];
                    int line=[number intValue];
                    if(line<self.match.numberOfLimitLines){
                        CGContextDrawImage(context, imgBounds, image.CGImage);
                    }
                }
            }
        }
    }
//    FLOG(@"draw = %f",[[NSDate date] timeIntervalSinceDate:date]);
}

#pragma -mark 事件响应方法
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch1=[touches anyObject];
    CGPoint point=[touch1 locationInView:self];
    for(NSDictionary * dic in self.match.links){
        NSArray * rects=[dic objectForKey:MatchParserRects];
        for(NSValue * value in rects){
            CGRect rect= [value CGRectValue];
            if (rect.origin.y<0) {
                rect.origin.y = 0;
            }
            if(point.x>rect.origin.x&&point.y>rect.origin.y&&point.x<(rect.origin.x+rect.size.width)&&point.y<(rect.origin.y+rect.size.height)){
                NSValue * rangeValue=[dic objectForKey:MatchParserRange];
                NSRange range=[rangeValue rangeValue];
                rangeSelect = range;
                _chageBackGround = YES;
                _linkStr=[self.match.platText substringWithRange:range];
                _linkType=[dic objectForKey:MatchParserLinkType];
                [self setNeedsDisplay];
                touch=YES;
                return;
            }
        }
    }
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touch) {
        touch=NO;
        _chageBackGround = NO;
        [self setNeedsDisplay];
        return;
    }
    [super touchesCancelled:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touch){
        touch=NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _chageBackGround = NO;
            [self setNeedsDisplay];
        });
        if([_linkType isEqualToString:MatchParserLinkTypeUrl]){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:linkClick:)]){
                [self.delegate coreLabel:self linkClick:_linkStr];
            }
        }else if ([_linkType isEqualToString:MatchParserLinkTypePhone]){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:phoneClick:)]){
                [self.delegate coreLabel:self phoneClick:_linkStr];
            }
        }else if ([_linkType isEqualToString:MatchParserLinkTypeMobie]){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:mobieClick:)]){
                [self.delegate coreLabel:self mobieClick:_linkStr];
            }
        }else  if([_linkType isEqualToString:MatchParserNameTypeUrl]){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:nameClick:range:)]){
                [self.delegate coreLabel:self nameClick:_linkStr range:rangeSelect];
            }
        }
        return;
    }
    [super touchesEnded:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //确定用户是不是点击了当前视图或者是否已隐藏
    if (![self pointInside:point withEvent:event] || self.hidden || !self.alpha) {
        return nil;
    }

    //已在Label上添加手势
    if (self.gestureRecognizers.count) {
        return self;
    }
    
    for(NSDictionary * dic in self.match.links){
        NSArray * rects=[dic objectForKey:MatchParserRects];
        for(NSValue * value in rects){
            CGRect rect= [value CGRectValue];
            if (rect.origin.y<0) {
                rect.origin.y = 0;
            }
            
            if(point.x>rect.origin.x&&point.y>rect.origin.y&&point.x<(rect.origin.x+rect.size.width)&&point.y<(rect.origin.y+rect.size.height)){
                return self;
            }
        }
    }
    return nil;
}
+ (UIImage *)imageWithName:(NSString *)name fontSize:(float)fontSize
{
    faceImagesUtil = faceImagesUtil?:[NSMutableDictionary dictionary];
    NSString *key = [[NSString stringWithFormat:@"%@%f",name,fontSize] md5];
    
    UIImage *image = faceImagesUtil[key];
    if (!image) {
        image = [[UIImage imageNamed:name] imageScaledToSize:CGSizeMake(fontSize, fontSize)];
        @synchronized(faceImagesUtil) {
            if (image) {
                [faceImagesUtil setObject:image forKey:key];
            }
        }
    }
    return image;
}

@end
