//
//  NSDictionary+Extension.m
//  飞扬FM
//
//  Created by Mac os on 16/1/14.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)


+ (NSDictionary *)safeDictionaryWithDic:(NSDictionary *)dic{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [mutableDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null] || obj == nil) {
            [mutableDic removeObjectForKey:key];
            [mutableDic setObject:@"" forKey:key];
        }
    }];
    
    return [[NSDictionary alloc] initWithDictionary:mutableDic];
}

@end
