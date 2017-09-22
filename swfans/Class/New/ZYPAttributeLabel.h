//
//  ZYPAttributeLabel.h
//  QindexTest
//
//  Created by fengzifeng on 17/7/25.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface ZYPAttributeLabel : UIView

@property (nonatomic, strong)UIColor *textcolor;
@property (nonatomic, strong)UIFont *textfont;
@property (nonatomic, assign)BOOL  isHtml;//是否是html文本
@property (nonatomic, strong)NSString *text1;//基础配置完后后可以设置 文本

/*
 *  改变某一部分文本颜色
 */
- (void)changeTextColorWithRange:(NSRange)range color:(UIColor *)color;

/*
 * 计算文本的 高度 外部使用
 */
- (CGSize)sizeWithWidth:(CGFloat)width attstr:(NSString *)text textFont:(UIFont *)textfont;

/*
 * 计算有限文本的 高度 外部使用
 */

- (CGSize)sizeWithWidth:(CGFloat)width limitLen:(NSInteger)len attstr:(NSString *)text textFont:(UIFont *)textfont lastConfigure:(NSDictionary *)dic;



/*
 * 生成需要展示的属性字符串
 */
- (NSMutableAttributedString *)getAttributeText:(NSMutableAttributedString *)str font:(UIFont *)font;

/*
 * 生成字形 外部保存 本地使用
 */
- (CTFrameRef)generateTheFrameRefWithRect:(CGRect)rect dataStr:(NSString *)text textFont:(UIFont *)textFont;

/*
 * 精确绘制有限的文本
 */
- (void)showText:(NSString *)textStr limit:(NSInteger)textLen lastConfigure:(NSDictionary *)dic;




@end
