//
//  MyTextField.m
//  betatown-ios-sunshine
//
//  Created by zhangtao on 9/29/13.
//  Copyright (c) 2013 fantasee. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

@synthesize placeHolderColor;
@synthesize placeHolderFontSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) drawPlaceholderInRect:(CGRect)rect {
    [self.placeHolderColor setFill];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        [[self placeholder] drawInRect:CGRectMake(rect.origin.x, rect.origin.y+5, rect.size.width, rect.size.height) withFont:[UIFont systemFontOfSize:self.placeHolderFontSize]];
    }else{
        [[self placeholder] drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) withFont:[UIFont systemFontOfSize:self.placeHolderFontSize]];
    }
}

@end
