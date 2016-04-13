//
//  SIShowInfoEntity.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/27/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Easywork/Easywork.h>

@interface SIShowInfoEntity : EWModelParse

@property (nonatomic, strong) NSString *showID;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *showName;
@property (nonatomic, strong) NSString *showZC;

- (NSDictionary *)attributeMapDictionary;

@end
