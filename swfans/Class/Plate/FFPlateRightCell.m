//
//  FFPlateRightCell.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/17.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPlateRightCell.h"
#import "FFPlateModel.h"
#import "FFPlateViewController.h"
#import "FFPlateDetailViewController.h"

@interface FFPlateRightCell ()
{
    FFPlateSectionModel *_currentModel;

}
@end

@implementation FFPlateRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self setupView];
}


//- (void)setupView
//{
//    NSInteger count = 7;
//    NSInteger rankCount = 3;
//    NSInteger side = 10*WindowZoomScale;
//
//    for (int i = 0; i <= count/rankCount ; i++) {
//        NSInteger lineCount = count/(i+1)>=rankCount?rankCount:count%(i+1);
//        
//        for (int j = 0; j<lineCount; j++) {
//            
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(side + j*(SCREEN_WIDTH - 100 - side*2)/3.0, 20 + i*115, (SCREEN_WIDTH - 100 - side*2)/3.0, 90)];
//            button.tag = i*3 + j;
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((button.width - 45)/2.0, 10, 45, 45)];
//            imageView.backgroundColor = [UIColor redColor];
//            imageView.tag = 1;
//            UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 15, button.width, 10)];
//            upLabel.text = @"三维建模";
//            upLabel.font = [UIFont systemFontOfSize:10];
//            upLabel.textAlignment = NSTextAlignmentCenter;
//            upLabel.tag = 2;
//            
//            UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upLabel.frame) + 5, button.width, 10)];
//            downLabel.textAlignment = NSTextAlignmentCenter;
//            downLabel.font = [UIFont systemFontOfSize:10];
//            downLabel.text = @"SOLIDWORKS";
//            downLabel.tag = 3;
//            
//            [self.contentView addSubview:button];
//            [button addSubview:imageView];
//            [button addSubview:upLabel];
//            [button addSubview:downLabel];
//
//        }
//    }
//}

- (void)updateCell:(FFPlateSectionModel *)model
{
    NSInteger count = model.forums.count;
    NSInteger rankCount = 3;
    NSInteger side = 10*WindowZoomScale;
    _currentModel = model;
    CGFloat itemHeight = 100;

    for (int i = 0; i <= count/rankCount ; i++) {

        NSInteger lineCount = count/(i+1)>=rankCount?rankCount:count%rankCount;
        for (int j = 0; j<lineCount; j++) {
            FFPlateItemModel *itemModel = model.forums[i*3 + j];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(side + j*(SCREEN_WIDTH - 100 - side*2)/3.0, 20 + i*itemHeight, (SCREEN_WIDTH - 100 - side*2)/3.0, 90)];
            if (itemModel.downName.length) itemHeight = 115;
            button.tag = i*3 + j;
            [button addTarget:self action:@selector(clcickBtn:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((button.width - 45)/2.0, 10, 45, 45)];
            imageView.tag = 1;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:itemModel.icon]];
            UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 15, button.width, 10)];
            upLabel.text = itemModel.upName;
            upLabel.font = [UIFont systemFontOfSize:10];
            upLabel.textAlignment = NSTextAlignmentCenter;
            upLabel.tag = 2;
            upLabel.textColor = RGBCOLOR(180, 182, 185);
            
            UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upLabel.frame) + 5, button.width, 10)];
            downLabel.textAlignment = NSTextAlignmentCenter;
            downLabel.font = [UIFont systemFontOfSize:10];
            downLabel.text = itemModel.downName;
            downLabel.tag = 3;
            downLabel.textColor = RGBCOLOR(180, 182, 185);
            
            [self.contentView addSubview:button];
            [button addSubview:imageView];
            [button addSubview:upLabel];
            [button addSubview:downLabel];
        }
        
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7.5, [[self class] getCellHeight:model] - 0.5, SCREEN_WIDTH - 100 - 15, 0.5)];
    label.backgroundColor = RGBCOLOR(216, 216, 216);
    [self.contentView addSubview:label];
}

- (void)clcickBtn:(UIButton *)button
{
    FFPlateItemModel *itemModel = _currentModel.forums[button.tag];

    FFPlateViewController *vc = [FFPlateViewController viewController];
    vc.forum_id = itemModel.fid;
    
    [((FFPlateDetailViewController *)self.nearsetViewController).navigationController pushViewController:vc animated:YES];
}

+ (CGFloat)getCellHeight:(FFPlateSectionModel *)model
{
    NSInteger count = model.forums.count;
    NSInteger rankCount = 3;
    CGFloat height = 0;

    for (int i = 0; i <= count/rankCount ; i++) {
        
        CGFloat sigerHeight = [[self class] getSigerHeight:model index:i];
        
        height += sigerHeight;
    }
    
    return height + 20;
}

+ (CGFloat)getSigerHeight:(FFPlateSectionModel *)model index:(NSInteger)index
{
    CGFloat height = 100;
    NSInteger count = model.forums.count;
    NSInteger rankCount = 3;
    NSInteger lineCount = count/(index+1)>=rankCount?rankCount:count%rankCount;

    for (int i = 0; i<lineCount; i++) {
        FFPlateItemModel *itemModel = model.forums[index*3 + i];
        if (itemModel.downName.length) {
            height = 115;
            break;
        }
        
    }
    
    return height;
}




@end
