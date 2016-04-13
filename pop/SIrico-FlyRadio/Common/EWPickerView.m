//
//  EWPickerView.m
//  test-pickerview
//
//  Created by Jin on 3/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "EWPickerView.h"

@implementation EWPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.showsSelectionIndicator = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSArray *arr = [self subviews];
    
    if ([SystemVersion intValue] >= 7) {
        UIImageView *v0 = arr[2];
        v0.backgroundColor = RED_COLOR;
        
        UIImageView *v1 = arr[1];
        v1.hidden = YES;
        
        UIImageView *v2 = arr[2];
        v2.hidden = YES;

        
    }else{
        UIView *v0 = arr[0];
        v0.hidden = YES;
        
        UIView *v1 = arr[1];
        v1.hidden = YES;
        
        UIView *v3 = arr[3];
        v3.hidden = YES;
        
        UIView *v4 = arr[4];
        v4.hidden = YES;
    
    }

//
//    
    UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fy_middlen_gunlun"]];
    indicator.frame = CGRectMake(0, (rect.size.height-59)/2.0, 320, 59);
    indicator.backgroundColor = CLEAR_COLOR;
    [self addSubview:indicator];
    
    [self setNeedsDisplay];
}


@end
