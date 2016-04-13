//
//  FR_Config.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#ifndef SIrico_FlyRadio_FR_Config_h
#define SIrico_FlyRadio_FR_Config_h


#pragma mark - URL


//http://125.76.231.90:8083/api/record.asmx/Yangbenlogin?tel=15252525252
#define YANGBEN_LOGIN_URL  @"/api/record.asmx/Yangbenlogin"
#define CHANNEL_LIST_URI   @"/api/record.asmx/GetChannel"
#define AREA_LIST_URI      @"/api/record.asmx/GetArea"
#define CLASS_LIST_URI     @"/api/record.asmx/GetClass"
#define USER_ITEM_URI      @"/api/record.asmx/GetTerms"
#define ABOUT_US_URI       @"/api/record.asmx/GetAbout"
#define AID_LIST_URI       @"/api/record.asmx/GetAd"
#define CHANNEL_TOP_URI    @"/api/record.asmx/GetChannelTop"
#define CHANNEL_FOR_AREA_URI @"/api/record.asmx/GetChannelForArea"
#define CHANNEL_JMD_URI    @"/api/record.asmx/Getjmd"

#define LISTEN_RECOR_URL   @"/api/record.asmx/AddRecord"
//获取节目评价的内容
#define GET_JMPINGJIA_URL  @"/api/record.asmx/Getjmpingjia"
//Getzcpingjia 获取主持人评价的内容
#define GET_ZCPINGJIA_URL  @"/api/record.asmx/Getzcpingjia"
// 回传评价内容
#define ADD_PINGJIA_URL    @"/api/record.asmx/AddPingJia"

//收藏
#define Get_SHOUCANG_URL   @"/api/record.asmx/Getshoucang"
#define Add_SHOUCANG_URL   @"/api/record.asmx/Addshoucang"
#define Del_SHOUCANG_URL   @"/api/record.asmx/Delshoucang"

//获取用户条款
#define Get_TERMS_URL      @"/api/record.asmx/GetTerms"
//获取关于我们
#define Get_ABOUT_URL      @"/api/record.asmx/GetAbout"

//用户信息
#define Get_USERINFO_URL  @"api/record.asmx/GetUserInfo"
//兑换记录
#define GET_DHJL_URL  @"api/record.asmx/DuiHuanJiLu"
//获取积分
#define GET_ALLJF_URL @"/api/record.asmx/GetJiFen"
//获取礼品
#define GET_LIPIN_URL @"/api/record.asmx/GetLiPin"
//礼品兑换
#define  GET_DHLP_URL @"/api/record.asmx/DuiHuanLiPin"


#define Big_Frame CGRectMake(5, SCREEN_HEIGHT-69, 310, 70)
#define Big_FrameForiOS6 CGRectMake(5, SCREEN_HEIGHT-89, 310, 70)
#define Small_Frame CGRectZero


#define isNetConnected (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) && ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable) ? NO : YES )

#define isWWAN ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == ReachableViaWWAN)?YES:NO


typedef NS_ENUM(NSInteger, ChannelType) {
    ChannelType_Local = 0,
    ChannelType_Top ,
    ChannelType_Collection,
    ChannelType_Internal,
    ChannelType_Foreign,
    ChannelType_Music,
    ChannelType_News,
    ChannelType_Transport,
    ChannelType_Economy,
    ChannelType_Sports,
    ChannelType_Opera,
    ChannelType_Travel,
    ChannelType_AreaChannel
};



#endif
