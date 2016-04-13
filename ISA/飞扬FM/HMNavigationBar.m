//
//  HMNavigationBar.m
//  原创网易新闻
//
//  Created by apple on 14-7-28.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMNavigationBar.h"
#import "UIView+Extension.h"

@implementation HMNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundImage:[UIImage imageNamed:@"NavBar64@2x"] forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIButton *button in self.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;

        if (button.centerX < self.width * 0.5) { // 左边的按钮
            button.x = 0;
        } else if (button.centerX > self.width * 0.5) { // 右边的按钮
            button.x = self.width - button.width;
        }
    }
}
@end
