//
//  FFPlateRightCell.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/17.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPlateRightCell.h"
#import "MCHVButton.h"

@implementation FFPlateRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}


- (void)setupView
{
    NSInteger count = 7;
    NSInteger rankCount = 3;
    NSInteger side = 10*WindowZoomScale;

    for (int i = 0; i <= count/rankCount ; i++) {
        NSInteger lineCount = count/(i+1)>=rankCount?rankCount:count%(i+1);
        
        for (int j = 0; j<lineCount; j++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(side + j*(SCREEN_WIDTH - 100 - side*2)/3.0, 20 + i*115, (SCREEN_WIDTH - 100 - side*2)/3.0, 90)];
            button.tag = i*3 + j;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((button.width - 45)/2.0, 10, 45, 45)];
            imageView.backgroundColor = [UIColor redColor];
            UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 15, button.width, 10)];
            upLabel.text = @"三维建模";
            upLabel.font = [UIFont systemFontOfSize:10];
            upLabel.textAlignment = NSTextAlignmentCenter;
            
            UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upLabel.frame) + 5, button.width, 10)];
            downLabel.textAlignment = NSTextAlignmentCenter;
            downLabel.font = [UIFont systemFontOfSize:10];
            downLabel.text = @"SOLIDWORKS";
            [self.contentView addSubview:button];
            [button addSubview:imageView];
            [button addSubview:upLabel];
            [button addSubview:downLabel];

        }
    }
    
}

+ (CGFloat)getCellHeight
{
    NSInteger count = 7;
    
    return (count/3 + 1)*115 + 20;

}


@end
