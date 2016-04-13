//
//  textfd.m
//  snctc
//
//  Created by Mac os on 16/2/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "textfd.h"

@implementation textfd


//控制placeHolder 的位置，左右缩 8px
-(CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds , 13.5 , 0 );
}

// 控制文本的位置，左右缩 8px
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds , 13.5 , 0 );
}

//- (CGRect)placeholderRectForBounds:(CGRect)bounds
//
//{
//    
//    return CGRectMake(75, 0, bounds.size.width - 75, bounds.size.height);
//    
//}
@end
