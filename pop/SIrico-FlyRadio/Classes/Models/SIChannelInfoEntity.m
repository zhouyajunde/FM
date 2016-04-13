//
//  SIChannelInfoEntity.m
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIChannelInfoEntity.h"

@implementation SIChannelInfoEntity

- (NSDictionary *)attributeMapDictionary
{
    return @{@"channelID":@"channelID",
             @"channelAreaID":@"channelAreaID",
             @"channelType":@"channelFenLei",
             @"channelFm":@"channelFm",
             @"channelName":@"channelName",
             @"channelURL":@"channelUrl"};
}

@end
