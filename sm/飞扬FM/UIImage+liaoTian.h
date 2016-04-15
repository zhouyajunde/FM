//
//  UIImage+liaoTian.h
//  飞扬FM
//
//  Created by Mac os on 16/3/11.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (liaoTian)

/**
 *  传入图片的名称,返回一张可拉伸不变形的图片
 *
 *  @param imageName 图片名称
 *
 *  @return 可拉伸图片
 */
+ (UIImage *)resizableImageWithName:(NSString *)imageName;

@end
