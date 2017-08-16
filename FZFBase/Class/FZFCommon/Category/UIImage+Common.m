//
//  UIImage+Common.m
//  HLMagic
//
//  Created by marujun on 13-12-8.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import "UIImage+Common.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Common)

+ (UIImage *)screenshot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    CGFloat minEdgeSize = cornerRadius * 2 + 1;
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

//UIView转换为UIImage
+ (UIImage *)imageWithView:(UIView *)view
{
    //支持retina高分的关键
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resImage;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize
{
    newSize.width = (int)newSize.width;
    newSize.height = (int)newSize.height;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)squareImage
{
    CGSize imgSize = self.size;
    if (imgSize.width !=  imgSize.height) {
        CGFloat image_x =0.0;
        CGFloat image_y =0.0;
        UIImage *image = nil;
        if (imgSize.width >  imgSize.height) {
            image_x = (imgSize.width -imgSize.height)/2;
            image = [self imageClipedWithRect:CGRectMake(image_x, 0, imgSize.height, imgSize.height)];
        }else{
            image_y = (imgSize.height -imgSize.width)/2;
            image = [self imageClipedWithRect:CGRectMake(0,image_y, imgSize.width, imgSize.width)];
        }
        return image;
    }
    return self;
}

- (UIImage *)imageClipedWithRect:(CGRect)clipRect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, clipRect);
    
    UIGraphicsBeginImageContext(clipRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipRect, subImageRef);
    UIImage* clipImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return clipImage;
}

+ (UIImage *)defaultImage
{
    return [UIImage imageNamed:@"default_default_loading.jpg"];
}

+ (UIImage *)defaultAvatar
{
    return [UIImage imageNamed:@"pub_default_avatar.jpg"];
}

+ (UIImage *)defaultBigAvatar
{
    return [UIImage imageNamed:@"pub_big_default_avatar.jpg"];
}


//圆形的头像图片
- (UIImage *)circleAvatarImage
{
    // when an image is set for the annotation view,
    // it actually adds the image to the image view
    
    //圆环宽度
    float annulusLen = 5;
    //边框宽度
    float borderWidth = 2;
    
    float fixWidth = self.size.width;
    
    float radius1 = fixWidth / 2;
    float radius2 = radius1 + borderWidth;
    float radius3 = radius2 + annulusLen;
    
    CGSize canvasSize = CGSizeMake(radius3 * 2, radius3 * 2);
    
    UIGraphicsBeginImageContext(canvasSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //抗锯齿
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    // Create the gradient's colours
    float start = 0;
    float end = 0;
    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { start,start,start, 0.5,  // Start color
        end,end,end, 0 }; // End color
    
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    CGPoint centerPoint = CGPointMake(radius3, radius3);
    // Draw it!
    CGContextDrawRadialGradient (context, myGradient, centerPoint, radius2, centerPoint, radius3, kCGGradientDrawsAfterEndLocation);
    
    // draw outline so that the edges are smooth:
    // set line width
    CGContextSetLineWidth(context, 1);
    // set the colour when drawing lines R,G,B,A. (we will set it to the same colour we used as the start and end point of our gradient )
    
    //描边 抗锯齿
    CGContextSetRGBStrokeColor(context, start, start, start, 0.5);
    CGContextAddEllipseInRect(context, CGRectMake(annulusLen, annulusLen, radius2 * 2, radius2 * 2));
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, end, end, end, 0);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, radius3 * 2, radius3 * 2));
    CGContextStrokePath(context);
    
    //--------------------------
    
    float borderGap = radius3 - radius1 - borderWidth / 2;
    UIColor *color = [UIColor whiteColor];
    if (borderWidth > 0) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineCap(context,kCGLineCapButt);
        CGContextSetLineWidth(context, borderWidth);
        CGContextAddEllipseInRect(context, CGRectMake(borderGap, borderGap, radius2 * 2 - borderWidth, radius2 * 2 - borderWidth));//在这个框中画圆
        
        CGContextStrokePath(context);
    }
    
    float imageGap = radius3 - radius1;
    CGRect rect = CGRectMake(imageGap, imageGap, fixWidth , fixWidth);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [self drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    
    return newimg;
}

//模糊化图片
- (UIImage *)bluredImageWithRadius:(CGFloat)radius
{
    //TODO:  requires iOS 6
    
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    return [UIImage imageWithCGImage:cgImage];
}

//黑白图片
- (UIImage*)monochromeImage
{
    CIImage *beginImage = [CIImage imageWithCGImage:[self CGImage]];
    
    CIColor *ciColor = [CIColor colorWithCGColor:[UIColor lightGrayColor].CGColor];
    CIFilter *filter = nil;
    CIImage *outputImage;
    if(IS_IOS_6) {
        CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:0.8], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
        outputImage = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    }else{
        filter = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey, beginImage, kCIInputColorKey, ciColor, nil];
        outputImage = [filter outputImage];
    }
    
    [EAGLContext setCurrentContext:nil];
    
    return  [UIImage imageWithCIImage:outputImage];
}

/**
 *  图片灰度化
 *
 *  @return 灰度化后的UIImage
 */
- (UIImage *)convertImageToGreyScale
{
    
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [self CGImage]);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    return newImage;
    
}

//修正图片方向
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // The UIImage methods size and drawInRect take into account
    //  the value of its imageOrientation property
    //  so the rendered image is rotated as necessary.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    UIImage *orientedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return orientedImage;
}

//反转后的遮罩图片
- (UIImage *)inverseMaskImage
{
    UIImage *image = [UIImage imageWithColor:[UIColor blackColor] size:self.size];
    
    CGImageRef maskRef = self.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    //add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
    //this however has a computational cost
    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
        //copyImageAndAddAlphaChannel
        CGImageRef retVal = NULL;
        
        size_t width = CGImageGetWidth(sourceImage);
        size_t height = CGImageGetHeight(sourceImage);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace,
                                                              kCGImageAlphaPremultipliedFirst);
        if (offscreenContext != NULL) {
            CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
            retVal = CGBitmapContextCreateImage(offscreenContext);
            CGContextRelease(offscreenContext);
        }
        CGColorSpaceRelease(colorSpace);
        imageWithAlpha = retVal;
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    //release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    UIImage *retImage = [UIImage imageWithCGImage:masked scale:self.scale orientation:self.imageOrientation];
    
    CGImageRelease(masked);
    
    return retImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];;
}


@end
