//
//  musicModel.h
//  飞扬FM
//
//  Created by Mac os on 15/12/31.
//  Copyright © 2015年 Mac os. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface musicModel : NSObject

@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *fm;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSArray *jiemu;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *url;

+(instancetype)productWithDict:(NSDictionary *)dict;

@end
