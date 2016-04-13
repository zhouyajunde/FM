//
//  ReturnDeviceType.h
//  manyouren
//
//  Created by GX on 11/6/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"
#import "GlobalDefine.h"
@interface ReturnDeviceType : NSObject

+ (NSString*)deviceString;

+ (CGRect)sizeOfScreen;

@end
