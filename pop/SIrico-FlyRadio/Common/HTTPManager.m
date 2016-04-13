//
//  HTTPManager.m
//  SIrico-FlyRadio
//
//  Created by bjsmit01 on 14-3-28.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "HTTPManager.h"

NSString *const BASE_URL = @"http://121.42.14.252:8081";

@implementation HTTPManager

+ (instancetype)shareManager
{
    static HTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTTPManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    return manager;
}

@end
