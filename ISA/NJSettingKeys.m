//
//  NJSettingKeys.m
//  01-ItcastLottery
//
//  Created by 李南江 on 14-5-10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
#import <UIKit/UIKit.h>

#define NJDefineConstStr(name) \
NSString *const name = @#name;

// 摇一摇机选
NJDefineConstStr(NJSettingShakeChoose)
// 声音效果
NJDefineConstStr(NJSettingSoundEffect)

// 开奖推送设置
// 双色球
NJDefineConstStr(NJSettingAwardPushSSQ)
// 大乐透
NJDefineConstStr(NJSettingAwardPushDLT)

// 中奖动画
NJDefineConstStr(NJSettingAwardAnim)

// 比分直播
// 提醒关注的比赛
NJDefineConstStr(NJSettingScoreShowNoticeCareGame)
// 起始时间
NJDefineConstStr(NJSettingScoreShowStartTime)
// 结束时间
NJDefineConstStr(NJSettingScoreShowEndTime)

// 购彩定时提醒
NJDefineConstStr(NJSettingBuyTimedNotice)