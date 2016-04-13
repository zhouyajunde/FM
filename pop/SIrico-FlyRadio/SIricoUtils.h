//
//  BetaTownUtils.h
//  betatown-ios-bhg
//
//  Created by Zhengjun wu on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//消息通知标识
#define NotificationSign_MemberLoginSuccess @"NotificationSign_MemberLoginSuccess"
#define NotificationSign_MemberConcernSuccess @"NotificationSign_MemberConcernSuccess"
#define kNeedUpdateConcern @"kNeedUpdateConcern"

//位置共享设置
#define kSettingOfLocationShare @"kSettingOfLocationShare"

//消息推送设置
#define kSettingOfPushMessage @"kSettingOfPushMessage"

//背景音乐
#define kSettingOfBackgroundSound @"kSettingOfBackgroundSound"

//音效
#define kSettingOfSoundEffect @"kSettingOfSoundEffect"

#define kSettingOfCurrentCity @"kSettingOfCurrentCity"

//用户信息
#define kSettingOfMemberToken @"kSettingOfMemberToken"
#define kSettingOfMemberId @"kSettingOfMemberId"
#define kSettingOfUserDeviceId @"kSettingOfUserDeviceId"
#define kSettingOfTempUserDeviceId @"kSettingOfTempUserDeviceId"
#define kSettingOfUserName     @"kSettingOfUserName"
#define kSettingOfUserPassWord @"kSettingOfUserPassWord"


#define kAPPStoreCurrentVersion @"kAPPStoreCurrentVersion"
#define kIfInvitedTotest @"kIfInvitedTotest"

//收听记录
#define kSettingOfListenStartTime @"kSettingOfListenStartTime"
#define kSettingOfListenEndTime @"kSettingOfListenEndTime"
#define kSettingOfCurrentChannelId @"kSettinyOfCurrentChannelId"

//评分
#define kSettingOfJmPingFen @"kSettingOfJmPingFen"
#define kSettingOfZcPingFen @"kSettingOfZcPingFen"
#define kSettingOfJmPingJia @"kSettingOfJmPingJia"
#define kSettingOfZcPingJia @"kSettingOfZcPingJia"

//收藏
#define kSettingOfCancelChannelId @"kSettingOfCancelChannelId"




@interface SIricoUtils : NSObject<UIAlertViewDelegate>

+ (void) storeLastestUpdateTimeInUserDefaults:(NSString *)stringKey withLastestUpdateTime:(NSString * ) lastestUpdateTime;

+ (NSString *) getLastestUpdateTimeFromUserDefaults:(NSString *)stringKey;

+ (void) storeStringInUserDefaults:(NSString *)stringKey string:(NSString*)string;
+ (NSString *) getStringFromUserDefaults:(NSString *)stringKey;

+ (void) removeStringFromUserDefaults:(NSString *)stringKey;

+ (NSString *) getPhotoLibrary;

+ (void) saveZiPaiImage:(UIImage *)zhiPaiImage;

+ (UIImage *) getZiPaiImage;


+ (UIImage*)imageWithImage:(UIImage*)image  
              scaledToSize:(CGSize)newSize; 

+ (void) saveDIYImage:(UIImage *)diyImage;

+ (NSMutableArray*) findSmallDiyImageList;

+ (void) removeDIYImages;

+ (void) storeIntValueInUserDefaults:(NSString *)stringKey integerValue:(int)intValue;
+ (int) getIntValueFromUserDefaults:(NSString *)stringKey;

//获得当前的版本号
+ (NSString *) getAppClientVersion;

//获得服务器的APP版本号
+ (NSString *) getAppServerVersion;

- (void) showAppVersionAlertView;

+ (NSString *)getSubString:(NSString *)strSource WithCharCounts:(NSInteger)number;

//+ (int)calcStrWordCount:(NSString *)str;

@end
