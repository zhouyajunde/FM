//
//  SIShowInfoEntity.m
//  SIrico-FlyRadio
//
//  Created by Jin on 3/27/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIShowInfoEntity.h"

@implementation SIShowInfoEntity

- (NSDictionary *)attributeMapDictionary
{
    return @{@"showID":@"jmdid",
             @"startTime":@"starttime",
             @"endTime":@"endtime",
             @"showName":@"jmdname",
             @"showZC":@"zc"};
}

@end
