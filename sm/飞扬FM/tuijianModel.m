//
//  tuijianModel.m
//  飞扬FM
//
//  Created by Mac os on 16/1/7.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "tuijianModel.h"

@implementation tuijianModel

+(instancetype)productWithDict:(NSDictionary *)dict
{
    tuijianModel *p = [[self alloc]init];
    p.title = dict[@"title"];
    
    p.icon = dict[@"icon"];
    return p;
}
@end
