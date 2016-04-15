//
//  UIImage+liaoTian.m
//  飞扬FM
//
//  Created by Mac os on 16/3/11.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "UIImage+liaoTian.h"

@implementation UIImage (liaoTian)


+ (UIImage *)resizableImageWithName:(NSString *)imageName
{
    
    // 加载原有图片
    UIImage *norImage = [UIImage imageNamed:imageName];
    // 获取原有图片的宽高的一半
    CGFloat w = norImage.size.width * 0.5;
    CGFloat h = norImage.size.height * 0.5;
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    
    return newImage;
}


@end
