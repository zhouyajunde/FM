//
//  musicModel.m
//  飞扬FM
//
//  Created by Mac os on 15/12/31.
//  Copyright © 2015年 Mac os. All rights reserved.
//

#import "musicModel.h"

@implementation musicModel

+(instancetype)productWithDict:(NSDictionary *)dict{
    
    musicModel *p = [[self alloc]init];
    p.desc = dict[@"desc"];
    p.fm = dict[@"fm"];
    p.userid = dict[@"userid"];
    p.img = dict[@"img"];
    p.jiemu = dict[@"jiemu"];
    p.name = dict[@"name"];
    p.type = dict[@"type"];
    p.url = dict[@"url"];
    return p;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"])
        self.userid = value;
}

@end
