//
//  ZYJslider.m
//  飞扬FM
//
//  Created by Mac os on 16/2/19.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJslider.h"

@implementation ZYJslider

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    //左右轨的图片
    UIImage *stetchLeftTrack= [UIImage imageNamed:@"player_jiemu_name_nav.png"];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"player_jinduu.png"];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"player_jindu_point.png"];
    
    
    self.backgroundColor = [UIColor clearColor];
    self.value=1.0;
    self.minimumValue=0.7;
    self.maximumValue=1.0;
    [self setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [self setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
    //滑块拖动时的事件
    [self addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [self addTarget:self action:@selector(sliderDragUp) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)sliderDragUp{
    NSLog(@"sliderDragUp");
}
-(void)sliderValueChanged{
    NSLog(@"sliderValueChanged");
}



@end
