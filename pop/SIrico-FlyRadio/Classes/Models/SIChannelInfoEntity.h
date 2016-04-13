//
//  SIChannelInfoEntity.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Easywork/Easywork.h>

@interface SIChannelInfoEntity : EWModelParse

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *channelFm;
@property (nonatomic, strong) NSString *channelURL;
@property (nonatomic, strong) NSString *channelAreaID;
@property (nonatomic, strong) NSString *channelType;


- (NSDictionary *)attributeMapDictionary;

@end
