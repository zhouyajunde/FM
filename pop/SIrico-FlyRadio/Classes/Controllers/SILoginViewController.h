//
//  SILoginViewController.h
//  SIrico-FlyRadio
//
//  Created by fantasee on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SISuperViewController.h"
#import "MBProgressHUD.h"
@class TPKeyboardAvoidingScrollView;

@interface SILoginViewController : SISuperViewController<UITextFieldDelegate>
{
    TPKeyboardAvoidingScrollView *  bgView;
    UITextField * idTextField;
    UITextField * passwordTextField;
    MBProgressHUD * progressHud;
}

@end
