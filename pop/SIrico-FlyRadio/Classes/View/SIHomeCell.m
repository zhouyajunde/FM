//
//  SIHomeCell.m
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIHomeCell.h"
#import "SIClassifyEntity.h"

@implementation SIHomeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_imageView];
        
    }
    return self;
}


- (void)setHomeCell:(SIClassifyEntity *)entity
{
  
    [_imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,entity.classImg]]];
}

- (void)layoutSubviews
{
    _imageView.frame = CGRectMake(0, 0, 104, 97.5);
}

@end
