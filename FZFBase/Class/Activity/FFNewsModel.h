//
//  FFNewsModel.h
//  FZFBase
//
//  Created by fengzifeng on 16/8/10.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "DBObject.h"

typedef enum {
    GAME_NEWS_TYPE,         //游戏
    MATCH_NEWS_TYPE,        //赛事
    SQUADRON_NEWS_TYPE,     //战队
    TRADE_NEWS_TYPE,        //行业
} NEWS_TYPE;

typedef enum {
    NEWS_CELL_TYPE        = 1,
    IMAGES_CELL_TYPE,
    TOPIMAGE_CELL_TYPE,
    TOPVIDEO_CELL_TYPE,
    BIGIMAGE_CELL_TYPE
} CELL_TYPE;

@interface FFNewsModel : DBObject

@property (nonatomic, assign) NEWS_TYPE news_type;
@property (nonatomic, assign) CELL_TYPE cell_type;
@property (nonatomic, assign) NSInteger id;


@end
