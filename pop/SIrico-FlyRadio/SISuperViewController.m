//
//  SISuperViewController.m
//  SIrico-FlyRadio
//
//  Created by fantasee on 14-3-2.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "SISuperViewController.h"
#import "SISettingViewController.h"
#import "SIUserCenterViewController.h"
#import "SIricoUtils.h"
#import "SIricoUIUtils.h"


#define TAG_SUPER_TITLE 23232
#define TAG_TOP_MENU_VIEW 23231
#define TAG_REFRESH_BUTTON 23233
#define TAG_HELP_VIEW 23234

@interface SISuperViewController ()

@end

@implementation SISuperViewController


- (UIColor *) defaultWhiteColor{
    return [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0f];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goMemberCenter
{
    SIUserCenterViewController * userCenterViewController = [[SIUserCenterViewController alloc] init];
    [self.navigationController pushViewController:userCenterViewController animated:YES];

}

- (void)goSetting
{
    SISettingViewController * settingViewController = [[SISettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)goToIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goClose
{


}

- (void) initTopMenuBysetTopMenuStyle: (int) theStyle setTopMenuTitle:(NSString *) theTitle{
    UIView * topMenuView = [[UIView alloc]init];
    topMenuView.frame = CGRectMake(0, StatusBarHeight, 320, 44);
    topMenuView.tag = TAG_TOP_MENU_VIEW;
    
    [self.view bringSubviewToFront:topMenuView];
    
     UIColor * backgroundColor = [[UIColor alloc]initWithRed:120.0/255.0 green:165/255.0 blue:59/255.0 alpha:1.0];
     topMenuView.backgroundColor = backgroundColor;
    
    if(kTopMenuStyleGoIndex == theStyle){
        UIButton * goToShouYeButton = [SIricoUIUtils getButtonByRect:CGRectMake(10, 6, 32, 32)];
        [goToShouYeButton setImage:[UIImage imageNamed:@"betatown_goindex.png"] forState:UIControlStateNormal];
        [goToShouYeButton setImage:[UIImage imageNamed:@"betatown_goindex_o.png"] forState:UIControlStateHighlighted];
        [goToShouYeButton addTarget:self action:@selector(goToIndex) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:goToShouYeButton];
        
        UIButton * rightButton = [SIricoUIUtils getButtonByRect:CGRectMake(278, 6, 32, 32)];
        [rightButton setImage:[UIImage imageNamed:@"fy_member.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"fy_member.png"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(goMemberCenter) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:rightButton];
      
    }else if(kTopMenuStyleGoBack == theStyle){
        UIButton * goToShouYeButton = [SIricoUIUtils getButtonByRect:CGRectMake(10, 6, 32, 32)];
        [goToShouYeButton setImage:[UIImage imageNamed:@"fy_back.png"] forState:UIControlStateNormal];
        [goToShouYeButton setImage:[UIImage imageNamed:@"fy_back.png"] forState:UIControlStateNormal];
        [goToShouYeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:goToShouYeButton];
        
        UIButton * rightButton = [SIricoUIUtils getButtonByRect:CGRectMake(278, 6, 32, 32)];
        [rightButton setImage:[UIImage imageNamed:@"fy_member.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"fy_member.png"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(goMemberCenter) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:rightButton];
        
    }else if(kTopMenuStyleLogIn == theStyle){
        UIButton * goToShouYeButton = [SIricoUIUtils getButtonByRect:CGRectMake(10, 6, 32, 32)];
        [goToShouYeButton setImage:[UIImage imageNamed:@"fy_back.png"] forState:UIControlStateNormal];
        [goToShouYeButton setImage:[UIImage imageNamed:@"fy_back.png"] forState:UIControlStateNormal];
//        [goToShouYeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:goToShouYeButton];
        
        UIButton * rightButton = [SIricoUIUtils getButtonByRect:CGRectMake(278, 6, 32, 32)];
        [rightButton setImage:[UIImage imageNamed:@"fy_member.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"fy_member.png"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(goMemberCenter) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:rightButton];
    
    }else if(kTopMenuStyleGoSet == theStyle){
        UIButton * goToShouYeButton = [SIricoUIUtils getButtonByRect:CGRectMake(10, 6, 32, 32)];
        [goToShouYeButton setImage:[UIImage imageNamed:@"fy_setting.png"] forState:UIControlStateNormal];
        [goToShouYeButton setImage:[UIImage imageNamed:@"fy_setting.png"] forState:UIControlStateNormal];
        [goToShouYeButton addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:goToShouYeButton];
        
        UIButton * rightButton = [SIricoUIUtils getButtonByRect:CGRectMake(278, 6, 32, 32)];
        [rightButton setImage:[UIImage imageNamed:@"fy_member.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"fy_member.png"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(goMemberCenter) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:rightButton];
    }else if (KTopMenuStylePop == theStyle){
        
        UIButton * goToShouYeButton = [SIricoUIUtils getButtonByRect:CGRectMake(10, 6, 32, 32)];
        [goToShouYeButton setImage:[UIImage imageNamed:@"fy_back.png"] forState:UIControlStateNormal];
        [goToShouYeButton setImage:[UIImage imageNamed:@"fy_back.png"] forState:UIControlStateNormal];
        [goToShouYeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:goToShouYeButton];
        
    }

    
    if(theTitle){
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(55, 8, 210, 26);
        titleLabel.text = theTitle;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = TAG_SUPER_TITLE;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [titleLabel setTextColor:[self defaultWhiteColor]];
        [topMenuView addSubview:titleLabel];
    
    }
    
    [self.view addSubview:topMenuView];
}


- (void) showTopMenuWithStyle: (int) theStyle withTitle:(NSString *) theTitle{
    [self initTopMenuBysetTopMenuStyle:theStyle setTopMenuTitle:theTitle];
}

- (void) resetTopMenuTitle:(NSString *) theTitle{
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:TAG_SUPER_TITLE];
    if(titleLabel){
        CGSize titleSize = [theTitle sizeWithFont:titleLabel.font];
        titleLabel.frame = CGRectMake((320 - titleSize.width)/2, 8, titleSize.width, 26);
        titleLabel.text = theTitle;
    }
}

//查找菜单View
- (UIView *) getTopMenuView{
    return [self.view viewWithTag:TAG_TOP_MENU_VIEW];
}

#pragma mark - View Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 320, 20);
    [label setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:label];
    
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, 320, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"fy_background.png"];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
  
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIFont *) defaultStaticFontWithType:(int) fontType withSize:(float) fontSize{
    if(fontType ==1){
        return [UIFont boldSystemFontOfSize:fontSize];
    }else {
    	return  [UIFont fontWithName:@"MicrosoftYaHei" size:fontSize];
    }
}

- (void) addHelpViewWithImageUrl:(NSString *) theHelpImageUrl withSign:(NSString *) theSign{
    //只显示一次
    NSString * storedSign = [SIricoUtils getStringFromUserDefaults:theSign];
    if(storedSign){
        return;
    }else {
        [SIricoUtils storeStringInUserDefaults:theSign string:theSign];
    }
    
    UIImageView * helpImageView = [[UIImageView alloc]init];
    helpImageView.frame = self.view.bounds;
    helpImageView.tag = TAG_HELP_VIEW;
    helpImageView.userInteractionEnabled = YES;
    helpImageView.image = [UIImage imageNamed:theHelpImageUrl];
    
    //[[UIApplication sharedApplication].keyWindow bringSubviewToFront:helpImageView];
    
    UITapGestureRecognizer *closeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapForCloseHelpView:)];
    [helpImageView addGestureRecognizer:closeGestureRecognizer];
  
    
    [self.view addSubview:helpImageView];

}

#pragma mark TapDetectingImageViewDelegate methods
- (void) handleSingleTapForCloseHelpView:(UIGestureRecognizer *)gestureRecognizer {
    UIImageView * helpImageView  = (UIImageView *)[self.view viewWithTag:TAG_HELP_VIEW];
    if(self){
        [UIView beginAnimations:@"fadeout" context:(__bridge void *)([NSNumber numberWithFloat:helpImageView.layer.opacity])];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDidStopSelector:@selector(animationDidStopForCloseHelpView:finished:context:)];
        [UIView setAnimationDelegate:self];
        helpImageView.layer.opacity = 0;
        [UIView commitAnimations];
    }
}

- (void)animationDidStopForCloseHelpView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    UIImageView * helpImageView  = (UIImageView *)[self.view viewWithTag:TAG_HELP_VIEW];
    if(self){
        if ([animationID isEqualToString:@"fadeout"]) {
            // Restore the opacity
            CGFloat originalOpacity = [(__bridge NSNumber *)context floatValue];
            helpImageView.layer.opacity = originalOpacity;
            [helpImageView removeFromSuperview];
//            [(NSNumber *)context release];
        }
    }
}







@end
