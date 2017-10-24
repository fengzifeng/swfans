//
//  ImageAttributeModel.h
//  QindexTest
//
//  Created by fengzifeng on 17/7/26.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface ImageAttributeModel : NSObject

@property (nonatomic, strong)NSString *imageName;
@property (nonatomic, assign)NSRange   rangePosition;
@property (nonatomic, assign)CGSize   imagesize;
@property (nonatomic, assign)CTFontRef  fontRef;
@property (nonatomic, assign)UIEdgeInsets imageEdgeinset;


@end
