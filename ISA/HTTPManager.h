//
//  HTTPManager.h
//  SIrico-FlyRadio
//
//  Created by bjsmit01 on 14-3-28.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "AFHTTPClient.h"

extern NSString *const BASE_URL;

@interface HTTPManager : AFHTTPClient

+ (instancetype)shareManager;

@end
