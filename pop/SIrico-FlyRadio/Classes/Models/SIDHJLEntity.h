//
//  SIDHJLEntity.h
//  SIrico-FlyRadio
//
//  Created by Jin on 8/10/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Easywork/Easywork.h>

@interface SIDHJLEntity : EWModelParse

@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *jifen;
@property (nonatomic, strong) NSString *lpname;

- (NSDictionary *)attributeMapDictionary;


@end
