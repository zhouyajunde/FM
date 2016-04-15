//
//  NJSettingTool.m
//  01-ItcastLottery
//
//  Created by 李南江 on 14-5-10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#define ILUserDefaults [NSUserDefaults standardUserDefaults]

#import "NJSettingTool.h"

@implementation NJSettingTool
+ (void)setBool:(BOOL)b forKey:(NSString *)key
{
    [ILUserDefaults setBool:b forKey:key];
    [ILUserDefaults synchronize];
}

+ (BOOL)boolForKey:(NSString *)key
{
    return [ILUserDefaults boolForKey:key];
}

+ (void)setObject:(id)obj forKey:(NSString *)key
{
    [ILUserDefaults setObject:obj forKey:key];
    [ILUserDefaults synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    return [ILUserDefaults objectForKey:key];
}
@end
