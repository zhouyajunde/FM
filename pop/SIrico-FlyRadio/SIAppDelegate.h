//
//  SIAppDelegate.h
//  SIrico-FlyRadio
//
//  Created by Jin on 2/28/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

extern float StatusBarHeight;
extern int flag;

@interface SIAppDelegate : UIResponder <UIApplicationDelegate>
{

    UINavigationController * navigationController;
    FMDatabase * database;
    NSTimer *_timer;
    int  count;
    BOOL isFirstRun;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * navigationController;
@property (strong, nonatomic) FMDatabase * database;

+ (FMDatabase *) getDatabase;

@end
