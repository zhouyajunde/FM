//
//  ZYJShowGroup.m
//  飞扬FM
//
//  Created by Mac os on 16/1/19.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJShowGroup.h"

@implementation ZYJShowGroup


+ (instancetype)groupWithItems:(NSArray *)items
{
    ZYJShowGroup *group = [[self alloc] init];
    group.items = items;
    return group;
}


@end
