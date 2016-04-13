//
//  NJSettingKeys.h
//  01-ItcastLottery
//
//  Created by 李南江 on 14-5-10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#define NJDeclareConstStr(name) \
extern NSString *const name;

// 摇一摇机选
NJDeclareConstStr(NJSettingShakeChoose)
// 声音效果
NJDeclareConstStr(NJSettingSoundEffect)

// 开奖推送设置
// 双色球
NJDeclareConstStr(NJSettingAwardPushSSQ)
// 大乐透
NJDeclareConstStr(NJSettingAwardPushDLT)

// 中奖动画
NJDeclareConstStr(NJSettingAwardAnim)

// 比分直播
// 提醒关注的比赛
NJDeclareConstStr(NJSettingScoreShowNoticeCareGame)
// 起始时间
NJDeclareConstStr(NJSettingScoreShowStartTime)
// 结束时间
NJDeclareConstStr(NJSettingScoreShowEndTime)

// 购彩定时提醒
NJDeclareConstStr(NJSettingBuyTimedNotice)