//
//  SISuperViewController.h
//  SIrico-FlyRadio
//
//  Created by fantasee on 14-3-2.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTopMenuStyleGoIndex 1
#define kTopMenuStyleGoBack  2
#define kTopMenuStyleNoButton 3
#define kTopMenuStyleGoClose 4
#define kTopMenuStyleGoSet   5
#define kTopMenuStyleLogIn   6
#define KTopMenuStylePop     7


@interface SISuperViewController : UIViewController

+ (UIFont *) defaultStaticFontWithType:(int) fontType withSize:(float) fontSize;

- (void) showTopMenuWithStyle: (int) theStyle withTitle:(NSString *) theTitle;

- (void) resetTopMenuTitle:(NSString *) theTitle;

- (void) addHelpViewWithImageUrl:(NSString *) theHelpImageUrl withSign:(NSString *) theSign;
- (UIView *) getTopMenuView;

@end
