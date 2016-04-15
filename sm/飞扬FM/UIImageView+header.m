//
//  UIImageView+header.m
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "UIImageView+header.h"
#import "UIImageView+WebCache.h"
#import "UserDefine.h"

@implementation UIImageView (header)

-(void)zyj_setHeader:(NSString *)url{
    
    // 占位图片
    UIImage *placeholder = [UIImage imageNamed:@"diantai_default.png"];
    
    // 下载图片
    
    NSString *filrfileURL = zongdizhiURL;
    NSString *urlStr = [filrfileURL stringByAppendingString:[NSString stringWithFormat:@"%@",url]];
   

    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        
        self.image = image;
    }];
    
//    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholder];
}

@end
