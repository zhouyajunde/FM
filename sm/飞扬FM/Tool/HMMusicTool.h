//
//  HMMusicTool.h
//  02-黑马音乐
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//  管理音乐数据（音乐模型）

#import <Foundation/Foundation.h>
@class scModel;

@interface HMMusicTool : NSObject
/**
 *  返回所有的歌曲
 */
+ (NSArray *)musics;

+ (void)setAllMusic:(NSArray *)NarryMusic;

/**
 *  返回正在播放的歌曲
 */
+ (scModel *)playingMusic;
+ (void)setPlayingMusic:(scModel *)playingMusic;

/**
 *  下一首歌曲
 */
+ (scModel *)nextMusic;

/**
 *  上一首歌曲
 */
+ (scModel *)previousMusic;

//最近收藏的
+(NSString *)shouCang;

+(void)setshouCang:(NSString*)shoucang;

/*
 聊天自己的消息
 */
+ (NSArray *)liaotianMessage;

+ (void)setAllliaotianMessage:(NSArray *)NarryliaotianMessage;





@end
