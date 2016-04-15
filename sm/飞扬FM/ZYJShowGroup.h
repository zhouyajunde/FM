//
//  ZYJShowGroup.h
//  飞扬FM
//
//  Created by Mac os on 16/1/19.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYJShowGroup : NSObject

@property (nonatomic, copy) NSString *header; // 头部标题
@property (nonatomic, copy) NSString *footer; // 尾部标题
@property (nonatomic, strong) NSArray *items; // 中间的条目

+ (instancetype)groupWithItems:(NSArray *)items;


@end
