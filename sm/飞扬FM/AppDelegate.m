//
//  AppDelegate.m
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "AppDelegate.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

#import <CoreLocation/CoreLocation.h>

#import "HMPlayingViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locMgr;
@property(nonatomic,strong)CLGeocoder *geocoder;

@end

@implementation AppDelegate

-(CLGeocoder *)geocoder
{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (CLLocationManager *)locMgr
{
    if (!_locMgr) {
        // 1.创建位置管理器（定位用户的位置）
        self.locMgr = [[CLLocationManager alloc] init];
        
        // 2.设置代理
        self.locMgr.delegate = self;
    }
    return _locMgr;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self dingwei];
    
    //设置代理
    
  //系统偏好设置
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"0" forKey:@"net"];
    
    [defaults synchronize];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [ShareSDK registerApp:@"b522d2d20dfc"
          activePlatforms:@[@(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             //                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:nil];
                             break;
                         default:
                             break;
                     }
                     
                 }
     //     + (void)connectWeChat:(Class)wxApiClass;
     
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                      
                  case SSDKPlatformTypeTencentWeibo:
                      //设置腾讯微博应用信息
                      [appInfo SSDKSetupTencentWeiboByAppKey:@"1104842741"
                                                   appSecret:@"1Zlq4lONfppxUMov"
                                                 redirectUri:@"http://www.sharesdk.cn"];
                      break;
                      
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1104842741"
                                           appKey:@"1Zlq4lONfppxUMov"
                                         authType:SSDKAuthTypeSSO];
                      
                      break;
                      
                  case SSDKPlatformSubTypeQZone:
                      [appInfo SSDKSetupQQByAppId:@"1104842741"
                                           appKey:@"1Zlq4lONfppxUMov"
                                         authType:SSDKAuthTypeBoth];
                      
                      break;
                      
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wxb6dd156639460625" appSecret:@"532db6c60520e6824046ff188f6e09ac"];
                      break;
                      
                  default:
                      break;
              }
          }];

    
    // 设置缓存策略(最多缓存10M的图片)
    [SDImageCache sharedImageCache].maxCacheSize = 1024 * 1024 * 10;

    return YES;
}

-(void)dingwei{
    if ([CLLocationManager locationServicesEnabled]) {
        
        //判断是否ios 8
        
        if([self.locMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locMgr requestAlwaysAuthorization]; // 永久授权
            [self.locMgr requestWhenInUseAuthorization]; //使用中授权
        }
        // 开始定位用户的位置
        [self.locMgr startUpdatingLocation];
        
    } else { // 不能定位用户的位置
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"loc"]=@"";
        dict[@"place"]=@"";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:dict forKey:@"dingwei"];
        //这里建议同步存储到磁盘中，但是不是必须的
        [defaults synchronize];

    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    __block NSString *place = [NSString new];
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
       // 数组里面存放的是CLLocation对象， 一个CLLocation就代表一个位置
    CLLocation *loc = [locations lastObject];
    
    
    NSString *locc = [NSString stringWithFormat:@"%f,%f", loc.coordinate.longitude, loc.coordinate.latitude];

    // 纬度：loc.coordinate.latitude
    // 经度：loc.coordinate.longitude
    NSLog(@"纬度=%f, 经度=%f", loc.coordinate.latitude, loc.coordinate.longitude);
    
    dict[@"loc"]=locc;
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error||placemarks.count==0) {
            //             self.reverdeDetailAddressLabel.text=@"你输入的地址没找到，可能在月球上";
            place=  @"";
        }else//编码成功
        {
            //显示最前面的地标信息
            
            NSDictionary *dic =  [[placemarks objectAtIndex:0] addressDictionary];
            
            place=  [dic objectForKey:@"City"];
            
            dict[@"place"]=place;
            
            NSDictionary *nic = [NSDictionary dictionary];
            
            nic = dict;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:dict forKey:@"dingwei"];
            //这里建议同步存储到磁盘中，但是不是必须的
            [defaults synchronize];

        }
    }];
    
    NSTimeInterval locationAge = -[loc.timestamp timeIntervalSinceNow];
    
    if (locationAge > 1.0){//如果调用已经一次，不再执行
        
        [manager stopUpdatingLocation];
        return;
    }
    
    // 停止更新位置(不用定位服务，应当马上停止定位，非常耗电)
    [manager stopUpdatingLocation];
}

//qq登录
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
 
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if ([[HMPlayingViewController musicView] isPlaying]) {
        // do something...
        NSLog(@"bofang l ");
        
    }else{
      
    }

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 赶紧清除所有的内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    // 赶紧停止正在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}


@end
