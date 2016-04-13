//
//  SICollectInfoEntity.h
//  SIrico-FlyRadio
//
//  Created by fantasee on 14-3-5.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import <Easywork/Easywork.h>

#define Collect_TABLE @"t_collect"
#define Collect_ID @"_ID"
// 服务器ID
#define Collect_channelID @"channelID"
#define Collect_channelName @"channelName"
#define Collect_channelFm @"channelFm"
#define Collect_channleURL @"channleURL"
#define Collect_channelAreaID @"channelAreaID"
#define Collect_channelType @"channelType"


@interface SICollectInfoEntity : EWModelParse

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *channelFm;
@property (nonatomic, strong) NSString *channleURL;
@property (nonatomic, strong) NSString *channelAreaID;
@property (nonatomic, strong) NSString *channelType;

- (NSDictionary *)attributeMapDictionary;

@end
