//
//  ZYJSettingSwitchItem.m
//  飞扬FM
//
//  Created by Mac os on 16/1/22.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJSettingSwitchItem.h"
#import "NJSettingTool.h"

@implementation ZYJSettingSwitchItem

- (void)setKey:(NSString *)key
{
    [super setKey:key];
    
    _off = [NJSettingTool boolForKey:key];
}

- (void)setOff:(BOOL)off
{
    _off = off;
    
    [NJSettingTool setBool:off forKey:self.key];
}


@end
