//
//  PreHelper.h
//  PreSchoolCards
//
//  Created by siyo on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface PreHelper : NSObject

#define PATH_RECODING [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Recode"]
#define PATH_IMAGES [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images"]

//+(BOOL)isFirstLaunch;
//+(NSInteger)getMaxCardNumber;
//+(BOOL)clearCache;
+ (UIColor *)colorWithHexString: (NSString *)stringToConvert;
+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)resizeCImage:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size withTime:(float)time;

@end
