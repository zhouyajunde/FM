//
//  SICollectInfoEntity.m
//  SIrico-FlyRadio
//
//  Created by fantasee on 14-3-5.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "SICollectInfoEntity.h"

@implementation SICollectInfoEntity

- (NSDictionary *)attributeMapDictionary
{
    return @{@"channelID":@"channelID",
             @"channelAreaID":@"channelAreaID",
             @"channelType":@"channelFenLei",
             @"channelFm":@"channelFm",
             @"channelName":@"channelName",
             @"channleURL":@"channelUrl"};
}



@end
