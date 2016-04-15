//
//  ZYJItem.m
//  飞扬FM
//
//  Created by Mac os on 16/1/20.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJItem.h"

@implementation ZYJItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subtitle
{
    ZYJItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.subtitle = subtitle;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title subTitle:nil];
}

@end
