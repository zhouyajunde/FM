//
//  NJNavigationController.m
//  01-ItcastLottery
//
//  Created by 李南江 on 14-5-10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NJNavigationController.h"
#import "HMNavigationBar.h"
#import "UIBarButtonItem+Item.h"

#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface NJNavigationController ()

@end

@implementation NJNavigationController

#pragma mark 一个类只会调用一次
+ (void)initialize
{
    // 1.取出设置主题的对象
//    HMNavigationBar *navBar = [HMNavigationBar appearance];
//    NJBar *navBar = [[NJBar alloc]init];
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];

    // 2.设置导航栏的背景图片
    NSString *navBarBg = nil;
    if (iOS7) { // iOS7
        navBarBg = @"top-bg-640-128";
        // 设置导航栏的渐变色为白色（iOS7中返回箭头的颜色变为这个颜色：白色）
        navBar.tintColor = [UIColor whiteColor];
        
    } else { // 非iOS7
        
        navBarBg = @"top-bg-640-48";
      
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
        
        // 设置导航栏按钮的背景图片
        [barItem setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [barItem setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        // 设置导航栏返回按钮的背景图片
        [barItem setBackButtonBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [barItem setBackButtonBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted
                                   barMetrics:UIBarMetricsDefault];
    }
    
    [navBar setBackgroundImage:[UIImage imageNamed:@"top-bg-640-128"] forBarMetrics:UIBarMetricsDefault];
    
    // 3.设置导航栏标题颜色为白色
    [navBar setTitleTextAttributes:@{
            UITextAttributeTextColor : [UIColor whiteColor]
    }];
    
    // 4.设置导航栏按钮文字颜色为白色
    [barItem setTitleTextAttributes:@{
            UITextAttributeTextColor : [UIColor whiteColor],
            UITextAttributeFont : [UIFont systemFontOfSize:13]
    } forState:UIControlStateNormal];
    
//    先做一张全通道全透明的图片1*1的像素就行，取名navigation_bar_background.png作为UINavigationBar的背景色，然后讲barStyle设置成通道就可以了。
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_background.png"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

}

#pragma mark 控制状态栏的样式
/*
 状态栏的管理：
 1> iOS7之前：UIApplication
 2> iOS7开始：交给对应的控制器去管理
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    // 白色样式
    return UIStatusBarStyleLightContent;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
        
        viewController.hidesBottomBarWhenPushed = NO;
//返回按钮的定制
        UIBarButtonItem *backItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"back"] highImage:[UIImage imageNamed:@"back"] target:self action:@selector(back) norColor:[UIColor blackColor] highColor:[UIColor clearColor] title:@""];
        
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    // self -> 导航控制器
    [self popViewControllerAnimated:YES];
    
}


@end