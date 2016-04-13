//
//  FMDatabaseUtils.h
//  betatown-ios-sml
//
//  Created by Zhengjun wu on 11-12-7.
//  Copyright (c) 2011年 www.betatown.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface FMDatabaseUtils : NSObject

//创建数据库，如果必要时
-(FMDatabase *) createDatabaseIfNeeded;
-(void) initDB: (FMDatabase *) database;

-(void) clearMemberData:(FMDatabase *) database;

@end
