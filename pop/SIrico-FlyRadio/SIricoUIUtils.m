//
//  BetaTownUIUtils.m
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SIricoUIUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "UIGlossyButton.h"
#import "SISuperViewController.h"

@implementation SIricoUIUtils

#pragma mark get/show the UIView we want
//Find the view we want in camera structure.
+ (UIView *)findView:(UIView *)aView withName:(NSString *)name{
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([name isEqualToString:desc]){
		return aView;
    }
	for (NSUInteger i = 0; i < [aView.subviews count]; i++){
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;	
}

+ (UIButton *) getButtonByTitle:(NSString *) title byRect:(CGRect) rect{
    UIGlossyButton * button = [[UIGlossyButton alloc]init];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [SISuperViewController defaultStaticFontWithType:0 withSize:13];
    [button useWhiteLabel: YES];
    button.tintColor = [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0f];
   // button.tintColor = [UIColor colorWithRed:200.0/255.0 green:100.0/255.0 blue:210.0/255.0 alpha:1.0f];
    [button setGradientType:kUIGlossyButtonGradientTypeLinearSmoothExtreme];
    //[button setStrokeType: kUIGlossyButtonStrokeTypeGradientFrame];
    return button;
}

+ (UIButton *) getFenseButtonByTitle:(NSString *) title byRect:(CGRect) rect
{
    UIGlossyButton * button = [[UIGlossyButton alloc]init];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [SISuperViewController defaultStaticFontWithType:0 withSize:13];
    [button useWhiteLabel: YES];
     button.tintColor = [UIColor colorWithRed:200.0/255.0 green:100.0/255.0 blue:210.0/255.0 alpha:1.0f];
    [button setGradientType:kUIGlossyButtonGradientTypeLinearSmoothExtreme];
    //[button setStrokeType: kUIGlossyButtonStrokeTypeGradientFrame];
    return button;

}
+ (UIButton *) getButtonByRect:(CGRect) rect{
    UIButton * button = [[UIButton alloc]init];
    [button setBackgroundColor:[UIColor clearColor]];
    button.frame = rect;    
    return button;
}


@end
