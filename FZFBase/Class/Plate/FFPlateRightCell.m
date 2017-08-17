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
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}

- (void)setupView
{
    NSInteger count = 7;
    NSInteger rankCount = 3;
    NSInteger side = 15;
    for (int i = 0; i <= count/rankCount ; i++) {
        NSInteger lineCount = count/(i+1)>=rankCount?rankCount:count%(i+1);
        
        for (int j = 0; j<lineCount; j++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(side + j*(SCREEN_WIDTH - side*2)/3.0, i*90, SCREEN_WIDTH/3.0, 90)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((button.width - 45)/2.0, 10, 45, 45)];
            UILabel *label = [UILabel alloc] initWithFrame:cg
        }
    }

}
@end
