//
//  ZYJItem.h
//  飞扬FM
//
//  Created by Mac os on 16/1/20.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYJItem : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) void (^operation)() ; // 点击cell后要执行的操作

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subtitle;

+ (instancetype)itemWithTitle:(NSString *)title;


@end
