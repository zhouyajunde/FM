//
//  SICollectInfoDao.h
//  SIrico-FlyRadio
//
//  Created by fantasee on 14-3-5.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SICollectInfoEntity.h"
#import "FMDatabase.h"

@interface SICollectInfoDao : NSObject

+ (NSString *) getCreateSQL;

+ (NSString *) getInsertSQL;

- (void) setDatabase:(FMDatabase *) database saveCollect:(SICollectInfoEntity *) collect;

- (void) setDatabase:(FMDatabase *) database deleteByChannelId:(NSString *) channelId;

- (NSMutableArray *) findCollectChannels:(FMDatabase *) database;



@end
