//
//  FMDatabaseUtils.m
//  betatown-ios-sml
//
//  Created by Zhengjun wu on 11-12-7.
//  Copyright (c) 2011年 www.betatown.cn. All rights reserved.
//

#import "FMDatabaseUtils.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "SICollectInfoDao.h"
#import "SIricoUtils.h"


@implementation FMDatabaseUtils

//创建数据库，如果必要时
-(FMDatabase *) createDatabaseIfNeeded{
    //取用户目录，有可能是手机上的目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath =[NSString stringWithFormat:@"%@%@",documentDirectory,@"/betatown_database.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    //NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isThreadSafe] ? @"Yes" : @"No");
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    return db;
}

-(void) clearMemberData:(FMDatabase *) database{
//    [BetaTownUtils removeStringFromUserDefaults:kSettingOfMemberNo];
//    [BetaTownUtils removeStringFromUserDefaults:kSettingOfMemberToken];
    
    [database beginTransaction];
    [database executeUpdate:@"DELETE FROM t_member;"];
    [database executeUpdate:@"DELETE FROM t_member_card;"];
    [database executeUpdate:@"DELETE FROM t_member_card_info;"];
    [database executeUpdate:@"DELETE FROM t_shop_list;"];
    [database executeUpdate:@"DELETE FROM t_shop_detail;"];
    //[database executeUpdate:@"DELETE FROM t_my_activity;"];
    [database executeUpdate:@"DELETE FROM t_my_recommend;"];
    [database executeUpdate:@"DELETE FROM t_my_share;"];
    //[database executeUpdate:@"DELETE FROM t_task;"];
    
    [database commit];
}


//初始化数据库表
-(void) initDB: (FMDatabase *) database{
    NSLog(@"init db start ....");
    [database beginTransaction];
    [database executeUpdate:@"DROP TABLE IF EXISTS t_collect;"];
//    [database executeUpdate:@"DROP TABLE IF EXISTS t_mall;"];
//	[database executeUpdate:@"DROP TABLE IF EXISTS t_activity;"];
    

//    [BetaTownUtils removeStringFromUserDefaults:kMallLastUpdateTime];
//    [BetaTownUtils removeStringFromUserDefaults:kLastestUpdateTime_Recommend];
//    [BetaTownUtils removeStringFromUserDefaults:kBrandLastUpdataTime];

    
    [database executeUpdate:[SICollectInfoDao getCreateSQL]];
//    [database executeUpdate:[BetaTownShareDao getCreateSQL]];
//    [database executeUpdate:[BetaTownBusinessGroupDao getCreateSQL]];
//    [database executeUpdate:[BetaTownMemberDao getCreateSQL]];


    
    [database commit];
    //初始化数据
    
//    DataInitializer * dataInitializer = [[DataInitializer alloc]init];
//    [dataInitializer initDataForFirstTime:database];
//    [dataInitializer release];
    NSLog(@"init db end ");
}

@end
