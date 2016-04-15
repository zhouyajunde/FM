//
//  BSHeader.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/23.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "BSHeader.h"
#import "UIView+Extension.h"

@interface BSHeader()
/** logo */
@property (nonatomic, weak) UIImageView *logo;
@end

@implementation BSHeader

// 初始化
- (void)prepare
{
    [super prepare];
    
    self.automaticallyChangeAlpha = YES;
    self.stateLabel.textColor = [UIColor whiteColor];
    self.lastUpdatedTimeLabel.hidden = NO;
 
    UIImageView *logo = [[UIImageView alloc] init];
    logo.contentMode = UIViewContentModeCenter;
    logo.image = [UIImage imageNamed:@"MainTitle"];
    [self addSubview:logo];
     self.logo = logo;
}

// 摆放子控件
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.logo.frame = CGRectMake(0, -60, self.width, 60);
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//}

@end
