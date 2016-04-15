//
//  UIImage+Image.h
//  01-BuDeJie
//
//  Created by 1 on 15/12/17.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
// 提供一个加载原始图片方法
+ (instancetype)imageNamedWithOriganlMode:(NSString *)imageName;

// 加载拉伸中间1个像素图片
- (instancetype)stretchableImage;

- (instancetype)bs_circleImage;

+ (instancetype)bs_circleImageNamed:(NSString *)name;
@end
