//
//  scModel.h
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface scModel : NSObject

@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *fm;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSArray *jiemu;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *name;

//+(instancetype)shoucangWithDict:(NSDictionary *)dict;

@end
