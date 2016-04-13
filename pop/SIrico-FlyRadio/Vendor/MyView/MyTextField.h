//
//  MyTextField.h
//  betatown-ios-sunshine
//
//  Created by zhangtao on 9/29/13.
//  Copyright (c) 2013 fantasee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextField : UITextField{
    UIColor *placeHolderColor;
    float placeHolderFontSize;
}

@property(nonatomic, retain) UIColor *placeHolderColor;
@property(nonatomic, assign) float placeHolderFontSize;

@end
