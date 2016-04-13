//
//  SISettingInfoViewController.h
//  SIrico-FlyRadio
//
//  Created by Ruixin yu on 14-3-29.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "SISuperViewController.h"
#import "MyPageLoadingView.h"

@interface SISettingInfoViewController : SISuperViewController
{
    MyPageLoadingView * loadingView;
    
    NSString * description;
}


@property (nonatomic,assign) int type;

@end
