//
//  ZYJSexBox.m
//  飞扬FM
//
//  Created by Mac os on 16/1/15.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJSexBox.h"

@implementation ZYJSexBox

+(instancetype)sexBox
{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ZYJSexBox" owner:nil options:nil];
    
    return  [array firstObject];
}

- (IBAction)sexChanged:(id)sender {
    
    if (_manBtn.enabled) {
        //        选中男
        _manBtn.enabled = NO;
        _womanBtn.enabled = YES;
    }else
    {
        //        选中女
        _manBtn.enabled = YES;
        _womanBtn.enabled = NO;
    }

}
@end
