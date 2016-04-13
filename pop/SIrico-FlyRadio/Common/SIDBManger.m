//
//  SIDBManger.m
//  SIrico-FlyRadio
//
//  Created by Jin on 3/25/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIDBManger.h"
#import "FMDatabase.h"
#import "SIChannelInfoEntity.h"
#import "SIAreaEntity.h"

#define DBNAME @"CHANNELLIST.sqlite"
#define TABLENAME_CHANNELINFO @"CHANNELINFO"
#define TABLENAME_AREAINFO    @"AREAINFO"

#define CID    @"CHANNELID"
#define AID    @"CHANNELAREAID"
#define TID    @"CHANNELTYPE"
#define UID    @"CHANNELURL"
#define CNAME  @"CHANNELNAME"
#define FMNAME @"CHANNELFM"

#define AREAID    @"AREAID"
#define AREANAME  @"AREANAME"

@implementation SIDBManger


+ (instancetype)shareManger
{
    static SIDBManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SIDBManger alloc] init];
    });
    return manager;
}

- (void)createChannelDB
{
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        DBLog(@"error db open failed");
        return ;
    }
    
    //首先先删除表
    [db executeUpdate:@"drop table CHANNELINFO"];
    
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS CHANNELINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, CHANNELID TEXT, CHANNELNAME TEXT, CHANNELFM TEXT, CHANNELURL TEXT, CHANNELAREAID TEXT, CHANNELTYPE TEXT)"];
    

    [db close];
    
}

- (void)insertData:(SIChannelInfoEntity *)item
{
    
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return ;
    }

    
    [db executeUpdate:[NSString stringWithFormat:
                       @"INSERT INTO '%@' ('%@', '%@', '%@','%@', '%@','%@') VALUES ('%@', '%@', '%@','%@', '%@','%@')",
                       TABLENAME_CHANNELINFO, CID, CNAME,FMNAME, UID, AID, TID,item.channelID, item.channelName,item.channelFm,item.channelURL,item.channelAreaID,item.channelType]];
    [db close];


}



- (NSMutableArray *)getChannelWithAreaID:(NSString *)areaID
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return arr ;
    }
    

    
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from CHANNELINFO where CHANNELAREAID = %@",areaID]];
    
    while ([rs next]) {
        SIChannelInfoEntity *item = [[SIChannelInfoEntity alloc]init];
        item.channelID = [rs stringForColumn:CID];
        item.channelName = [rs stringForColumn:CNAME];
        item.channelFm = [rs stringForColumn:FMNAME];
        item.channelURL = [rs stringForColumn:UID];
        item.channelAreaID = [rs stringForColumn:AID];
        item.channelType = [rs stringForColumn:TID];
        [arr addObject:item];
        item = nil;
    }
    
    [rs close];
    [db close];
    
    
    return arr;
    
}


- (NSMutableArray *)getChannelWithFenLeiID:(NSString *)fenlei
{
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return data ;
    }

    
    FMResultSet *rs = [db executeQuery:@"select * from CHANNELINFO"];
    
    while ([rs next]) {
        NSString *type = [rs stringForColumn:TID];
        NSArray *arr = [type componentsSeparatedByString:@","];
        if ([arr containsObject:fenlei]) {
            
            SIChannelInfoEntity *item = [[SIChannelInfoEntity alloc]init];
            item.channelID = [rs stringForColumn:CID];
            item.channelName = [rs stringForColumn:CNAME];
            item.channelFm = [rs stringForColumn:FMNAME];
            item.channelURL = [rs stringForColumn:UID];
            item.channelAreaID = [rs stringForColumn:AID];
            item.channelType = [rs stringForColumn:TID];
            [data addObject:item];
            item = nil;
        }
    }
    
    [rs close];
    [db close];
    
    return data;

}

- (NSMutableArray *)getAllChannel
{
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return data ;
    }
    
    
    FMResultSet *rs = [db executeQuery:@"select *from CHANNELINFO"];
    
    while ([rs next]) {
        
        SIChannelInfoEntity *item = [[SIChannelInfoEntity alloc]init];
        item.channelID = [rs stringForColumn:CID];
        item.channelName = [rs stringForColumn:CNAME];
        item.channelFm = [rs stringForColumn:FMNAME];
        item.channelURL = [rs stringForColumn:UID];
        item.channelAreaID = [rs stringForColumn:AID];
        item.channelType = [rs stringForColumn:TID];
        [data addObject:item];
        item = nil;
    
    }
    
    [rs close];
    [db close];
    
    return data;

}

#pragma mark - create area db
- (void)createAreaDB
{
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        DBLog(@"error db open failed");
        return ;
    }
    
    //首先先删除表

    [db executeUpdate:@"drop table AREAINFO"];
    

    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS AREAINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, AREAID TEXT, AREANAME TEXT)"];
    
    [db close];
}


- (void)insertAreaData:(SIAreaEntity *)item
{
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return ;
    }
    
    [db executeUpdate:[NSString stringWithFormat:
                       @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
                       TABLENAME_AREAINFO, AREAID, AREANAME,item.areaID,item.areaName]];
    [db close];
}

- (NSString *)getAreaIdWithAreaName:(NSString *)areaName
{
    NSString *aid = nil;
    
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return aid ;
    }
    
    FMResultSet *rs = [db executeQuery:@"select * from AREAINFO"];
    
    while ([rs next]) {
        NSString *aname = [rs stringForColumn:AREANAME];
        if ([self containString:aname inString:areaName]) {
            aid = [rs stringForColumn:AREAID];
        }
    }
    
    [rs close];
    [db close];
    
    return aid;
    
}

- (BOOL)containString:(NSString *)testStr inString:(NSString *)str
{
    NSRange range = [str rangeOfString:testStr];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (NSMutableArray *)getAllArea
{
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return data ;
    }
    
    FMResultSet *rs = [db executeQuery:@"select *from AREAINFO"];
    
    while ([rs next]) {
        
        SIAreaEntity *item = [[SIAreaEntity alloc]init];
        item.areaID = [rs stringForColumn:AREAID];
        item.areaName = [rs stringForColumn:AREANAME];
        [data addObject:item];
        item = nil;
        
    }
    
    [rs close];
    [db close];
    
    return data;
    
}

- (NSString *)getAreanameWithAreaID:(NSString *)aid
{
    NSString *str = nil;
    
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return str ;
    }
    
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select *from AREAINFO where AREAID = %@",aid]];
    
    while ([rs next]) {
        str = [rs stringForColumn:AREANAME];
    }
    
    [rs close];
    [db close];
    
    return str;

}

- (NSMutableArray *)getAllCollection
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"betatown_database.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:database_path];
    if (![db open]) {
        return arr;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_collect"];
    
    while ([rs next]) {
        SIChannelInfoEntity *item = [[SIChannelInfoEntity alloc] init];
        item.channelID = [rs stringForColumn:@"channelID"];
        item.channelAreaID = [rs stringForColumn:@"channelAreaID"];
        item.channelFm = [rs stringForColumn:@"channelFm"];
        item.channelType = [rs stringForColumn:@"channelType"];
        item.channelURL = [rs stringForColumn:@"channleURL"];
        item.channelName = [rs stringForColumn:@"channelName"];
        [arr addObject:item];
        item = nil;
    }
    
    [rs close];
    [db close];
    
    return arr;

    
    
}

#pragma mark - get dbpath
- (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    return database_path;
}


@end
