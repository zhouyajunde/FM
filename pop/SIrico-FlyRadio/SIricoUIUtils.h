//
//  BetaTownUIUtils.h
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIricoUIUtils : NSObject

+ (UIView *) findView:(UIView *)aView withName:(NSString *)name;

+ (UIButton *) getButtonByTitle:(NSString *) title byRect:(CGRect) rect;

+ (UIButton *) getButtonByRect:(CGRect) rect;
+ (UIButton *) getFenseButtonByTitle:(NSString *) title byRect:(CGRect) rect;

@end
