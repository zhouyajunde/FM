//
//  SIDBManger.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/25/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SIChannelInfoEntity;
@class SIAreaEntity;

@interface SIDBManger : NSObject

+ (instancetype)shareManger;

- (void)createChannelDB;
- (void)insertData:(SIChannelInfoEntity *)item;

- (NSMutableArray *)getChannelWithAreaID:(NSString *)areaID;
- (NSMutableArray *)getChannelWithFenLeiID:(NSString *)fenlei;
- (NSMutableArray *)getAllChannel;


- (void)createAreaDB;
- (void)insertAreaData:(SIAreaEntity *)item;
- (NSMutableArray *)getAllArea;

- (NSString *)getAreanameWithAreaID:(NSString *)aid;
- (NSString *)getAreaIdWithAreaName:(NSString *)areaName;


- (NSMutableArray *)getAllCollection;

@end
