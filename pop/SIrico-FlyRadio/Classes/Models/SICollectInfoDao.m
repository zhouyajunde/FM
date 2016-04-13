//
//  SICollectInfoDao.m
//  SIrico-FlyRadio
//
//  Created by fantasee on 14-3-5.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "SICollectInfoDao.h"

@implementation SICollectInfoDao

+ (NSString *) getCreateSQL
{
    return [NSString
            stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ integer primary key autoincrement,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text);",
            Collect_TABLE,
            Collect_ID,
            Collect_channelID,
            Collect_channelName,
            Collect_channelFm,
            Collect_channleURL,
            Collect_channelAreaID,
            Collect_channelType
            ];

}

+ (NSString *) getInsertSQL
{
    return [NSString
            stringWithFormat:@"INSERT INTO %@(%@,%@,%@,%@,%@,%@) VALUES(?,?,?,?,?,?);",
            Collect_TABLE,
            Collect_channelID,
            Collect_channelName,
            Collect_channelFm,
            Collect_channleURL,
            Collect_channelAreaID,
            Collect_channelType
            ];

}

- (void) setDatabase:(FMDatabase *) database saveCollect:(SICollectInfoEntity *) collect
{
    [database executeUpdate:[SICollectInfoDao getInsertSQL],
     collect.channelID,
     collect.channelName,
     collect.channelFm,
     collect.channleURL,
     collect.channelAreaID,
     collect.channelType
     ];

}

- (void) setDatabase:(FMDatabase *) database deleteByChannelId:(NSString *) channelId
{
    NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@';",Collect_TABLE,Collect_channelID,channelId];
    [database executeUpdate:deleteSQL];

}

- (NSMutableArray *) findCollectChannels:(FMDatabase *) database
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSString * queryString = [NSString
                              stringWithFormat:@"SELECT * FROM t_collect;"];
    FMResultSet *rs =  [database executeQuery:queryString];
    while ([rs next]) {
        SICollectInfoEntity * object = [[SICollectInfoEntity alloc] init];
        [object setChannelID:[rs stringForColumn:Collect_channelID]];
        [object setChannelName:[rs stringForColumn:Collect_channelName]];
        [object setChannelFm:[rs stringForColumn:Collect_channelFm]];
        [object setChannleURL:[rs stringForColumn:Collect_channleURL]];
        [object setChannelAreaID:[rs stringForColumn:Collect_channelAreaID]];
        [object setChannelType:[rs stringForColumn:Collect_channelType]];
        
        //添加对象到集合中
        [items addObject:object];
    }
    [rs close];
    return items;

}

@end
