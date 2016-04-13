//
//  SIAreaEntity.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Easywork/Easywork.h>

@interface SIAreaEntity : EWModelParse

@property (nonatomic, strong) NSString *areaID;
@property (nonatomic, strong) NSString *areaName;

- (NSDictionary *)attributeMapDictionary;

@end
