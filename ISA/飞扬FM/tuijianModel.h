//
//  tuijianModel.h
//  飞扬FM
//
//  Created by Mac os on 16/1/7.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tuijianModel : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *icon;

+(instancetype)productWithDict:(NSDictionary *)dict;

@end
