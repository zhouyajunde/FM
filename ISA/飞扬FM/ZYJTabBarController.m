//
//  ZYJTabBarController.m
//  飞扬FM
//
//  Created by Mac os on 16/2/17.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJTabBarController.h"
#import "ZYJmusic.h"
#import "HMMusicTool.h"
#import "MBProgressHUD+NJ.h"

@interface ZYJTabBarController ()<openDetegate>

@end

@implementation ZYJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImage* tabBarBackground = [UIImage imageNamed:@"bottom_player_bg.png"]; //需要的图片
//    
//    UIImage* tabBarShadow = [UIImage imageNamed:@"bottom_player_bg.png"]; //需要的图片
//    
//    [[UITabBar appearance] setShadowImage:tabBarBackground];
//    
//    [[UITabBar appearance] setBackgroundImage:tabBarShadow];
    // 1.创建tabbar
    ZYJmusic  *uiv= [[ZYJmusic alloc]init];
    
    uiv.delegate = self;
    uiv.frame = CGRectMake(0, 0, self.tabBar.bounds.size.width, self.tabBar.bounds.size.height);
    
    [self.tabBar addSubview:uiv];
}

-(void)touch:(UIViewController *)con
{
    if ([HMMusicTool playingMusic] == nil) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"您还没有收听"];
        return;
    }
    [self presentViewController:con animated:YES completion:nil];
}

@end
