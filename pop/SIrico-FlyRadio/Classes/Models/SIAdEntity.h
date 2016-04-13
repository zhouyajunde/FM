//
//  SIAdEntity.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Easywork/Easywork.h>

@interface SIAdEntity : EWModelParse

@property (nonatomic, strong) NSString *adID;
@property (nonatomic, strong) NSString *adName;
@property (nonatomic, strong) NSString *adImg;

- (NSDictionary *)attributeMapDictionary;

@end
