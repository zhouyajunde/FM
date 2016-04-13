//
//  SIAppDelegate.m
//  SIrico-FlyRadio
//
//  Created by Jin on 2/28/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIAppDelegate.h"
#import <XMLReader-Arc/XMLReader.h>
#import "SIChannelInfoEntity.h"
#import "SIHomeViewController.h"
#import "SIInitDataViewController.h"
#import "FMDatabaseUtils.h"
#import "SIricoUtils.h"
#import "FMPlayer.h"

//static NSString * const BASE_URL = @"http://125.76.231.90:8083/api/record.asmx";


float StatusBarHeight = 0;
int flag = 0;

@implementation SIAppDelegate
@synthesize navigationController;
@synthesize database;

#pragma mark Self custom mothed

+ (FMDatabase *) getDatabase
{
    SIAppDelegate * appDelegate = (SIAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate) {
        return appDelegate.database;
    }
    return nil;
}


-(void)initSystemInformationOnce
{
    //初始化数据库表，只初始化一次
    NSString * bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSLog(@"bundleVersion::%@",bundleVersion);
    NSString * appFirstStartOfVersionKey = [NSString stringWithFormat:@"first_start_%@",bundleVersion];
    NSNumber * alreadyStartedOnVersion = [[NSUserDefaults standardUserDefaults] objectForKey:appFirstStartOfVersionKey];
    if (!alreadyStartedOnVersion||[alreadyStartedOnVersion boolValue] == NO) {
        NSLog(@"initSystemInformationOnce ...");
        
        //默认设置共享位置、消息推送打开
        [SIricoUtils storeStringInUserDefaults:kSettingOfSoundEffect string:@"isOn"];
        [SIricoUtils storeStringInUserDefaults:kSettingOfLocationShare string:@"isOn"];
        
        //初始化 database once: drop tables,create table structure
        FMDatabaseUtils * fmDatabaseUtils = [[FMDatabaseUtils alloc] init];
        [fmDatabaseUtils initDB:[SIAppDelegate getDatabase]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:appFirstStartOfVersionKey];
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        StatusBarHeight = 20;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    }
    else{
        StatusBarHeight = 0;
    }

    
    [self observeNotification];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    navigationController = [[UINavigationController alloc]init];
	navigationController.navigationBar.barStyle = UIBarStyleDefault;
    // Hidden navigation bar
    [navigationController setNavigationBarHidden:YES];

    // init database object
    FMDatabaseUtils *fmDatabaseUtils = [[FMDatabaseUtils alloc] init];
    self.database = [fmDatabaseUtils createDatabaseIfNeeded];
    self.database.logsErrors = YES;
    // 初始化系统信息
    [self initSystemInformationOnce];

    SIInitDataViewController * indexViewController = [[SIInitDataViewController alloc]init];
    [navigationController pushViewController:indexViewController animated:YES];
	[self.window addSubview:navigationController.view];
    
    
    int x = arc4random() % 100;
    NSLog(@"x====%d",x);
    NSString * tempDeviceId = [NSString stringWithFormat:@"APPIOS%d",x];
    [SIricoUtils storeStringInUserDefaults:kSettingOfTempUserDeviceId string:tempDeviceId];
    
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)observeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer:) name:@"STARTTIMER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer:) name:@"STOPTIMER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimer:) name:@"CHANGETIME" object:nil];
    
    isFirstRun = YES;
    
}


- (void)startTimer:(NSNotification *)noti
{
    DBLog(@"开启定时器收听~~~~");
    
    if (isFirstRun) {
        count = [noti.userInfo[@"totalTime"] intValue] * 60;
        DBLog(@"count=%d",count);
        isFirstRun = NO;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)stopTimer:(NSNotification *)noti
{
    DBLog(@"关闭定时器收听~~~~");
    
    [self resetTimer];
    isFirstRun = YES;
    
}

- (void)changeTimer:(NSNotification *)noti
{
    DBLog(@"时间改变了~~~~");
    DBLog(@"---changTime---%@",noti.userInfo[@"totalTime"]);
    count = [noti.userInfo[@"totalTime"] intValue] * 60;
}

- (void)resetTimer
{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)countDown
{
    count --;
    DBLog(@"count==%d",count);
    
    
    
    if (count == 0) {
        //reset timer
        [self resetTimer];
        //stop player
        [[FMPlayer shareManager] stopPlay];
        //
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"TIMER"];
        
        //set notification  告诉小播放器 按钮变为暂停 然后改变一个标志位。
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_PLAYER_STATUS" object:nil];
        isFirstRun = YES;
    
    }else{
    
        //add 增加倒计时显示
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGECOUNT" object:nil userInfo:@{@"COUNT":[NSNumber numberWithInt:count]}];
        
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[FMPlayer shareManager] isPlaying]) {
        // do something...

    }else{
        [SIricoUtils removeStringFromUserDefaults:kSettingOfListenStartTime];
        [SIricoUtils removeStringFromUserDefaults:kSettingOfCurrentChannelId];
    
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
