//
//  SIJPEntity.h
//  SIrico-FlyRadio
//
//  Created by Jin on 8/10/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Easywork/Easywork.h>

@interface SILPEntity : EWModelParse
@property (nonatomic, strong) NSString *lpid;
@property (nonatomic, strong) NSString *lpimg;
@property (nonatomic, strong) NSString *lpjifen;
@property (nonatomic, strong) NSString *lpname;

- (NSDictionary *)attributeMapDictionary;

@end
