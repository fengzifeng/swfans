//
//  News+CoreDataProperties.h
//  FZFBase
//
//  Created by fengzifeng on 16/8/10.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "News.h"

NS_ASSUME_NONNULL_BEGIN

@interface News (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *cell_type;
@property (nullable, nonatomic, retain) NSNumber *news_type;

@end

NS_ASSUME_NONNULL_END
