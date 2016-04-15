//
//  PreHelper.m
//  PreSchoolCards
//
//  Created by siyo on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PreHelper.h"



@implementation PreHelper

// if it's the first time to launch the app
// if true, show user action description


// get the max cards that can be created


// clear user action cache
// remove images & sound file that deleted by user from app Document Path


// convert hex color string to UIColor object
+ (UIColor *)colorWithHexString: (NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIImage *)resizeCImage:(UIImage *)image toSize:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    
    NSLog(@"WIDTH IN RESIZED FUN ====%f",width);
    
    UIGraphicsBeginImageContext(size);
    
    float x = 0.0f;
    float y = 0.0f;
    
    /**
     if (image.size.width<size.width) {
     x = size.width/2 - image.size.width/2;
     }
     
     if (image.size.height<size.height) {
     y = size.height/2 - image.size.height/2;
     }
     //*/
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    [image drawInRect: rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();   
    
    return newImage;
}


+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    float width = image.size.width<size.width ? image.size.width : size.width;
    float height = size.height;
    
    NSLog(@"WIDTH IN RESIZED FUN ====%f",width);
    
    UIGraphicsBeginImageContext(size);
    
    float x = 0.0f;
    float y = 0.0f;
    
    /**
    if (image.size.width<size.width) {
        x = size.width/2 - image.size.width/2;
    }
    
    if (image.size.height<size.height) {
        y = size.height/2 - image.size.height/2;
    }
     //*/
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    [image drawInRect: rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();   
    
    return newImage;
}

+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size withTime:(float)time
{
    float width = image.size.width*time<size.width ? image.size.width*time : size.width;
    float height = size.height;
    
    NSLog(@"WIDTH IN RESIZED FUN ====%f",width);
    
    UIGraphicsBeginImageContext(size);
    
    float x = 0.0f;
    float y = 0.0f;
    
    /**
     if (image.size.width<size.width) {
     x = size.width/2 - image.size.width/2;
     }
     
     if (image.size.height<size.height) {
     y = size.height/2 - image.size.height/2;
     }
     //*/
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    [image drawInRect: rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();   
    
    return newImage;
}


@end
