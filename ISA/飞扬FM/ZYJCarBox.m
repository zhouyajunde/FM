//
//  ZYJCarBox.m
//  飞扬FM
//
//  Created by Mac os on 16/1/15.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJCarBox.h"

@implementation ZYJCarBox

+(instancetype)carBox
{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ZYJCarBox" owner:nil options:nil];
    return [array firstObject];
}

- (IBAction)carChanged:(id)sender {
    
    NSLog(@"5555");
    
    if (_norBtn.enabled) {
        //        选中
        _norBtn.enabled = NO;
        _carBtn.enabled = YES;
//        [_norBtn setImage:[UIImage imageNamed:@"register_checked.png"] forState:UIControlStateNormal];
    }else
    {
        //        选中
        _norBtn.enabled = YES;
        _carBtn.enabled = NO;
        
//        [_carBtn setImage:[UIImage imageNamed:@"register_check"] forState:UIControlStateNormal];
    }

}
@end
