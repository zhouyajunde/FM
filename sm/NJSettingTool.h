//
//  NJSettingTool.h
//  01-ItcastLottery
//
//  Created by 李南江 on 14-5-10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJSettingTool : NSObject
+ (void)setBool:(BOOL)b forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
@end
