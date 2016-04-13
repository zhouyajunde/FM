//
//  SIClassifyEntity.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Easywork/Easywork.h>

@interface SIClassifyEntity : EWModelParse

@property (nonatomic, strong) NSString *classID;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *classImg;

- (NSDictionary *)attributeMapDictionary;


@end
