//
//  ZYPAttributeLabel.m
//  QindexTest
//
//  Created by fengzifeng on 17/7/25.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "ZYPAttributeLabel.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ImageAttributeModel.h"
//#import "DrEmojiManager.h"

#define zypKernSpacing  0.5
#define zypLineSpacing  4
#define zypParagraphSpacing 5
#define zypLinefirstIndentSpacing 0


@interface ZYPAttributeLabel ()
@property (nonatomic, strong)NSMutableArray *imageModelArr;//存储文本中总的图片数
@property (nonatomic, strong)NSMutableAttributedString *finalAttStr;//图片占位符设置后的最终字符串
@property (nonatomic, assign)CTFrameRef frameRef;//全局 frame
@property (nonatomic, assign)NSInteger numberOfLines;//显示多少行文本，默认5

@property (nonatomic, strong)NSDictionary *emojiDic;


@end

@implementation ZYPAttributeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurationText];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
#pragma mark --- 配置初始值
- (void)configurationText
{
    self.textcolor = [UIColor lightGrayColor];
    self.textfont = [UIFont systemFontOfSize:20];
    self.backgroundColor = [UIColor whiteColor];
    self.numberOfLines = 0;
}

- (void)setText1:(NSString *)text1
{
    if (_text1 != text1)
    {
        CGSize size = [self sizeWithWidth:CGRectGetWidth(self.frame) attstr:text1 textFont:self.textfont];
        CGRect rect = self.frame;
        rect.size.height = size.height;
        self.frame = rect;
        self.frameRef = [self generateTheFrameRefWithRect:self.frame dataStr:text1 textFont:self.textfont];
        [self setNeedsDisplay];
    }
}





#pragma mark --- 配置NSMutableAttributedString 文本属性
- (NSMutableAttributedString *)loadAttributeText:(NSString *)string
                               textColor:(UIColor *)textColor
                                    font:(UIFont *)font
{
    NSDictionary *attributes = [self prepareStringAttributeDic:textColor font:font];
    // 初始化可变字符串
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    return attString;
}
- (NSDictionary *)prepareStringAttributeDic:(UIColor *)textColor font:(UIFont *)font
{
    // 设置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = zypLineSpacing;
    paragraphStyle.paragraphSpacing = zypParagraphSpacing;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.firstLineHeadIndent = zypLinefirstIndentSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByCharWrapping;
    
    // 设置文本属性字典
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : textColor,
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSKernAttributeName:[NSNumber numberWithFloat:zypKernSpacing]
                                 };
    return attributes;
}
#pragma mark --- 精确计算文本高度

- (CGSize)sizeWithWidth:(CGFloat)width attstr:(NSString *)text textFont:(UIFont *)textfont
{
    NSMutableAttributedString *  attStr;
    if (self.isHtml) {
        attStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    }else
    {
        attStr = [self loadAttributeText:text textColor:self.textcolor font:textfont];
    }
    //生成用于展示的 属性字符串
    NSMutableAttributedString *str = [self getAttributeText:attStr font:textfont];
    // 声明一个range -> 用来存放显示文字的范围
    CFRange stringRange = CFRangeMake(0, str.length);
    // 获取framesetterRef
    CTFramesetterRef framSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)str);
   
        // 获取绘制rect的大小
//        CGRect rect = CGRectMake(0, 0, width, MAXFLOAT);
    
        // 获取FrameRef
//        CGMutablePathRef path = CGPathCreateMutable();
//        //这里的10000要和绘制对象的坐标转换关联
//        CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height));
//        CTFrameRef frameRef = CTFramesetterCreateFrame(framSetterRef, CFRangeMake(0, str.length), path, NULL);
//        CGPathRelease(path);
//        CFRelease(framSetterRef);
//        
//        // 获取lineRef数组
//        CFArrayRef lines = CTFrameGetLines(frameRef);
//        
//        // 获取lineRef的个数(0~3)
//        CFIndex lineCount = CFArrayGetCount(lines);
//        
//        if (lineCount > 0 && nil != lines) {
//            // 取文字行数
//            NSUInteger lastVisibleLineIndex = lineCount;
//            
//            // 获取最后组的frameRef ->idx (0 ~ N-1)
//            CTLineRef lastVisibleLineRef = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex - 1);
//            
//            // 获取最后行文字在字符串中的范围
//            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLineRef);
//            
//            // 获取最后显示一行文字在字符串中的位置
//            stringRange = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
//        }
//        
//        // 释放frameRef
//        CFRelease(frameRef);
    
    // 根据range得到需要绘制文字的大小－>range为0的时候，代表绘制全部文字
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framSetterRef, stringRange, NULL, CGSizeMake(width, CGFLOAT_MAX), NULL);
    // 释放framesetterRef
    CFRelease(framSetterRef);
    return size;
}


- (CGSize)sizeWithWidth:(CGFloat)width limitLen:(NSInteger)len attstr:(NSString *)textStr textFont:(UIFont *)textfont lastConfigure:(NSDictionary *)dic
{
    NSMutableAttributedString *  attStr;
    if (self.isHtml) {
        attStr = [[NSMutableAttributedString alloc] initWithData:[textStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    }else
    {
        attStr = [self loadAttributeText:textStr textColor:self.textcolor font:textfont];
    }

    //生成用于展示的 属性字符串
    NSMutableAttributedString *str = [self getAttributeText:attStr font:textfont];
    
    NSString *strP =[dic objectForKey:@"placeStr"];
    if (str.length > len && str.length > strP.length)
    {
        [str replaceCharactersInRange:NSMakeRange(len-7, str.length-len+7) withString:strP];
        NSDictionary *dic1 = [dic objectForKey:@"config"];
        [str addAttributes:dic1 range:NSMakeRange(str.length - 4, 4)];
    }
    
    // 声明一个range -> 用来存放显示文字的范围
    CFRange stringRange = CFRangeMake(0, str.length);
    // 获取framesetterRef
    CTFramesetterRef framSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)str);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framSetterRef, stringRange, NULL, CGSizeMake(width, CGFLOAT_MAX), NULL);
    // 释放framesetterRef
    CFRelease(framSetterRef);
    return size;
}


#pragma mark --- 生成需要展示的属性字符串
- (NSMutableAttributedString *)getAttributeText:(NSMutableAttributedString *)str font:(UIFont *)font
{
//    NSLog(@"pppp===: %@",str);
    //此方法多次调用 需清理老数据
    [self.imageModelArr removeAllObjects];
    //正则表达式 搜索[]
    NSString *regX  = @"\\[[^\\[\\]\\s]+\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regX options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *matches = [regex matchesInString:str.string options:0 range:NSMakeRange(0, str.length)];
    for (NSTextCheckingResult *match in matches)
    {
        ImageAttributeModel *model = [[ImageAttributeModel alloc] init];
        model.rangePosition = match.range;
//        model.imageName = [[str.string substringWithRange:match.range] substringWithRange:NSMakeRange(2, match.range.length - 3)];
        model.imageName = [str.string substringWithRange:match.range];
//        NSLog(@"%zd === %zd === %@",match.range.location,match.range.length,model.imageName);
        [self.imageModelArr addObject:model];
    }
    // 4.遍历图片数组，处理图片相关内容
    // 4.0获取图片所在位置的fontRef
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    for (NSInteger k = 0; k < self.imageModelArr.count; k ++ ) {
        ImageAttributeModel *model = [self.imageModelArr objectAtIndex:k];
        //5.0 获取图片
        NSString *imageN = [self.emojiDic objectForKey:model.imageName];
        UIImage *image = [UIImage imageNamed:imageN];
        if (!image) {
            [self.imageModelArr removeObject:model];
            continue;
        }
        //5.1 设置图片大小
        model.imagesize = CGSizeMake(font.pointSize, font.pointSize);
        //5.2 设置字体属性 方便绘制图片
        model.fontRef = fontRef;
        //5.2 设置图片与上下左右文字的间距
        model.imageEdgeinset = UIEdgeInsetsMake(0, 1, 0, 1);
        //5.3 设置占位的attributeString
        NSAttributedString *attSring = [self loadPlaceholderStrWithImageData:model];
        //5.4 计算图片位置
        NSRange range = [str.string rangeOfString:model.imageName];
        // 5.5.占位图片属性字符串替换图片名
        [str replaceCharactersInRange:range withAttributedString:attSring];
        //5.6 重新给model位置属性赋值
        NSRange locationRange = model.rangePosition;
        locationRange.location =range.location;
        locationRange.length = 1;
        model.rangePosition = locationRange;
    }
    self.finalAttStr = str;
    return str;
}

#pragma mark --- 设置占位的字符串
- (NSMutableAttributedString *)loadPlaceholderStrWithImageData:(ImageAttributeModel *)imageData
{
    // 1.设置runDelegate的回调信息
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
        // 2.创建CTRun回调
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(imageData));
    
    // 3.使用 0xFFFC 作为空白的占位符
//    unichar objectReplacementChar = 0xFFFC;
    unichar objectReplacementChar = 'a';

    NSString *string = [NSString stringWithCharacters:&objectReplacementChar length:1];
    
    // 4.初始化占位符空属性字符串
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 5.设置占位符空属性字符串的kCTRunDelegateAttributeName
    [attString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    
    // 6.释放
    CFRelease(runDelegate);
    return attString;
}

#pragma mark --- 生成CTFrameRef 对象，保存下来
- (CTFrameRef)generateTheFrameRefWithRect:(CGRect)rect dataStr:(NSString *)text textFont:(UIFont *)textFont
{
    NSMutableAttributedString *  attStr;
    if (self.isHtml) {
        attStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    }else
    {
        attStr = [self loadAttributeText:text textColor:self.textcolor font:textFont];
    }
    
//    attStr = [self loadAttributeText:attStr.string textColor:self.textcolor font:textFont];
    //生成用于展示的 属性字符串
    NSMutableAttributedString *str = [self getAttributeText:attStr font:textFont];
    
    CTFramesetterRef framSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)str);
    CGMutablePathRef path = CGPathCreateMutable();
    //这里的10000要和绘制对象的坐标转换关联
    CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height));
    CTFrameRef frame1 = CTFramesetterCreateFrame(framSetterRef, CFRangeMake(0, str.length), path, NULL);
    CGPathRelease(path);
    CFRelease(framSetterRef);
    return frame1;
}



- (void)changeTextColorWithRange:(NSRange)range color:(UIColor *)color
{
    NSDictionary *dic = @{NSForegroundColorAttributeName:color};
    [self.finalAttStr addAttributes:dic range:range];
    
    //生成用于展示的 属性字符串
    CTFramesetterRef framSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.finalAttStr);
    CGMutablePathRef path = CGPathCreateMutable();
    //这里的10000要和绘制对象的坐标转换关联
    CGPathAddRect(path, NULL, CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)));
    CTFrameRef frame1 = CTFramesetterCreateFrame(framSetterRef, CFRangeMake(0, self.finalAttStr.length), path, NULL);
    CGPathRelease(path);
    CFRelease(framSetterRef);
    
    CFRelease(self.frameRef);
    self.frameRef = frame1;
    [self setNeedsDisplay];
}


- (void)showText:(NSString *)textStr limit:(NSInteger)textLen lastConfigure:(NSDictionary *)dic
{
    NSMutableAttributedString * attStr = [self loadAttributeText:textStr textColor:self.textcolor font:self.textfont];
    //生成用于展示的 属性字符串
    NSMutableAttributedString *str = [self getAttributeText:attStr font:self.textfont];
    
    NSString *strP =[dic objectForKey:@"placeStr"];
    if (str.length > textLen && str.length > 7)
    {
        [str replaceCharactersInRange:NSMakeRange(textLen-7, str.length-textLen+7) withString:strP];
        NSDictionary *dic1 = [dic objectForKey:@"config"];
        [str addAttributes:dic1 range:NSMakeRange(str.length - 4, 4)];
    }
    
    //生成用于展示的 属性字符串
    CTFramesetterRef framSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)str);
    //计算控件高度 重新赋值
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framSetterRef, CFRangeMake(0, str.length), NULL, CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX), NULL);
    CGRect rect = self.frame;
    rect.size.height = size.height;
    self.frame = rect;
    //创建绘制路径
    CGMutablePathRef path = CGPathCreateMutable();
    //这里的10000要和绘制对象的坐标转换关联
    CGPathAddRect(path, NULL, CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)));
    CTFrameRef frame1 = CTFramesetterCreateFrame(framSetterRef, CFRangeMake(0, self.finalAttStr.length), path, NULL);
    CGPathRelease(path);
    CFRelease(framSetterRef);
    self.frameRef = frame1;
    [self setNeedsDisplay];
}


#pragma mark ---- 一行一行绘制文本
- (void)frameLinesDraw
{
    if (!self.frameRef){
        return;
    }
    //1、获取总行数组
    CFArrayRef lines = CTFrameGetLines(self.frameRef);
    //2、获取总的行数
    NSInteger lineCount = CFArrayGetCount(lines);
    //3、计算需要展示的行数
    NSUInteger numberOfLines = self.numberOfLines != 0 ? MIN(lineCount, self.numberOfLines):lineCount;
    //4、获取每一行的起始位置
    CGPoint lineOrigions[numberOfLines];//c语言数组，开辟空间
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, numberOfLines), lineOrigions);//获取每一行的起始点，如果CFRangeMake(0, 0)也表示所有行的起始点
    //5、遍历每一行，开始从每一行的开头绘制文本
    for (NSInteger k = 0; k < numberOfLines; k ++)
    {
        //5.1  要想绘制文本，需要先得到图形上下文(属于Graphics)
        CGContextRef contrextRef = UIGraphicsGetCurrentContext();
        //5.2  获取本行lineref
        CTLineRef line = CFArrayGetValueAtIndex(lines, k);
        //5.3  获取该行起点位置
        CGPoint point = lineOrigions[k];
        //5.4  设置文本的绘制的起始位置
        CGContextSetTextPosition(contrextRef, point.x, point.y);
        //5.5  开始绘制
        CTLineDraw(line, contrextRef);
    }
}

#pragma mark --- 绘制图片
- (void)drawImages
{
    if (!self.frameRef) {
        return;
    }
    //1 移除已将添加的图片
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    //2、获取所有行 lines
    CFArrayRef lineRefArr = CTFrameGetLines(self.frameRef);
    //3、计算总cflineref 的个数
    NSInteger lineCount = CFArrayGetCount(lineRefArr);
    //4、计算需要展示的 行数
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, lineCount):lineCount;
    //5、计算每一行的起始值
    CGPoint origions[numberOfLines];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, numberOfLines), origions);
    // 6.循环遍历每一组中是否包含link
    for (CFIndex idx = 0; idx < numberOfLines; idx ++) {
        // 6.1 寻找图片占位符的准备工作
        // 6.2 获取idx对应行的lineRef
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineRefArr, idx);
        // 6.3 获取当前lineRef中的runRef数组
        CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
        // 6.4 获取当前lineRef中的runRef的个数
        CFIndex runCount = CFArrayGetCount(runs);
        // 6.5 获取每一行对应的位置
        CGPoint lineOrigin = origions[idx];
        
        // 7 遍历lineRef中的runRef,查找图片占位符
        for (CFIndex idx = 0; idx < runCount; idx ++) {
            // 7.1 获取lineRef中对应的RunRef
            CTRunRef runRef = CFArrayGetValueAtIndex(runs, idx);
            // 7.2 获取对应runRef的属性字典
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(runRef);
            // 7.3 获取对应runRef的CTRunDelegateRef
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            // 7.4 如果不存在，直接退出本次遍历
            // ->证明不是图片，因为我们只给图片设置了CTRunDelegateRef
            if (nil == delegate) continue;
            
            // －>证明图片在runRef里
            // 7.6 开始绘制图片
            // 7.7 获取图片的数据模型
            ImageAttributeModel *imageData = (ImageAttributeModel *)CTRunDelegateGetRefCon(delegate);
            // 8、 获取需要展示图片的frame
            // 获取对应runRef的rect
            // 上行高度
            CGFloat ascent;
            // 下行高度
            CGFloat descent;
            // 宽度
            CGFloat width = CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), &ascent, &descent, NULL);
            // 高度
            CGFloat height = ascent + descent;
            
            // 当前runRef距离lineOrigin的偏移值
            CGFloat offsetX = CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL);
            // 返回计算好的rect
            CGRect rect = CGRectMake(lineOrigin.x + offsetX,
                                     lineOrigin.y - descent,
                                     width,
                                     height);
            CGRect imageFrame =  UIEdgeInsetsInsetRect(rect, imageData.imageEdgeinset);
            
            // 9 添加图片
            // 9.1 添加图形上下文
            CGContextRef context = UIGraphicsGetCurrentContext();
            NSString *imageName = [self.emojiDic objectForKey:imageData.imageName];
            UIImage *image = [UIImage imageNamed:imageName];
            // 9.2 绘制图片
            CGContextDrawImage(context, imageFrame, image.CGImage);
        }
    }
}

#pragma mark --- 设置CTRun delegate
/**
 * 获取图片的Ascent
 * height = ascent + descent
 */
static CGFloat ascentCallback(void *ref)
{
    // 1.获取imageData
    ImageAttributeModel *imageData = (__bridge ImageAttributeModel *)ref;
    
    // 2.获取图片的高度
    CGFloat imageHeight = attributedImageSize(imageData).height;
    
    // 3.获取图片对应占位属性字符串的Ascent和Descent
    CGFloat fontAscent  = CTFontGetAscent(imageData.fontRef);
    CGFloat fontDescent = CTFontGetDescent(imageData.fontRef);
    
    // 4.计算基线->Ascent和Descent分割线
    CGFloat baseLine = (fontAscent + fontDescent) / 2.f - fontDescent;
    
    // 5.获得正确的Ascent
    return imageHeight / 2.f + baseLine;
}

/**
 * 获取图片的Descent
 * height = ascent + descent
 */
static CGFloat descentCallback(void *ref)
{
    // 1.获取imageData
    ImageAttributeModel *imageData = (__bridge ImageAttributeModel *)ref;
    
    // 2.获取图片的高度
    CGFloat imageHeight = attributedImageSize(imageData).height;
    
    // 3.获取图片对应占位属性字符串的Ascent和Descent
    CGFloat fontAscent  = CTFontGetAscent(imageData.fontRef);
    CGFloat fontDescent = CTFontGetDescent(imageData.fontRef);
    
    // 4.计算基线->Ascent和Descent分割线
    CGFloat baseLine = (fontAscent + fontDescent) / 2.f - fontDescent;
    
    // 5.获得正确的Ascent
    return imageHeight / 2.f - baseLine;
}

/**
 * 获取图片的宽度
 */
static CGFloat widthCallback(void *ref)
{
    // 1.获取imageData
    ImageAttributeModel *imageData = (__bridge ImageAttributeModel *)ref;
    // 2.获取图片宽度
    return attributedImageSize(imageData).width;
}

/**
 * 获取占位图片的最终大小
 */
static CGSize attributedImageSize(ImageAttributeModel *imageData)
{
    CGFloat width = imageData.imagesize.width + imageData.imageEdgeinset.left + imageData.imageEdgeinset.right;
    CGFloat height = imageData.imagesize.height+ imageData.imageEdgeinset.top  + imageData.imageEdgeinset.bottom;
    return CGSizeMake(width, height);
}







- (void)drawRect:(CGRect)rect
{
    [self testAttributeText:rect];
}

- (void)testAttributeText:(CGRect)rect
{
    //**************1、定义string 样式**********************************
    //**************2、生成framesetter **********************************
    //**************3、得到CTFrame **********************************
    // **************4、绘制 CTFrameDraw **********************************
    // 获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetTextMatrix是调整坐标系，防止文字倒立
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(context);
    //x，y轴方向移动
    CGContextTranslateCTM(context ,0,rect.size.height);
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1.0 ,-1.0);
    [self frameLinesDraw];
    [self drawImages];
    
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    CFIndex index = [self judgePositionIsInRect:point];
//    if (index != -1)
//    {
//        for (NSInteger k = 0; k < self.imageModelArr.count; k ++)
//        {
//            ImageAttributeModel *model = [self.imageModelArr objectAtIndex:k];
//            NSLog(@"%zd === %zd",model.rangePosition.length,model.rangePosition.length);
//            if (NSLocationInRange(index, model.rangePosition))
//            {
//                NSLog(@"点击了图片");
//            }
//        }
//    }
//}
//
//
//- (CFIndex)judgePositionIsInRect:(CGPoint)touchPoint
//{
//    if (!self.frameRef) {
//        return -1;
//    }
//    CFArrayRef lineRef = CTFrameGetLines(self.frameRef);
//    NSInteger linecount = CFArrayGetCount(lineRef);
//    CGPoint origions[linecount];
//    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), origions);
//    CFIndex index = -1;
//    //平移
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.frame));
//    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
//    
//    
//    
//    for (NSInteger k = 0; k < linecount; k ++)
//    {
//        CTLineRef lineref = CFArrayGetValueAtIndex(lineRef, k);
//        //获取每一行的frame
//        CGFloat asecent ;
//        CGFloat dsecent ;
//        CGFloat width =  CTLineGetTypographicBounds(lineref, &asecent, &dsecent, NULL);
//        
//        CGFloat heignt = asecent + dsecent;
//        CGPoint point = origions[k];
//        CGRect lineRect = CGRectMake(point.x, point.y-dsecent, width, heignt);
//        
//        //翻转坐标系
//        CGRect rect = CGRectApplyAffineTransform(lineRect, transform);
//       
//        if (CGRectContainsPoint(rect, touchPoint))
//        {
//            //计算 触摸点相对于该行的 点
//            CGPoint linePoint = CGPointMake(touchPoint.x-CGRectGetMinX(rect), touchPoint.y-CGRectGetMinY(rect));
//            index = CTLineGetStringIndexForPosition(lineref, CGPointMake(5, 10));
//            //通过font.point来设置字的宽度
//            CGFloat width = self.textfont.pointSize+2;
//            index += linePoint.x/width;
//            break;
//        }
//    }
//    return index;
//}
//



#pragma mark --- 懒加载

- (NSMutableArray *)imageModelArr
{
    if (!_imageModelArr) {
        _imageModelArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageModelArr;
}
- (NSDictionary *)emojiDic
{
    if (!_emojiDic) {
//        _emojiDic = [DrEmojiManager emojiDic];
    }
    return _emojiDic;
}



/*
 if (imageData.imageType == SXTImageGIFTppe) {
 // 初始化imageView
 UIImageView *imageView = [UIImageView imageViewWithGIFName:imageData.imageName frame:imageFrame];
 // 调整imageView的Y坐标
 [imageView setY:self.height - imageView.height - imageView.y];
 [self addSubview:imageView];
 }else{
 
 */






@end
