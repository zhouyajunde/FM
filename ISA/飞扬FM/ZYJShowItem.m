//
//  ZYJShowItem.m
//  飞扬FM
//
//  Created by Mac os on 16/1/19.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJShowItem.h"

@implementation ZYJShowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    ZYJShowItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}

+ (instancetype)itemWithsubtitle:(NSString *)subtitle title:(NSString *)title{
    
    ZYJShowItem *item = [[self alloc] init];
    item.subtitle = subtitle;
    item.title = title;
    return item;

}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title];
}
@end
